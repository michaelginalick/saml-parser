# frozen_string_literal: true

require 'openssl'
require './lib/saml_parser/error_messages'
require './lib/saml_parser/nodes_of_interest'
class DigestNotSupported < StandardError; end

class XmlParser
  SUPPORTED_DIGESTS = %w[MD4 MD5 RIPEMD160 SHA1 SHA224 SHA256 SHA384 SHA512].freeze
  DEFAULT_DIGEST = 'SHA256'
  EXCLUDED_DOMAIN_VALUES = %w[asp idp net com org edu id].freeze
  NAME_ID_FORMAT = 'nameid-format'

  attr_reader :options, :xml_document
  attr_accessor :cert_fingerprint, :entity_id, :sso_target_url, :domain, :name_id_format, :errors, :digest

  # @param format [Nokogiri::XML Object]
  def initialize(xml_document, options = {})
    @xml_document = xml_document
    @options = options
    @errors = []
    @digest = validate_digest

    raise DigestNotSupported unless @errors.empty?
  end

  # @return [XmlParser Object]
  def parse
    @cert_fingerprint = extract_fingerprint(xml_document)
    @entity_id = extract_entity_id(xml_document)
    @sso_target_url = extract_sso_target_url(xml_document)
    @domain = extract_domain(entity_id)
    @name_id_format = extract_name_id_format(xml_document)

    self
  end

  # @return [Boolean]
  def ok?
    errors.empty?
  end

  private

  def extract_fingerprint(xml_document)
    generate_finger_print(xml_document.at(NodesOfInterest::NODES[:x590_certificate])&.text)
  end

  def generate_finger_print(certificate)
    return errors << ErrorMessages::MESSAGE_MAPPINGS[:x590_certificate_not_found] if certificate.nil?

    build_digest.hexdigest(build_cert(certificate).to_der).scan(/../).map(&:upcase).join(':')
  end

  def build_cert(certificate)
    OpenSSL::X509::Certificate.new("-----BEGIN CERTIFICATE-----\n#{certificate}\n-----END CERTIFICATE-----")
  end

  def build_digest
    OpenSSL::Digest(digest)
  end

  def extract_entity_id(xml_document)
    entity_id = xml_document.at(NodesOfInterest::NODES[:entity_descriptor])
    if entity_id&.attributes
      entity_id = entity_id.attributes[NodesOfInterest::NODES[:entity_id]]
    end
    return entity_id.text if entity_id

    errors << ErrorMessages::MESSAGE_MAPPINGS[:entity_id_not_found]
  end

  def extract_sso_target_url(xml_document)
    ssos = xml_document.at(NodesOfInterest::NODES[:single_sign_on_service])
    if ssos&.attributes
      ssos = ssos.attributes[NodesOfInterest::NODES[:location]]
    end
    return ssos.text if ssos

    errors << ErrorMessages::MESSAGE_MAPPINGS[:sso_target_url_not_found]
  end

  def extract_domain(entity_id)
    return errors << ErrorMessages::MESSAGE_MAPPINGS[:entity_id_not_found] if entity_id.nil?

    host = URI.parse(entity_id)&.host
    return errors << ErrorMessages::MESSAGE_MAPPINGS[:domain_not_found] if host.nil?

    accepted_values = host.split('.').reject { |host_val| EXCLUDED_DOMAIN_VALUES.include?(host_val) }

    accepted_values[0]
  end

  def extract_name_id_format(xml_document)
    xml_document.xpath(NodesOfInterest::NODES[:name_id_format])&.each do |selector|
      return selector.text if selector.text.include?(NAME_ID_FORMAT)
    end
    @errors << ErrorMessages::MESSAGE_MAPPINGS[:name_id_not_found]
  end

  def validate_digest
    digest = options[:digest_algorithm] || DEFAULT_DIGEST
    errors << digest_error_message unless supported_digest?(digest)

    digest
  end

  def supported_digest?(digest)
    SUPPORTED_DIGESTS.include?(digest)
  end

  def digest_error_message
    "#{ErrorMessages::MESSAGE_MAPPINGS[:digest_not_found]} #{SUPPORTED_DIGESTS}"
  end
end

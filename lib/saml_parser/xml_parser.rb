# frozen_string_literal: true

require 'openssl'
require './lib/saml_parser/error_messages'
require './lib/saml_builder'

class DigestNotSupported < StandardError; end

class XmlParser
  SUPPORTED_DIGESTS = %w[MD4 MD5 RIPEMD160 SHA1 SHA224 SHA256 SHA384 SHA512].freeze

  attr_reader :xml_document, :saml_builder
  attr_accessor :cert_fingerprint, :entity_id, :sso_target_url, :domain, :name_id_format, :errors, :digest

  # @param format [Nokogiri::XML Object, SamlBuilder Object]
  def initialize(xml_document, saml_builder)
    @xml_document = xml_document
    @saml_builder = saml_builder
    @errors = []
    validate_digest

    raise DigestNotSupported unless @errors.empty?
  end

  # @return [XmlParser Object]
  def parse
    @cert_fingerprint = extract_fingerprint
    @entity_id = extract_entity_id
    @sso_target_url = extract_sso_target_url
    @domain = extract_domain
    @name_id_format = extract_name_id_format

    self
  end

  # @return [Boolean]
  def ok?
    errors.empty?
  end

  private

  def extract_fingerprint
    generate_finger_print(xml_document.at(saml_builder.certificate)&.text)
  end

  def generate_finger_print(certificate)
    return errors << ErrorMessages::MESSAGE_MAPPINGS[:x590_certificate_not_found] if certificate.nil?

    build_digest.hexdigest(build_cert(certificate).to_der).scan(/../).map(&:upcase).join(':')
  end

  def build_cert(certificate)
    OpenSSL::X509::Certificate.new("-----BEGIN CERTIFICATE-----\n#{certificate}\n-----END CERTIFICATE-----")
  end

  def build_digest
    OpenSSL::Digest(@saml_builder.digest_algorithm)
  end

  def extract_entity_id
    entity_id = xml_document.at(saml_builder.entity_descriptor)
    if entity_id&.attributes
      entity_id = entity_id.attributes[saml_builder.entity_id]
    end
    return entity_id.text if entity_id

    errors << ErrorMessages::MESSAGE_MAPPINGS[:entity_id_not_found]
  end

  def extract_sso_target_url
    ssos = xml_document.at(saml_builder.single_sign_on_service)
    if ssos&.attributes
      ssos = ssos.attributes[saml_builder.location]
    end
    return ssos.text if ssos

    errors << ErrorMessages::MESSAGE_MAPPINGS[:sso_target_url_not_found]
  end

  def extract_domain
    return errors << ErrorMessages::MESSAGE_MAPPINGS[:entity_id_not_found] if entity_id.nil?

    host = URI.parse(entity_id)&.host
    return errors << ErrorMessages::MESSAGE_MAPPINGS[:domain_not_found] if host.nil?

    domains = saml_builder.excluded_domains || []
    accepted_values = host.split('.').reject { |host_val| domains.include?(host_val) }

    accepted_values[0]
  end

  def extract_name_id_format
    xml_document.xpath(saml_builder.name_id_format_path)&.each do |selector|
      return selector.text if selector.text.include?(saml_builder.name_id_format)
    end
    @errors << ErrorMessages::MESSAGE_MAPPINGS[:name_id_not_found]
  end

  def validate_digest
    errors << digest_error_message unless supported_digest?
  end

  def supported_digest?
    SUPPORTED_DIGESTS.include?(@saml_builder.digest_algorithm)
  end

  def digest_error_message
    "#{ErrorMessages::MESSAGE_MAPPINGS[:digest_not_found]} #{SUPPORTED_DIGESTS}"
  end
end

# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'ssrf_filter'
require 'nokogiri'
require './lib/saml_parser/error_messages'
require 'byebug'

class FetchXml
  DEFAULT_HEADERS = {
    'Content-Type' => 'text/xml'
  }.freeze

  SUCCESS_RESPONSE = 200
  MAX_REDIRECTS = 2

  attr_reader :metadata_url
  attr_accessor :document, :errors

  def initialize(metadata_url)
    @metadata_url = metadata_url
    @errors = [{}]
  end

  # @return [FetchXml Object]
  def fetch
    xml_document = fetch_xml_page
    @document = parse_xml(xml_document)

    self
  end

  # Used to check if the instance generated any errors.
  # @return [Boolean]
  def ok?
    errors.all?(&:empty?)
  end

  private

  # Handles the request. Using SsrfFilter to avoid Ssrf attacks
  # @return [String] the resulting XML document body
  def fetch_xml_page
    response = SsrfFilter.get(metadata_url,
      headers: DEFAULT_HEADERS,
      max_redirects: MAX_REDIRECTS,
      http_options: {
        open_timeout: 2,
        read_timeout: 5
      })

    if response.code.to_i != SUCCESS_RESPONSE
      handle_error(ErrorMessages::MESSAGE_MAPPINGS[:unsuccessful_response_code], response.message)
      return errors
    end

    response.body
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    handle_error(ErrorMessages::MESSAGE_MAPPINGS[:http_timeout], error: e.message)
  rescue URI::InvalidURIError,
         SsrfFilter::InvalidUriScheme,
         SsrfFilter::PrivateIPAddress,
         SsrfFilter::Error,
         SsrfFilter::UnresolvedHostname,
         SsrfFilter::TooManyRedirects,
         SsrfFilter::CRLFInjection => e
    handle_error(ErrorMessages::MESSAGE_MAPPINGS[:http_error], error: e.message)
  end

  # Handles a request
  # @param xml document [String]
  # @return [Nokogiri::XML Object]
  def parse_xml(xml)
    response_xml = Nokogiri::XML(xml)

    unless response_xml.errors.empty?
      errors << ErrorMessages::MESSAGE_MAPPINGS[:invalid_xml]
      return
    end
    response_xml.remove_namespaces!
  end


  def handle_error(user_message, error)
    errors << { user_message: user_message, error: error }
  end
end

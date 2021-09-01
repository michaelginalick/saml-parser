# frozen_string_literal: true

require './lib/saml_parser/fetch_xml'
require './lib/saml_parser/xml_parser'
require './lib/saml_parser/error_messages'

class SamlParse
  # Accepts a SAML metadata link, parses the returned XML document,
  # with a generated X509 Certificate.
  #
  # @param format [String] a metadata url
  # @param format [Hash] key :digest_algorithm. Optional agr. Defaults to SHA256
  # @return [XmlParser Object].
  def self.parse(metadata_url, options = {})
    xml_document_object = FetchXml.new(metadata_url).fetch

    if xml_document_object.ok?
      parsed_saml_object = XmlParser.new(xml_document_object.document, options).parse
    else
      return xml_document_object.errors
    end

    parsed_saml_object
    rescue DigestNotSupported => _e
      { user_message: ErrorMessages::MESSAGE_MAPPINGS[:digest_not_supported],  error: XmlParser::SUPPORTED_DIGESTS.join(', ') }
  end
end

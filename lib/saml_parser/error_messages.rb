# frozen_string_literal: true

class ErrorMessages
  MESSAGE_MAPPINGS = {
    digest_not_supported: 'Digest not supported. Must be one of: ',
    unsuccessful_response_code: 'The provided metadata url responded with an unsuccessful status code.',
    http_timeout: 'The provided metadata url took too long to respond.',
    http_error: 'Could not contact the provided metadata url.',
    invalid_xml: 'Unable to parse invalid XML.',
    x590_certificate_not_found: 'Unable to find X509Certificate.',
    entity_id_not_found: 'Unable to find Entity Id.',
    sso_target_url_not_found: 'Unable to find SSO target url.',
    domain_not_found: 'Unable to find domain.',
    name_id_not_found: 'Unable to find Name Id format.',
    digest_not_found: 'Digest must be one of '
  }.freeze
end

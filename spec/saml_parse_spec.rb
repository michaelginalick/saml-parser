# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'
require 'cgi'

RSpec.describe SamlParse do
  def squish!(str)
    str.gsub!(/\A[[:space:]]+/, '')
    str.gsub!(/[[:space:]]+\z/, '')
    str.gsub!(/[[:space:]]+/, ' ')
    str
  end

  xml_document = "<md:EntityDescriptor xmlns:md='urn:oasis:names:tc:SAML:2.0:metadata'
  entityID='https://example.net/admin' ID='_1204c7ef-6a61-40b1-a197-4892f3abf1c7'>
  <md:IDPSSODescriptor ID='_98b685a3-b100-4a5d-a3a9-0dc98f16151f'
  protocolSupportEnumeration='urn:oasis:names:tc:SAML:2.0:protocol' WantAuthnRequestsSigned='true'>
  <md:KeyDescriptor>
    <KeyInfo xmlns='http://www.w3.org/2000/09/xmldsig#'>
      <X509Data>
        <X509Certificate>
          MIIG4TCCBcmgAwIBAgIJAKWG+MI0lK9uMA0GCSqGSIb3DQEBCwUAMIHGMQswCQYDVQQGEwJVUzEQMA4GA1UECBMHQX
          Jpem9uYTETMBEGA1UEBxMKU2NvdHRzZGFsZTElMCMGA1UEChMcU3RhcmZpZWxkIFRlY2hub2xvZ2ll
          cywgSW5jLjEzMDEGA1UECxMqaHR0cDovL2NlcnRzLnN0YXJmaWVsZHRlY2guY29tL3JlcG9zaXRvcnk
          vMTQwMgYDVQQDEytTdGFyZmllbGQgU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eSAtIEcyMB4XDTIwMDIwMzE2MDY
          zMloXDTIyMDQwODE5NDM0MFowPjEhMB8GA1UECxMYRG9tYWluIENvbnRyb2wgVmFsaWRhdGVkMRkwFwY
          DVQQDDBAqLmFzcC5hZXJpZXMubmV0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAonWof8D9h70D
          McLYuj0p8xgUTnfBnaDDJBG2ziYleGpkYrRbY58rDQ35REFZ1R0qb+q1PGXGVTkQ/aq+xhtrXj5p3sYoNM0p
          NuBGZjw0vz/gYRtHrzZi+vAmszVpHayWGQWdzKutIf0U7razheCspcXMSVXm5WxvvAlTLHyxXB4TxSvLzoXw2
          emFXzYqGOJ0oHl7Wwnq4LrEbzG5HIla3RBp+N/9G8aTw0zj3nLYuuFEDioPxBukphO7zE8vHbhqFfIJvTSILr
          T8uP0tUkPpr3AU8Ed6Hhvrqre5K8aL5ymGNyrhBsIzdtcQtIQTgbZvLZw+JwGMIRux50+xsDmguwIDAQABo4IDV
          zCCA1MwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDgYDVR0PAQH/BAQDAgWgMD0
          GA1UdHwQ2MDQwMqAwoC6GLGh0dHA6Ly9jcmwuc3RhcmZpZWxkdGVjaC5jb20vc2ZpZzJzMS0xNzQuY3JsMGMGA1UdI
          ARcMFowTgYLYIZIAYb9bgEHFwEwPzA9BggrBgEFBQcCARYxaHR0cDovL2NlcnRpZmljYXRlcy5zdGFyZmllbGR0ZWNo
          LmNvbS9yZXBvc2l0b3J5LzAIBgZngQwBAgEwgYIGCCsGAQUFBwEBBHYwdDAqBggrBgEFBQcwAYYeaHR0cDovL29jc3A
          uc3RhcmZpZWxkdGVjaC5jb20vMEYGCCsGAQUFBzAChjpodHRwOi8vY2VydGlmaWNhdGVzLnN0YXJmaWVsZHRlY2guY29t
          L3JlcG9zaXRvcnkvc2ZpZzIuY3J0MB8GA1UdIwQYMBaAFCVFgWhQJjg9Oy0svs1q2bY9s2ZjMCsGA1UdEQQkMCKCECouY
          XNwLmFlcmllcy5uZXSCDmFzcC5hZXJpZXMubmV0MB0GA1UdDgQWBBTZPX+QDwxYg6Wxzlb/oretBEQpBzCCAXwGCisGAQ
          QB1nkCBAIEggFsBIIBaAFmAHYApLkJkLQYWBSHuxOizGdwCjw1mAT5G9+443fNDsgN3BAAAAFwC820hAAABAMARzBFAiEA8IR
          duI5xvxzKBwgARHYOSJvxmfSZYJ+yY+abxQTuB7QCIHqy6D9pDYUSNFaWA5Xxg/8VoJ3nqspYjFU5jBQ3x45pAHUA7ku9t3XOY
          LrhQmkfq+GeZqMPfl+wctiDAMR7iXqo/csAAAFwC821zAAABAMARjBEAiBw6u2EZVUjZGFXgDs20FFAwp+/Y2sPG/w4Q5e1Tprf
          QwIgZ+fLBS8CQTg70TSGTx1+GL91CzG7Y0iiQwrOVQ69WNQAdQBWFAaaL9fC7NP14b1Esj7HRna5vJkRXMDvlJhV1on
          Q3QAAAXALzbfKAAAEAwBGMEQCIGLd4p6zqzFtRCZw9qhKhhS2tFz0GoHWR6Bu7xYe50+lAiAIEJQul30NTzIe8sI7Gq
          Bqtpg1SPlhOGDaj1PeuWoolTANBgkqhkiG9w0BAQsFAAOCAQEAj8AI2ZI4n8kuwTasCtH2h+cL4FxLA1NoHBaTuGdo
          11jADYPaUm0zFdEKBpa1lndrEiw6rFkjVV3tmQcNTzteKVq2uLPIjqsqwzzAyE165Nv0yeiA4fRq1uBbz883lElogb
          YeltO4KGGEzMOUO1om1dsgJ/vY0KrwdYgHjsGv1wIsQ6eaQApJ+KJFA7lE5QhEAmlVvR0bSArRtK+X/wn7FVKJIOg4
          yj8qSkxSxNlBg8naSbKfB7Wg9xgCT/EBLH43KTFSo5pTFnm1rLOm1c6/nCVwcwigbjWzFdV8C6jDhprbqG9cYd9I6QC60Qr
          7xyBFEUvvKRac8fDHKoIiDgXeIg==
        </X509Certificate>
      </X509Data>
    </KeyInfo>
  </md:KeyDescriptor>
  <md:NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress</md:NameIDFormat>
  <md:SingleSignOnService Binding='urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'
  Location='https://example.net/admin/Security/SAML/SSOService'/>
  <md:SingleSignOnService Binding='urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'
  Location='https://example.net/admin/Security/SAML/SSOService'/>
  </md:IDPSSODescriptor>
  </md:EntityDescriptor>"

  before do
    allow(SsrfFilter).to receive(:get).and_return(OpenStruct.new(code: 200, body: squish!(xml_document.dup)))
  end

  context 'when default' do
    describe 'parse' do
      it 'will return an instance with the expected attributes' do
        result = described_class.parse(xml_document)
        %i[cert_fingerprint entity_id sso_target_url domain name_id_format].each do |attr|
          expect(result.respond_to?(attr)).to eq(true)
        end
      end

      it 'will encode the X509 certificate to a formatted finger print' do
        result = described_class.parse(xml_document)
        fingerprint = 'AE:D9:5C:EE:6E:00:8F:30:55:18:EE:FE:89:A6:A5:E1:17:9A:EA:89:F0:AF:02:62:58:AC:26:CA:E4:E3:98:9A'
        expect(result.cert_fingerprint).to eq(fingerprint)
      end

      it 'will parse out and return the entity_id' do
        result = described_class.parse(xml_document)
        expect(result.entity_id).to eq('https://example.net/admin')
      end

      it 'will parse out and return the domain' do
        result = described_class.parse(xml_document)

        expect(result.domain).to eq('example')
      end

      it 'will parse out and return the sso_target_url' do
        result = described_class.parse(xml_document)

        expect(result.sso_target_url).to eq('https://example.net/admin/Security/SAML/SSOService')
      end

      it 'will parse out and return the name_id_format' do
        result = described_class.parse(xml_document)

        expect(result.name_id_format).to eq('urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress')
      end
    end
  end

  context 'with digist specified' do
    it 'will encode the X509 certificate to a formatted finger print' do
      result = described_class.parse(xml_document, digest_algorithm: 'MD5')
      fingerprint = 'E6:22:36:27:B4:34:10:6C:47:26:D3:9F:9D:22:71:F3'

      expect(result.cert_fingerprint).to eq(fingerprint)
    end
  end

  context 'with unknown digest' do
    it 'will raise the expected exception' do
      allow(described_class).to receive(:parse) { DigestNotSupported.new('Digest not supported') }
      error = described_class.parse(xml_document, digest_algorithm: 'Foo')

      expect(error.message).to match(/Digest not supported/)
    end
  end
end

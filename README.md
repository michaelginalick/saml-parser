[![Gem Version](https://badge.fury.io/rb/saml_parser.svg)](https://badge.fury.io/rb/saml_parser)

# SamlParser

SAML parsing tool built with ruby. SAML configurations may vary based on your specific needs however,
some elements are required to get SAML working for your application. SAML is an open spec, and
exchanges data via XML documents. This library will parse out the essential elements from the IDP
metadata URL to assist you in getting the provider integrated into your system.


## Installation

Add it to your `Gemfile`:

```ruby
gem 'saml_parser'
```

Or install it manually:

```sh
gem install saml_parser
```

## Usage

```ruby
instance = SamlParse.parse("https://your-providers-metadata-link", {})

# Methods
instance.ok?
instance.cert_fingerprint
instance.digest
instance.domain
instance.entity_id
instance.name_id_format
instance.sso_target_url
instance.xml_document
```
Note you may pass an optional digest algorithm as a second parameter in the form of a hash
with a key of `digest_algorithm`. The value you pass must be included in the following options
`MD4 MD5 RIPEMD160 SHA1 SHA224 SHA256 SHA384 SHA512`. It will default to `SHA256` if nothing is passed.



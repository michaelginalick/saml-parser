[![Gem Version](https://badge.fury.io/rb/saml_parser.svg)](https://badge.fury.io/rb/saml_parser)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/a0a9821025ec4c6a95987ee2f03f745f)](https://www.codacy.com/gh/michaelginalick/saml-parser/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=michaelginalick/saml-parser&amp;utm_campaign=Badge_Grade)
[![Codacy Badge](https://app.codacy.com/project/badge/Coverage/a0a9821025ec4c6a95987ee2f03f745f)](https://www.codacy.com/gh/michaelginalick/saml-parser/dashboard?utm_source=github.com&utm_medium=referral&utm_content=michaelginalick/saml-parser&utm_campaign=Badge_Coverage)
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
instance = SamlParse.parse("https://your-providers-metadata-link", SamlBuilder.with_all_defaults)

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
Note you must pass an instance of a `SamlBuilder` object. This class uses the builder pattern allowing you to set various attributes on the object. You may also use the `with_all_defaults` to use all default values.

# frozen_string_literal: true

require './lib/saml_parser/default_nodes'

class SamlBuilder
  attr_accessor :entity_descriptor, :single_sign_on_service, :digest_algorithm,
    :name_id_format, :location, :entity_id, :certificate, :name_id_format_path,
    :excluded_domains,
    def initialize
    end

  class << self
    def with_all_defaults
      inst = new
      inst.excluded_domains = %w[asp idp net com org edu id].freeze
      inst.digest_algorithm = 'SHA256'
      inst.entity_descriptor = DefaultNodes::NODES[:entity_descriptor]
      inst.name_id_format_path = DefaultNodes::NODES[:name_id_format]
      inst.name_id_format = 'nameid-format'
      inst.single_sign_on_service = DefaultNodes::NODES[:single_sign_on_service]
      inst.location = DefaultNodes::NODES[:location]
      inst.entity_id = DefaultNodes::NODES[:entity_id]
      inst.certificate = DefaultNodes::NODES[:x590_certificate]

      inst
    end

    def build
      inst = new
      inst.excluded_domains = @excluded_domains
      inst.digest_algorithm = @digest_algorithm
      inst.entity_descriptor = @entity_descriptor
      inst.name_id_format_path = @name_id_format_path
      inst.name_id_format = @name_id_format
      inst.single_sign_on_service = @single_sign_on_service
      inst.location = @location
      inst.entity_id = @entity_id
      inst.certificate = @certificate

      inst
    end

    def with_excluded_domains(domains)
      @excluded_domains = domains
      self
    end

    def with_digest_algorithm(digest_algorithm)
      @digest_algorithm = digest_algorithm
      self
    end

    def with_entity_descriptor_path(entity_descriptor_path)
      @entity_descriptor = entity_descriptor_path
      self
    end

    def single_sign_on_service_path(single_sign_on_service)
      @single_sign_on_service = single_sign_on_service
      self
    end

    def with_name_id_format_path(name_id_format_path)
      @name_id_format_path = name_id_format_path
      self
    end

    def with_name_id_format(name_id_format)
      @name_id_format = name_id_format
      self
    end

    def with_location_path(location)
      @location = location
      self
    end

    def with_entity_id_path(entity_id)
      @entity_id = entity_id
      self
    end

    def with_certificate_path(certificate)
      @certificate = certificate
      self
    end
  end
end

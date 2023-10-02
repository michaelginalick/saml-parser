# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SamlBuilder do
  context 'with with_default_values' do
    it 'will set all the default values of the class' do
      res = described_class.with_all_defaults
      %i[excluded_domains digest_algorithm
         entity_descriptor name_id_format_path
         name_id_format single_sign_on_service
         location entity_id certificate].each do |attr|
        expect(res.send(attr)).not_to be_nil
      end
    end
  end

  context 'with builder methods' do
    it 'will set excluded_domains and return self' do
      res = described_class.with_excluded_domains(['.com'])

      expect(res.build.excluded_domains).to eq(['.com'])
      expect(res).to eq(described_class)
    end

    it 'will set digest_algorithm and return self' do
      res = described_class.with_digest_algorithm('SHA256')

      expect(res.build.digest_algorithm).to eq('SHA256')
      expect(res).to eq(described_class)
    end

    it 'will set with_entity_descriptor_path and return self' do
      res = described_class.with_entity_descriptor_path('//DESCR')

      expect(res.build.entity_descriptor).to eq('//DESCR')
      expect(res).to eq(described_class)
    end

    it 'will set single_sign_on_service_path and return self' do
      res = described_class.single_sign_on_service_path('//DESCR')

      expect(res.build.single_sign_on_service).to eq('//DESCR')
      expect(res).to eq(described_class)
    end

    it 'will set with_name_id_format_path and return self' do
      res = described_class.with_name_id_format_path('//DESCR')

      expect(res.build.name_id_format_path).to eq('//DESCR')
      expect(res).to eq(described_class)
    end

    it 'will set with_name_id_format and return self' do
      res = described_class.with_name_id_format('name-id-format')

      expect(res.build.name_id_format).to eq('name-id-format')
      expect(res).to eq(described_class)
    end

    it 'will set with_location_path and return self' do
      res = described_class.with_location_path('//DESCR')

      expect(res.build.location).to eq('//DESCR')
      expect(res).to eq(described_class)
    end

    it 'will set with_entity_id_path and return self' do
      res = described_class.with_entity_id_path('//DESCR')

      expect(res.build.entity_id).to eq('//DESCR')
      expect(res).to eq(described_class)
    end

    it 'will set with_certificate_path and return self' do
      res = described_class.with_certificate_path('//X509')

      expect(res.build.certificate).to eq('//X509')
      expect(res).to eq(described_class)
    end
  end

  context 'with build' do
    it 'will build an instance of the class from the builder' do
      res = described_class.with_certificate_path('//X509')
        .with_entity_id_path('//DESCR')
        .with_location_path('//DESCR')
        .with_name_id_format('name-id-format')
        .with_name_id_format_path('//DESCR')
        .single_sign_on_service_path('//DESCR')
        .with_entity_descriptor_path('//DESCR')
        .with_digest_algorithm('SHA256')
        .with_excluded_domains(['.com'])

      expect(res.build.class).to eq(described_class)
    end
  end
end

# frozen_string_literal: true

# spec/serializers/api/v1/application_serializer_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::ApplicationSerializer, type: :serializer do
  let(:serializer) { described_class.new(application) }
  let(:serialized_json) { JSON.parse(serializer.serializable_hash.to_json) }
  let(:last_interviewed_at) { Time.current.strftime('%Y-%m-%d %H:%M:%S') }
  let(:application) do
    double('ApplicationObject',
           id: 1,
           candidate_name: 'Josefa Windler',
           status: 'active',
           notes_count: 2,
           last_interviewed_at: last_interviewed_at,
           read_attribute_for_serialization: ->(attr) { send(attr) })
  end

  before do
    allow(application).to receive(:job).and_return(double(title: 'Software Engineer'))
  end

  it 'includes the expected attributes' do
    expect(serialized_json.keys).to contain_exactly('id', 'job_name', 'candidate_name', 'status', 'notes',
                                                    'last_interviewed_at')
  end

  it 'serializes job_name correctly' do
    expect(serialized_json['job_name']).to eq('Software Engineer')
  end

  it 'serializes candidate_name correctly' do
    expect(serialized_json['candidate_name']).to eq(application.candidate_name)
  end

  it 'serializes notes correctly' do
    expect(serialized_json['notes']).to eq(application.notes_count)
  end

  it 'serializes status correctly' do
    expect(serialized_json['status']).to eq(application.status)
  end

  it 'serializes last_interviewed_at correctly' do
    expect(serialized_json['last_interviewed_at']).to eq(last_interviewed_at)
  end
end

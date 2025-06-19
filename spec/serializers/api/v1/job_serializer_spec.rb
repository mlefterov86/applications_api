# frozen_string_literal: true

# spec/serializers/api/v1/job_serializer_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::JobSerializer, type: :serializer do
  let(:job) do
    double('Job', id: 1, title: 'Software Engineer', status: 'active', hired_count: 3, rejected_count: 2,
                  ongoing_count: 5)
  end
  let(:serializer) { described_class.new(job) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:serialized_json) { JSON.parse(serializer.serializable_hash.to_json) }

  it 'includes the expected attributes' do
    expect(serialized_json.keys).to contain_exactly('id', 'name', 'status', 'hired_candidates', 'rejected_candidates',
                                                    'ongoing_applications')
  end

  it 'serializes name correctly' do
    expect(serialized_json['name']).to eq(job.title)
  end

  it 'serializes status correctly' do
    expect(serialized_json['status']).to eq(job.status)
  end

  it 'serializes hired_candidates correctly' do
    expect(serialized_json['hired_candidates']).to eq(job.hired_count)
  end

  it 'serializes rejected_candidates correctly' do
    expect(serialized_json['rejected_candidates']).to eq(job.rejected_count)
  end

  it 'serializes ongoing_applications correctly' do
    expect(serialized_json['ongoing_applications']).to eq(job.ongoing_count)
  end
end

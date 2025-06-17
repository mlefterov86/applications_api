# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Event, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job) }
  end

  describe 'database' do
    it 'has the correct database table' do
      expect(described_class.table_name).to eq('job_events')
    end

    it { is_expected.to have_db_column(:type).of_type(:string) }
    it { is_expected.to have_db_column(:job_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end
end

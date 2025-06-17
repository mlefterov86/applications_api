# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Event, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:application) }
  end

  describe 'database' do
    it 'has the correct table name' do
      expect(described_class.table_name).to eq('application_events')
    end

    it { is_expected.to have_db_column(:type).of_type(:string) }
    it { is_expected.to have_db_column(:application_id).of_type(:integer) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end
end

# == Schema Information
#
# Table name: application_events
#
#  id             :integer          not null, primary key
#  type           :string
#  content        :text
#  application_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

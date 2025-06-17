# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Event::Interview, type: :model do
  describe 'inheritance' do
    it 'inherits from Application::Event' do
      expect(described_class < Application::Event).to be true
    end
  end

  it 'has an alias for interview_date' do
    event = build(:application_event_interview)
    expect(event.interview_date).to eq(event.created_at)
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

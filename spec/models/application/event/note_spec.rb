# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Event::Note, type: :model do
  describe 'inheritance' do
    it 'inherits from Application::Event' do
      expect(described_class < Application::Event).to be true
    end
  end

  describe 'validations' do
    it 'validates presence of content' do
      event = build(:application_event_note, content: nil)
      expect(event).not_to be_valid
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job::Event::Deactivated, type: :model do
  describe 'inheritance' do
    it 'inherits from Job::Event' do
      expect(described_class < Job::Event).to be true
    end
  end
end

# == Schema Information
#
# Table name: job_events
#
#  id         :integer          not null, primary key
#  type       :string
#  job_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

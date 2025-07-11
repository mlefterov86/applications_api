# frozen_string_literal: true

class Application
  class Event < ApplicationRecord
    self.table_name = 'application_events'

    belongs_to :application
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

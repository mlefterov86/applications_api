# frozen_string_literal: true

class Application
  class Event < ApplicationRecord
    self.table_name = 'application_events'

    belongs_to :application
  end
end

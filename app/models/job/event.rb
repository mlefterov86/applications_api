# frozen_string_literal: true

class Job
  class Event < ApplicationRecord
    self.table_name = 'job_events'
    belongs_to :job
  end
end

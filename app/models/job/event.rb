# frozen_string_literal: true

class Job
  class Event < ApplicationRecord
    self.table_name = 'job_events'
    belongs_to :job
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

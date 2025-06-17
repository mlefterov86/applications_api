# frozen_string_literal: true

class Job < ApplicationRecord
  has_many :events, class_name: 'Job::Event', dependent: :destroy
  has_many :applications, dependent: :destroy

  scope :active, lambda {
    joins(:events)
      .where(
        events: {
          created_at: Job::Event.select('MAX(created_at)').where('job_events.job_id = jobs.id').group(:job_id),
          type: 'Job::Event::Activated'
        }
      )
  }

  scope :deactivated, lambda {
    joins(:events)
      .where(
        events: {
          created_at: Job::Event.select('MAX(created_at)').where('job_events.job_id = jobs.id').group(:job_id),
          type: 'Job::Event::Deactivated'
        }
      )
  }

  def status
    last_event = events.order(created_at: :desc).first
    case last_event&.type
    when 'Job::Event::Activated' then 'activated'
    else 'deactivated'
    end
  end

  def last_interview_date
    self.class.joins(applications: :events)
        .where(events: { type: 'Application::Event::Interview' })
        .order('events.created_at DESC')
        .limit(1)
        .pick('events.created_at')
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

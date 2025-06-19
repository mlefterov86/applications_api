# frozen_string_literal: true

class Job < ApplicationRecord
  has_many :events, class_name: 'Job::Event', dependent: :destroy
  has_many :applications, dependent: :destroy

  scope :joins_latest_events, lambda {
    joins(<<~SQL.squish)
      INNER JOIN (
        SELECT job_id, MAX(created_at) AS max_created_at
        FROM job_events
        GROUP BY job_id
      ) latest_events ON latest_events.job_id = jobs.id
    SQL
      .joins(<<~SQL.squish)
        INNER JOIN job_events ON job_events.job_id = jobs.id
        AND job_events.created_at = latest_events.max_created_at
      SQL
  }

  scope :active, lambda {
    joins_latest_events
      .where("job_events.type = 'Job::Event::Activated'")
  }

  scope :deactivated, lambda {
    joins_latest_events
      .where("job_events.type = 'Job::Event::Deactivated'")
  }

  scope :with_recent_application_events, lambda {
    left_outer_joins(applications: :events)
      .select(
        'jobs.*',
        'COALESCE(COUNT(
        CASE
        WHEN application_events.type = \'Application::Event::Hired\'
        THEN 1
        END), 0) AS hired_count',
        'COALESCE(COUNT(
        CASE
        WHEN application_events.type = \'Application::Event::Rejected\'
        THEN 1
        END), 0) AS rejected_count',
        'COALESCE(COUNT(
        CASE
        WHEN application_events.type NOT IN (\'Application::Event::Hired\', \'Application::Event::Rejected\')
        THEN 1
        END), 0) AS ongoing_count'
      )
      .where(
        "application_events.created_at = (
        SELECT MAX(e2.created_at) FROM application_events e2
        WHERE e2.application_id = application_events.application_id AND e2.type != 'Application::Event::Note'
      ) OR application_events.id IS NULL"
      )
  }

  def status
    last_event = events.max_by(&:created_at)
    case last_event&.type
    when 'Job::Event::Activated' then 'activated'
    else 'deactivated'
    end
  end

  def last_interview_date
    Job.includes(applications: :events).find(id) # to avoid N+1 query it preloads applications and their events
       .applications.joins(:events)
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

# frozen_string_literal: true

class Application < ApplicationRecord
  belongs_to :job
  has_many :events, class_name: 'Application::Event', dependent: :destroy

  validates :job, presence: true

  # This scope is used to find applications that have been hired.
  # It excludes notes from the latest event check, assuming they don't affect the status.
  # It uses a subquery to find the latest event for each application.
  # The subquery selects the maximum created_at timestamp for each application_id.
  # The main query then filters by this timestamp and the type of event.
  # This ensures that only the most recent events are considered for determining the status.
  # It returns applications that have a 'Hired' event as their latest event.
  scope :hired, lambda {
    joins(:events)
      .where.not(events: { type: 'Application::Event::Note' })
      .where(
        events: {
          created_at: Application::Event
                        .select('MAX(created_at)')
                        .where('application_events.application_id = applications.id')
                        .group(:application_id),
          type: 'Application::Event::Hired'
        }
      )
  }

  # This scope is used to find applications that have been rejected.
  # It excludes notes from the latest event check, assuming they don't affect the status.
  # It uses a subquery to find the latest event for each application.
  # The subquery selects the maximum created_at timestamp for each application_id.
  # The main query then filters by this timestamp and the type of event.
  # This ensures that only the most recent events are considered for determining the status.
  # It returns applications that have a 'Rejected' event as their latest event.
  scope :rejected, lambda {
    joins(:events)
      .where.not(events: { type: 'Application::Event::Note' })
      .where(
        events: {
          created_at: Application::Event
                        .select('MAX(created_at)')
                        .where('application_events.application_id = applications.id')
                        .group(:application_id),
          type: 'Application::Event::Rejected'
        }
      )
  }

  # This scope is used to find applications that are currently in the interviewing stage.
  # It uses a subquery to find the latest event for each application.
  # The subquery selects the maximum created_at timestamp for each application_id.
  # The main query then filters by this timestamp and excludes events of type 'Hired' or 'Rejected'.
  # This ensures that only the most recent events are considered for determining the status.
  # It returns applications that have an 'Interview' event as their latest event, but not 'Hired' or 'Rejected'.
  scope :interviewing, lambda {
    joins(:events)
      .where.not(events: { type: ['Application::Event::Hired', 'Application::Event::Rejected'] })
      .where(
        events: {
          created_at: Application::Event
                        .select('MAX(created_at)')
                        .where('application_events.application_id = applications.id')
                        .group(:application_id)
        }
      )
  }

  scope :with_notes_count, lambda {
    joins(<<~SQL.squish)
      LEFT JOIN (
        SELECT application_id, COUNT(*) AS notes_count
        FROM application_events
        WHERE type = 'Application::Event::Note'
        GROUP BY application_id
      ) notes ON notes.application_id = applications.id
    SQL
      .select('applications.*', 'COALESCE(notes.notes_count, 0) AS notes_count')
  }

  scope :with_last_interviewed_at, lambda {
    select(<<~SQL.squish)
      applications.*,
      (
        SELECT MAX(e.created_at)
        FROM application_events e
        WHERE e.application_id = applications.id
          AND e.type = 'Application::Event::Interview'
      ) AS last_interviewed_at
    SQL
  }
  def status
    last_event = events
                 .reject { |e| e.type == 'Application::Event::Note' }
                 .max_by(&:created_at)

    case last_event&.type
    when 'Application::Event::Interview' then 'interview'
    when 'Application::Event::Hired'     then 'hired'
    when 'Application::Event::Rejected'  then 'rejected'
    else 'applied'
    end
  end
end

# == Schema Information
#
# Table name: applications
#
#  id             :integer          not null, primary key
#  candidate_name :string
#  job_id         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# frozen_string_literal: true

# db/seeds.rb

# Create jobs
jobs = Array.new(10) { FactoryBot.create(:job) }

# Assign events to each job
jobs.each_with_index do |job, index|
  initial_event_type = index.even? ? 'job_event_activated' : 'job_event_deactivated'
  events = if initial_event_type == 'job_event_activated'
             %w[job_event_activated job_event_deactivated job_event_activated]
           else
             %w[job_event_deactivated job_event_activated job_event_deactivated]
           end

  events.each do |event_type|
    case event_type
    when 'job_event_activated'
      FactoryBot.create(:job_event_activated, job: job)
    when 'job_event_deactivated'
      FactoryBot.create(:job_event_deactivated, job: job)
    end
  end
end

# Assign applicants to jobs
100.times do
  jobs.each do |job| # Iterate over each job
    application = FactoryBot.create(:application, job: job) # Create an application for the job

    # Randomly decide whether to assign events or leave the application in 'applied' status
    next unless [true, false].sample

    %w[
      application_event_interview
      application_event_hired
      application_event_rejected
      application_event_note
    ].sample(rand(1..4)).each do |event_type| # Assign 1 to 3 random events
      case event_type
      when 'application_event_interview'
        FactoryBot.create(:application_event_interview, application: application)
      when 'application_event_hired'
        FactoryBot.create(:application_event_hired, application: application)
      when 'application_event_rejected'
        FactoryBot.create(:application_event_rejected, application: application)
      when 'application_event_note'
        FactoryBot.create(:application_event_note, application: application)
      end
    end
  end
end

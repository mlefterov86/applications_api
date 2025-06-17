# frozen_string_literal: true

FactoryBot.define do
  factory :job_event, class: 'Job::Event' do
    job
    type { '' }
  end

  factory :job_event_activated, parent: :job_event, class: 'Job::Event::Activated' do
    type { 'Job::Event::Activated' }
  end

  factory :job_event_deactivated, parent: :job_event, class: 'Job::Event::Deactivated' do
    type { 'Job::Event::Deactivated' }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :application_event, class: 'Application::Event' do
    type { '' }
    application

    created_at { Time.current }
  end

  factory :application_event_interview, class: 'Application::Event::Interview', parent: :application_event do
    type { 'Application::Event::Interview' }
  end

  factory :application_event_hired, class: 'Application::Event::Hired', parent: :application_event do
    type { 'Application::Event::Hired' }
  end

  factory :application_event_rejected, class: 'Application::Event::Rejected', parent: :application_event do
    type { 'Application::Event::Rejected' }
  end

  factory :application_event_note, class: 'Application::Event::Note', parent: :application_event do
    type { 'Application::Event::Note' }
    content { Faker::Lorem.sentence }
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

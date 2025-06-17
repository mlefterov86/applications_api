# frozen_string_literal: true

FactoryBot.define do
  factory :application do
    candidate_name { Faker::Name.name }
    job
  end
end

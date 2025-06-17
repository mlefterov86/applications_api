# frozen_string_literal: true

FactoryBot.define do
  factory :application do
    candidate_name { Faker::Name.name }
    job
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

# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    description { Faker::Lorem.sentence }
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

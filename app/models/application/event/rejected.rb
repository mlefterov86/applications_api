# frozen_string_literal: true

class Application
  class Event
    class Rejected < Application::Event
      alias_attribute :rejected_date, :created_at
    end
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

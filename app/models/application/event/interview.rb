# frozen_string_literal: true

class Application
  class Event
    class Interview < Application::Event
      alias_attribute :interview_date, :created_at
    end
  end
end

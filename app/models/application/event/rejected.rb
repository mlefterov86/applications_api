# frozen_string_literal: true

class Application
  class Event
    class Rejected < Application::Event
      alias_attribute :rejected_date, :created_at
    end
  end
end

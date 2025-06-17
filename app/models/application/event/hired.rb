# frozen_string_literal: true

class Application
  class Event
    class Hired < Application::Event
      alias_attribute :hire_date, :created_at
    end
  end
end

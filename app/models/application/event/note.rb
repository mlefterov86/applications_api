# frozen_string_literal: true

class Application
  class Event
    class Note < Application::Event
      validates :content, presence: true
    end
  end
end

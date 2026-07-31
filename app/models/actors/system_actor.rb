module Actors
  class SystemActor

    def id
      "system"
    end

    def name
      "System"
    end

    def system?
      true
    end

    def user?
      false
    end

  end
end
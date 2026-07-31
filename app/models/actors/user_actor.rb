module Actors
  class UserActor

    attr_reader :user

    def initialize(user)
      @user = user
    end

    def system?
      false
    end

    def user?
      true
    end

  end
end
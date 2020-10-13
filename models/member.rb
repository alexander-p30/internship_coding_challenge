module Models
  # Member model, which contains: name, user id and crew id
  class Member
    @@instances = []

    def initialize(name, user_id, crew_id)
      @name = name
      @user_id = user_id
      @crew_id = crew_id
      @@instances << self
    end

    attr_reader :name, :user_id

    def all
      @@instances
    end
  end
end

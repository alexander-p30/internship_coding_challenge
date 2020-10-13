module Models
  # Member model, which contains: name, user id and crew id
  class Member
    @@instances = []

    def initialize(member_data_hash)
      @name = member_data_hash[:name]
      @user_id = member_data_hash[:user_id]
      @crew_id = member_data_hash[:crew_id]
      @@instances << self
    end

    attr_reader :name, :user_id

    def self.all
      @@instances
    end
  end
end

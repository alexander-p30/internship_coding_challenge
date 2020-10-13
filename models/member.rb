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

    def pending_absences
      Absence.pending_absences.select { |abs| abs.user_id == @user_id }
    end

    def confirmed_absences
      Absence.confirmed_absences.select { |abs| abs.user_id == @user_id }
    end

    def self.all
      @@instances
    end
  end
end

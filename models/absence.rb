module Models
  # Absence model, which contains: absentee (class instance), user_id, type and
  # start and end date
  class Absence
    @@instances = []

    def initialize(absence_hash_data)
      @user_id = absence_hash_data[:user_id]
      @type = absence_hash_data[:type]
      @start_date = absence_hash_data[:start_date]
      @end_date = absence_hash_data[:end_date]
      @@instances << self
    end

    attr_reader :user_id, :start_date, :end_date

    def absentee
      Member.all.find { |m| m.user_id == @user_id }
    end

    def description
      absence_types_description = {
        'sickness' => 'is sick',
        'vacation' => 'is on vacation'
      }

      "#{absentee.name} #{absence_types_description[@type]}"
    end

    def self.all
      @@instances
    end
  end
end

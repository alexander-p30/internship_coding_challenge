module Models
  # Absence model, which contains: user id, crew id, type, confirmation date
  # and start and end date
  class Absence
    @@instances = []

    def initialize(absence_hash_data)
      @user_id = absence_hash_data[:user_id]
      @crew_id = absence_hash_data[:crew_id]
      @type = absence_hash_data[:type]
      @confirmed_at = absence_hash_data[:confirmed_at]
      @start_date = absence_hash_data[:start_date]
      @end_date = absence_hash_data[:end_date]
      @@instances << self
    end

    attr_reader :user_id, :type, :confirmed_at, :start_date, :end_date

    def absentee
      Member.find_by_user_id(@user_id)
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

    def self.pending_absences
      all.reject(&:confirmed_at)
    end

    def self.confirmed_absences
      all.select(&:confirmed_at)
    end
  end
end

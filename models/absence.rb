module Models
  # Absence model, which contains: absentee (class instance), user_id, type and
  # start and end date
  class Absence
    @@instances = []

    def initialize(absentee, user_id, type, start_date, end_date)
      @absentee = absentee
      @user_id = user_id
      @type = type
      @start_date = start_date
      @end_date = end_date
      @@instances << self
    end

    attr_reader :user_id, :start_date, :end_date

    def description
      absence_types_description = {
        'sickness' => 'is sick',
        'vacation' => 'is on vacation'
      }

      "#{@absentee.name} #{absence_types_description[@type]}"
    end

    def self.all
      @@instances
    end
  end
end

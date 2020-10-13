require_relative './api'
require_relative '../models/absence'
require 'icalendar'

module CmChallenge
  class Absences
    class << self
      def to_ical
        absences = Models::Absence.confirmed_absences
        calendar = Icalendar::Calendar.new
        absences.each { |abs| calendar.add_event(create_calendar_event(abs)) }

        calendar.to_ical
      end

      def list
        confirmed_absences = Models::Absence.confirmed_absences
        pending_absences = Models::Absence.pending_absences
        {
          confirmed: confirmed_absences.map do |abs|
            create_absence_hash(abs)
          end,
          pending: pending_absences.map do |abs|
            create_absence_hash(abs)
          end
        }
      end

      private

      def create_calendar_event(absence)
        e = Icalendar::Event.new
        e.dtstart = Icalendar::Values::Date.new absence.start_date.tr('-', '')
        e.dtend = Icalendar::Values::Date.new absence.end_date.tr('-', '')
        e.summary = absence.description
        e
      end

      def create_absence_hash(absence)
        { absentee_name: absence.absentee.name,
          start_date: absence.start_date,
          end_date: absence.end_date,
          description: absence.description }
      end
    end
  end
end

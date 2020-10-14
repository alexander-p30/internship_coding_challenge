require_relative './api'
require_relative '../models/absence'
require_relative '../models/member'
require 'icalendar'
require 'date'

module CmChallenge
  class Absences
    class << self
      def to_ical
        absences = Models::Absence.confirmed_absences
        calendar = Icalendar::Calendar.new
        absences.each { |abs| calendar.add_event(create_calendar_event(abs)) }
        # Returns the iCal string, ready to be written into a ics file
        calendar.to_ical
      end

      def list(user, start_date, end_date)
        confirmed = Models::Absence.confirmed_absences
        pending = Models::Absence.pending_absences

        start_date ||= '1900-01-01'
        end_date ||= '9999-12-31'

        if user
          confirmed = user.confirmed_absences
          pending = user.pending_absences
        end

        filter_absences_by_date(confirmed, pending, start_date, end_date)
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

      def filter_absences_by_date(confirmed, pending, start_date, end_date)
        start_date = Date.parse(start_date)
        end_date = Date.parse(end_date)

        [confirmed.select do |abs|
           (Date.parse(abs.start_date) >= start_date &&
             Date.parse(abs.end_date) <= end_date)
         end,
         pending.select do |abs|
           (Date.parse(abs.start_date) >= start_date &&
             Date.parse(abs.end_date) <= end_date)
         end]
      end
    end
  end
end

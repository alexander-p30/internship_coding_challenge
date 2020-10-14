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
           check_date_range(abs, start_date, end_date)
         end,
         pending.select do |abs|
           check_date_range(abs, start_date, end_date)
         end]
      end

      def check_date_range(absence, start_date, end_date)
        abs_start_date = absence.start_date_as_date
        abs_end_date = absence.end_date_as_date

        starts_within_time = (abs_start_date >= start_date &&
                                abs_start_date <= end_date)
        ends_within_time = (abs_end_date >= start_date &&
                              abs_end_date <= end_date)

        starts_within_time || ends_within_time
      end
    end
  end
end

require_relative './api'
require_relative '../models/absence'
require_relative '../models/member'
require_relative '../utils/date_helper'
require 'icalendar'
require 'date'

module CmChallenge
  # Interface for interacting with the classes
  class Absences
    class << self
      def to_ical
        absences = Models::Absence.confirmed_absences
        calendar = Icalendar::Calendar.new
        absences.each { |abs| calendar.add_event(create_calendar_event(abs)) }
        # Returns the iCal string, ready to be written into a ics file
        calendar.to_ical
      end

      # Returns an array of Models::Absence instances according to the params
      # provided
      def list(user, start_date, end_date)
        if user
          confirmed = user.confirmed_absences
          pending = user.pending_absences
        else
          confirmed = Models::Absence.confirmed_absences
          pending = Models::Absence.pending_absences
        end

        # If date values are nil, uses default defined values instead
        start_date ||= DateHelper::DEFAULT_START_DATE
        end_date ||= DateHelper::DEFAULT_END_DATE

        DateHelper.absences_by_date(confirmed, pending, start_date, end_date)
      end

      def find_member_by_user_id(user_id)
        Models::Member.find_by_user_id(user_id)
      end

      private

      # Creates calendar event by using Models::Absence instance
      def create_calendar_event(absence)
        e = Icalendar::Event.new
        e.dtstart = Icalendar::Values::Date.new absence.start_date.tr('-', '')
        e.dtend = Icalendar::Values::Date.new absence.end_date.tr('-', '')
        e.summary = absence.description
        e
      end
    end
  end
end

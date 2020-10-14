require_relative '../cm_challenge/absences'
require_relative '../models/absence'
require_relative '../utils/seeder'

RSpec.describe 'Absences' do
  before(:context) do
    Seeder.populate_classes_from_api
    @absences_controller = CmChallenge::Absences
    @absence_klass = Models::Absence
  end

  before(:example) do
    @user = Models::Member.find_by_user_id(644)
    @start_date = '2017-01-01'
    @end_date = '2017-03-13'
  end

  describe '#to_ical' do
    let(:to_ical) { @absences_controller.to_ical }
    let(:confirmed_absences) { @absence_klass.confirmed_absences }

    it { expect(to_ical).to be_a(String) }
    it { expect(to_ical[0..16]).to eql("BEGIN:VCALENDAR\r\n") }
    it { expect(to_ical[-16..-1]).to eql("\nEND:VCALENDAR\r\n") }
    # Adding 1 to the confirmed_absences length is necessary because by
    # splitting the string in every 'BEGIN:VEVENT' leaves us with each event
    # declaration plus the calendar configuration info header
    it { expect(to_ical.split('BEGIN:VEVENT').length).to eql(confirmed_absences.length + 1) }
  end

  describe '#list' do
    context 'absences for user_id 644 until 2017-03-13' do
      let(:list) { @absences_controller.list(@user, @start_date, @end_date) }
      let(:users_confirmed_absences) do
        @user.confirmed_absences.select do |abs|
          (abs.start_date_as_date >= Date.parse(@start_date) ||
            abs.start_date_as_date <= Date.parse(@end_date)) ||
            (abs.end_date_as_date >= Date.parse(@start_date) ||
              abs.end_date_as_date <= Date.parse(@end_date))
        end
      end
      let(:users_pending_absences) do
        @user.pending_absences.select do |abs|
          (abs.start_date_as_date >= Date.parse(@start_date) ||
            abs.start_date_as_date <= Date.parse(@end_date)) ||
            (abs.end_date_as_date >= Date.parse(@start_date) ||
              abs.end_date_as_date <= Date.parse(@end_date))
        end
      end

      # Checks if all the confirmed/pending absences for the time period are
      # correctly returned
      it { expect(list[0].length).to eql(users_confirmed_absences.length) }
      it { expect(list[1].length).to eql(users_pending_absences.length) }
      # Checks if returned list contains only objects of the Absence
      it { expect(list.flatten).to all(respond_to(:user_id)) }
      it { expect(list.flatten).to all(respond_to(:type)) }
      it { expect(list.flatten).to all(respond_to(:confirmed_at)) }
      it { expect(list.flatten).to all(respond_to(:start_date)) }
      it { expect(list.flatten).to all(respond_to(:end_date)) }
      it { expect(list.flatten).to all(respond_to(:absentee)) }
      it { expect(list.flatten).to all(respond_to(:description)) }
    end
  end
end

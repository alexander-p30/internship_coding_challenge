require_relative '../cm_challenge/absences'
require_relative '../models/absence'
require_relative '../utils/seeder'

RSpec.describe 'Absences' do
  before(:context) do
    Seeder.populate_classes_from_api
  end

  before(:example) do
    @absences_controller = CmChallenge::Absences.new
    @absence_klass = Models::Absence
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
    let(:list) { @absences_controller.list }

    it { expect(list).to respond_to(:keys) }
    it { expect(list.keys.length).to eql(2) }
    it { expect(list).to respond_to(:values) }
    # Checks if the structure of the hashes inside the confirmed and pending
    # keys is correct
    it { expect(list.values.flatten).to all(have_key(:absentee_name)) }
    it { expect(list.values.flatten).to all(have_key(:start_date)) }
    it { expect(list.values.flatten).to all(have_key(:end_date)) }
    it { expect(list.values.flatten).to all(have_key(:description)) }
  end
end

# Module that holds methods for date managing
module DateHelper
  DEFAULT_START_DATE = '1900-01-01'.freeze
  DEFAULT_END_DATE = '9999-12-31'.freeze

  def self.absences_by_date(confirmed, pending, start_date, end_date)
    start_date, end_date = parse_params_as_date(start_date, end_date)

    [confirmed.select { |abs| check_date_range(abs, start_date, end_date) },
     pending.select { |abs| check_date_range(abs, start_date, end_date) }]
  end

  def self.parse_params_as_date(start_date, end_date)
    [Date.parse(start_date), Date.parse(end_date)]
  rescue ArgumentError
    [Date.parse(DEFAULT_START_DATE), Date.parse(DEFAULT_END_DATE)]
  end

  # Checks if absence start or end date are within the supplied date range
  def self.check_date_range(absence, start_date, end_date)
    abs_start_date = absence.start_date_as_date
    abs_end_date = absence.end_date_as_date

    starts_within_time = (abs_start_date >= start_date &&
        abs_start_date <= end_date)
    ends_within_time = (abs_end_date >= start_date &&
        abs_end_date <= end_date)

    starts_within_time || ends_within_time
  end
end

require_relative './utils/setup'

require 'sinatra'

# Sinatra config
set :port, 3000

get '/' do
  @user = CONTROLLER.find_member_by_user_id(params[:userId])
  @start_date = params[:startDate]
  @end_date = params[:endDate]

  @confirmed_absences, @pending_absences = CONTROLLER.list(
    @user, @start_date, @end_date
  )

  erb :index
end

get '/download_calendar' do
  send_file './storage/result.ics', filename: 'calendar.ics'
end

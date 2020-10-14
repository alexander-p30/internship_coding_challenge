require_relative './utils/setup'
require_relative 'models/member'

require 'sinatra'

# Sinatra config
set :port, 3000

get '/' do
  @user = Models::Member.find_by_user_id(params[:userId])
  @start_date = params[:startDate]
  @end_date = params[:endDate]
  @confirmed_absences, @pending_absences = ABSENCES_CONTROLLER.list(
      @user, @start_date, @end_date
  )

  if params[:userId] && @user
    erb :user
  else
    erb :index
  end
end

get '/download_calendar' do
  send_file './storage/result.ics', filename: 'calendar.ics'
end


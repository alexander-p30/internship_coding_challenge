# Prerequisites

1. Install Ruby
2. `gem install bundler`
3. `bundle install`

## Running Specs

`bundle exec rspec` or `bundle exec guard`

## Running the application

`ruby app_router.rb`

The application has a very basic html presentation. Colors may look oversaturated in Chrome.

## Available routes

* '/' => shows a list of confirmed and pending absences. The page shows a download button for the ics calendar when there are no query params.

## Working query params

* '?userId=' => shows a list of confirmed and pending absences for a specific user (if the id is valid).
* '?startDate=' or '?endDate=' => shows a list of absences that either start or end within the specified time period. If one of the parameters is missing, a default value will take its place (1900-01-01 for startDate and 9999-12-31 for endDate).

These query params can be used simultaneously: '?userId=644&startDate=2017-03-13' will return a list of absences for user with id 644 starting from 2017-03-13.

require_relative '../cm_challenge/api'
require_relative '../models/absence'
require_relative '../models/member'

# POSSIBLE IMPROVEMENT: defining these columns arrays as class variables, so
# one can easily change or add field to the class by changing these class
# variables
KLASSES = {
  %i[name user_id crew_id] => Models::Member,
  %i[user_id type start_date end_date] => Models::Absence
}.freeze

# Seeder class used to populate the app's classes with the api responses
class Seeder
  class << self
    def populate_classes_from_api
      api = CmChallenge::Api
      (api.members + api.absences).each do |raw_object_data|
        create_object(raw_object_data)
      end
    end

    private

    def create_object(data_hash)
      KLASSES.each do |necessary_data, klass|
        if necessary_data.all? { |data_key| data_hash.key? data_key }
          return klass.new(data_hash)
        end
      end
      raise ArgumentError, 'Received hash does not match any class model.'
    end
  end
end

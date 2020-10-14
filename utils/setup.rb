require_relative 'seeder.rb'
require_relative '../cm_challenge/absences'

# 'DB' seed and controller instantiation
Seeder.populate_classes_from_api
CONTROLLER = CmChallenge::Absences

# Writes ics file to be exported (downloaded)
File.write('storage/result.ics', CONTROLLER.to_ical)

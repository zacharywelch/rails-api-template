# This file should contain all the record creation needed to populate local database with sample data.
# The data can then be loaded with the rake db:populate
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'

namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do

  end
end

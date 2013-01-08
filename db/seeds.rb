# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


100.times do |i|
User.create(
            :email => "sample@from_seed#{i}.pl",
            :password => "foobar", 
            :password_confirmation => 'foobar',
            :country => "Poland", 
            :latitude => "1.#{i}123", 
            :longitude => "2.#{i}229"
           )
end

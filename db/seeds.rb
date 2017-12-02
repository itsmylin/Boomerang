# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



ActiveRecord::Base.connection.execute "DELETE FROM Interests"



user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email




Interest.create(name:'food',timeSlot: '1-5',location: 'Isla Vista',description: 'blehh')
Interest.create(name:'surfing',timeSlot: '1-5',location: 'Isla Vista',description: 'blehh')
Interest.create(name:'shopping',timeSlot: '1-5',location: 'Isla Vista',description: 'blehh')
Interest.create(name:'soccer',timeSlot: '1-5',location: 'Isla Vista',description: 'blehh')
Interest.create(name:'salon',timeSlot: '1-5',location: 'Isla Vista',description: 'blehh')
Interest.create(name:'climbing',timeSlot: '1-5',location: 'Isla Vista',description: 'blehh')
Interest.create(name:'drinks',timeSlot: '1-5',location: 'Isla Vista',description: 'blehh')
Interest.create(name:'hiking',timeSlot: '1-5',location: 'Isla Vista',description: 'blehh')
Interest.create(name:'movies',timeSlot: '1-5',location: 'Isla Vista',description: 'blehh')

UserInterestMapping.create(userID: '1', interestID: '2')

1000.times do |i|
    UserUserMapping.create(primeUserID: "#{i}", timeslot: "", sent: "", received: "", completematch: "", nomatch: "")
end
1000.times do |i|
    user = User.new(
        name:"#{i}",
        email:"#{i}@domain.com",
        password:'123456789',
        password_confirmation:'123456789')
    user.save!
end
1000.times do |i|
        UserInterestMapping.create(userID: "#{i}", interestID: '2')
end

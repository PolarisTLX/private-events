# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create([{name: 'Person1', email:'p1@email.com', password: 'password'},{name: 'Person2', email:'p2@email.com', password: 'password'}])

events = Event.create([{ title: "Something long enough", host_id: 1, description: "Text goes here, I hope.", location: "Somewhere", date: "2018-08-01" },
                     { title: "This is the 2nd event", host_id: 2, description: "2nd Text goes here, I hope.", location: "2nd location", date: "2018-09-01" }])

# For invites, create 4 (2 events x 2 invites each):
# Event 1: hosted by Person1, both accept.
# Event 2: hosted by Person2, only host is confirmed.
invites = Invite.create([{attended_event_id: 1, attendee_id: 2, accepted: true},{attended_event_id: 1, attendee_id: 1, accepted: true},{attended_event_id: 2, attendee_id: 2, accepted: true},{attended_event_id: 2, attendee_id: 1, accepted: false}])

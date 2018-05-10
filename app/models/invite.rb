class Invite < ApplicationRecord
  belongs_to :attended_event, class_name: "Event", dependent: :destroy
  belongs_to :attendee, class_name: "User", dependent: :destroy  
end

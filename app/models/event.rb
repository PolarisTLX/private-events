class Event < ApplicationRecord

  belongs_to :host, class_name: "User", dependent: :destroy
  has_many :invites, foreign_key: :attended_event_id
  has_many :attendees, through: :invites

  default_scope -> { order(created_at: :asc) }

  validates :title, presence: true, length: {minimum: 4, maximum: 50 }
  validates :description, presence: true, length: {minimum: 3, maximum: 1000 }
  validates :location, presence: true, length: {minimum: 4, maximum: 100 }
  validates :date, presence: true # timeliness: { on_or_before: lambda { Date.current }, type: :date }

end

class Event < ApplicationRecord
  belongs_to :host, class_name: "User"
  has_many :invites, foreign_key: :attended_event_id, dependent: :destroy
  has_many :attendees, through: :invites

  after_create :invite_host_automatically

  scope :upcoming, -> { where("date >= ?", Date.today).order(date: :asc) }
  scope :past, -> { where("date < ?", Date.today).order(date: :desc) }

  validates :title, presence: true, length: {minimum: 4, maximum: 50 }
  validates :description, presence: true, length: {minimum: 3, maximum: 1000 }
  validates :location, presence: true, length: {minimum: 4, maximum: 100 }
  validates :date, presence: true

  private

  def invite_host_automatically
    self.invites.create(attendee_id: host_id, accepted: true)
  end
end

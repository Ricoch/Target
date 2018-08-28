class Target < ApplicationRecord
  validates  :radius, presence: true, numericality: { only_integer: true }
  validates  :title, :topic, presence: true
  validates  :latitude, :longitude, presence: true, numericality: true
  validates  :topic, uniqueness: { scope: %i[latitude longitude user_id] }
  belongs_to :user

  enum topic: %i[football travel politics art dating music movies series food]
end

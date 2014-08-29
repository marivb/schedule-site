class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :duration, type: Integer

  belongs_to :schedule

  validates :title, presence: true
  validates :duration, presence: true, numericality: {greater_than: 0, only_integer: true}
  validates :schedule_id, presence: true
end

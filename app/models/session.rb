class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :duration, type: Integer
  field :placed, type: Boolean

  belongs_to :schedule

  validates :title, presence: true
  validates :duration, presence: true, numericality: {greater_than: 0, only_integer: true}
  validates :schedule_id, presence: true

  def time_slot_span
    (duration.to_f / schedule.slot_interval).ceil
  end
end

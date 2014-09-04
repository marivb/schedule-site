class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :duration, type: Integer

  belongs_to :schedule
  belongs_to :slot

  validates :title, presence: true
  validates :duration, presence: true, numericality: {greater_than: 0, only_integer: true}
  validates :schedule_id, presence: true

  def time_slot_span
    (duration.to_f / schedule.slot_interval).ceil
  end
end

class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :start_time, type: Types::ScheduleTime
  field :end_time, type: Types::ScheduleTime
  field :slot_interval, type: Integer

  has_many :sessions, validate: false

  def times
    start_time.until(end_time, slot_interval).map do |time|
      TimeSlot.new(time)
    end
  end
end

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
      formatable_time = Time.now.beginning_of_day + time
      formatable_time.strftime('%H:%M')
    end
  end
end

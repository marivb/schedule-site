class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :start_time, type: Types::ScheduleTime
  field :end_time, type: Types::ScheduleTime
  field :slot_interval, type: Integer
end

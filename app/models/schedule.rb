class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :start_time, type: Types::ScheduleTime
  field :end_time, type: Types::ScheduleTime
  field :slot_interval, type: Integer

  has_many :sessions, validate: false
  embeds_many :times, class_name: 'TimeRow', cascade_callbacks: true

  def self.build_full options={}
    Schedule.new(options).tap do |schedule|
      begin
        schedule.start_time.until(schedule.end_time, schedule.slot_interval).map do |time|
          time = schedule.times.build start_delta: time
          time.slots.build type: Slot::TYPES.BLANK
        end
      rescue
        raise 'Cannot build full schedule'
      end
    end
  end

  def add_session slot, session
    slot.add_session(session)
    session_span = session.time_slot_span
    times_after(slot.time, session_span).each do |time|
      time.slots[0].type = 'cont'
    end
  end

  def clear slot
    session_span = slot.session.time_slot_span
    slot.clear
    times_after(slot.time, session_span).each do |time|
      time.slots[0].clear
    end
  end

  private

  def times_after time, size
    time_at = times.find_index(time)
    start = time_at + 1
    finish = time_at + size
    times[start...finish]
  end
end

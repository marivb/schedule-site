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

  def add_session first_slot, session
    slots = times_for(first_slot.time, session.time_slot_span).collect { |t| t.slots[0] }

    slots.first.add_session(session)

    slots[1..-1].each do |slot|
      slot.continue
    end
  end

  def clear first_slot
    session_span = first_slot.session.time_slot_span
    slots = times_for(first_slot.time, session_span).collect { |t| t.slots[0] }
    slots.each do |slot|
      slot.clear
    end
  end

  private

  def times_for time, size
    start = times.find_index(time)
    finish = start + size
    times[start...finish]
  end
end

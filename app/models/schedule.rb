class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::EmbeddedErrors

  field :name
  field :start_time, type: Types::ScheduleTime
  field :end_time, type: Types::ScheduleTime
  field :slot_interval, type: Integer

  has_many :sessions, validate: false
  embeds_many :times, class_name: 'TimeRow', cascade_callbacks: true

  def self.build_full options={}
    Schedule.new(options).tap do |schedule|
      schedule.reset
    end
  end

  def reset
    times.delete_all

    start_time.until(end_time, slot_interval).map do |time|
      time = times.build start_delta: time
      time.slots.build type: Slot::TYPES.BLANK
    end
    self
  rescue
    raise 'Cannot build full schedule'
  end

  def add_session first_slot, session
    span = session.time_slot_span
    available_slots = times_for(first_slot.time, span).collect { |t| t.slots[0] }.select(&:blank?)
    if available_slots.size < span
      first_slot.invalidate
    else
      available_slots.first.add_session(session)

      available_slots[1..-1].each do |slot|
        slot.continue
      end
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

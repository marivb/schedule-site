class Schedule
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::EmbeddedErrors

  field :name
  field :start_time, type: Types::ScheduleTime
  field :end_time, type: Types::ScheduleTime
  field :slot_interval, type: Integer

  has_many :sessions, validate: false
  has_many :rooms, validate: false
  embeds_many :times, class_name: 'TimeRow', cascade_callbacks: true

  validate :all_times_match_room_count
  validate :all_times_same_slot_count

  def all_times_match_room_count
    errors.add(:all_times, 'has too many slots') if rooms.size < times.first.slots.size
    errors.add(:all_times, 'has not enough slots') if rooms.size > times.first.slots.size
  end

  def all_times_same_slot_count
    same_count = times.collect { |t| t.slots.size }.uniq.size == 1
    errors.add(:all_times, 'must have same slot count') unless same_count
  end

  def self.build_empty options={}
    begin
      Schedule.new(options).tap do |schedule|
        schedule.start_time.until(schedule.end_time, schedule.slot_interval).map do |time|
          time = schedule.times.build start_delta: time
        end
      end
    rescue
      raise 'Cannot build full schedule'
    end
  end

  def add_slot_column
    times.each do |time|
      time.slots.build type: Slot::TYPES.BLANK
    end
  end

  def add_session first_slot, session
    session_span = session.time_slot_span
    available_slots = slots_after(first_slot, session_span).select(&:blank?)
    if available_slots.size < session_span
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
    slots_after(first_slot, session_span).each do |slot|
      slot.clear
    end
  end

  private

  def slots_after slot, size
    time_start = times.find_index(slot.time)
    time_finish = time_start + size
    slot_index = slot.time.slots.find_index(slot)
    times[time_start...time_finish].collect { |t| t.slots[slot_index] }
  end
end

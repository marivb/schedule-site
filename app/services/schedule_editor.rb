class ScheduleEditor
  def initialize(schedule)
    @schedule = schedule
    @dependencies = []
  end

  def process(change)
    case change[:type]
    when 'sessionAdd'
      process_addition(change[:data])
    when 'sessionRemove'
      process_deletion(change[:data])
    when 'roomAdd'
      process_room_add(change[:data])
    end
  end

  def save
    @schedule.save && @dependencies.all?(&:save)
  end

  private

  def process_room_add(room)
    @schedule.add_slot_column
    @dependencies << @schedule.rooms.build(name: room[:name])
  end

  def process_addition(addition)
    slot = find_slot addition[:time_id], addition[:slot_id]
    session = Session.find(addition[:session_id])
    @dependencies << session

    @schedule.add_session slot, session
    session.placed = true
  end

  def process_deletion(deletion)
    slot = find_slot deletion[:time_id], deletion[:slot_id]
    @dependencies << slot.session
    slot.session.placed = false
    @schedule.clear slot
  end

  def find_slot(time_id, slot_id)
    @schedule.times.find(time_id).slots.find(slot_id)
  end
end

class ScheduleEditor
  def initialize(schedule)
    @schedule = schedule
  end

  def process(change)
    case change[:type]
    when 'sessionAdd'
      process_addition(change[:data])
    when 'sessionRemove'
      process_deletion(change[:data])
    when 'roomAdd'
      @schedule.add_slot_column
    end
  end

  def process_addition(addition)
    slot = find_slot addition[:time_id], addition[:slot_id]
    @session = Session.find(addition[:session_id])

    @schedule.add_session slot, @session
    @session.placed = true
  end

  def process_deletion(deletion)
    slot = find_slot deletion[:time_id], deletion[:slot_id]
    @session = slot.session
    @schedule.clear slot
    @session.placed = false
  end

  def save
    @schedule.save && (@session.nil? || @session.save)
  end

  private

  def find_slot(time_id, slot_id)
    @schedule.times.find(time_id).slots.find(slot_id)
  end
end

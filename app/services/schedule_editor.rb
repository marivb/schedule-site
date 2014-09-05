class ScheduleEditor
  def initialize(schedule)
    @schedule = schedule
  end

  def process_additions(additions)
    additions.each do |addition|
      slot = find_slot addition[:time_id], addition[:slot_id]
      session = Session.find(addition[:session_id])

      @schedule.add_session slot, session
    end
  end

  def process_deletions(deletions)
    deletions.each do |deletion|
      slot = find_slot deletion[:time_id], deletion[:slot_id]
      @schedule.clear slot
    end
  end

  private

  def find_slot(time_id, slot_id)
    @schedule.times.find(time_id).slots.find(slot_id)
  end
end

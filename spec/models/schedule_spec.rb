require 'rails_helper'

describe Schedule do
  describe 'with ScheduleTime type' do
    it 'should allow creating and retrieving' do
      schedule = Schedule.create start_time: 9.hours

      expect(Schedule.where(start_time: 9.hours).first).to eq(schedule)
    end
  end

  describe 'times' do
    it 'should go from start to end at increments of slot_interval' do
      schedule = Schedule.new start_time: 9.hours, end_time: 13.hours, slot_interval: 60
      expect(schedule.times).to eq([TimeSlot.new(9.hours), TimeSlot.new(10.hours),
                                    TimeSlot.new(11.hours), TimeSlot.new(12.hours)])
    end
  end
end

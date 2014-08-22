describe Schedule do
  describe 'with ScheduleTime type' do
    it 'should allow creating and retrieving' do
      schedule = Schedule.create start_time: 9.hours

      expect(Schedule.where(start_time: 9.hours).first).to eq(schedule)
    end
  end

  describe 'times' do
    it 'should go from start to end at increments of slot_interval' do
      schedule = Schedule.new start_time: 9.hours, end_time: 10.hours, slot_interval: 15
      expect(schedule.times).to eq(['09:00', '09:15', '09:30', '09:45'])
    end
  end
end

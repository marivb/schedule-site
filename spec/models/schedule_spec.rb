describe Schedule do
  describe 'with ScheduleTime type' do
    it 'should allow creating and retrieving' do
      schedule = Schedule.create start_time: 9.hours

      expect(Schedule.where(start_time: 9.hours).first).to eq(schedule)
    end
  end
end

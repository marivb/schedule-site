describe ScheduleSerializer do
  before :each do
    @schedule = Schedule.create(
      name: 'A Name',
      start_time: 9.hours,
      end_time: 10.hours,
      slot_interval: 10
    )
    @json = ScheduleSerializer.new(@schedule, root: false).to_json
  end

  it 'should contain id as string' do
    expect(@json).to match(/"id":"#{@schedule.id.to_s}"/)
  end
end

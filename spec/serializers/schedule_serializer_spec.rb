describe ScheduleSerializer do
  before :each do
    @schedule = FactoryGirl.create :schedule
    @json = ScheduleSerializer.new(@schedule, root: false).to_json
  end

  it 'should contain id as string' do
    expect(@json).to match(/"id":"#{@schedule.id.to_s}"/)
  end
end

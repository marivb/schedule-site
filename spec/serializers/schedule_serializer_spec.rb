describe ScheduleSerializer do
  before :each do
    @schedule = FactoryGirl.build :schedule, id: BSON::ObjectId.new
    @json = ScheduleSerializer.new(@schedule, root: false).to_json
  end

  it 'should contain id as string' do
    expect(@json).to match(/"id":"#{@schedule.id}"/)
  end

  it 'should contain name as string' do
    expect(@json).to match(/"name":"#{@schedule.name}"/)
  end

  it 'should contain times as array of strings' do
    expect(@json).to match(/"times":\[("\d\d:\d\d",?)+\]/)
  end
end

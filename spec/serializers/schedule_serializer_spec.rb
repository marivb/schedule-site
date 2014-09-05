describe ScheduleSerializer do
  before :each do
    @schedule = FactoryGirl.build :schedule, id: BSON::ObjectId.new
    @json = ScheduleSerializer.new(@schedule, root: false).to_json
  end

  it 'contains id as string' do
    expect(@json).to match(/"id":"#{@schedule.id}"/)
  end

  it 'contains name as string' do
    expect(@json).to match(/"name":"#{@schedule.name}"/)
  end

  it 'contains times as array' do
    expect(@json).to match(/"times":\[{"id":"#{@schedule.times[0].id}".+\]/)
  end
end

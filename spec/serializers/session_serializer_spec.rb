describe SessionSerializer do
  before :each do
    schedule = FactoryGirl.build :schedule
    @session = FactoryGirl.build :session, id: BSON::ObjectId.new, schedule: schedule
    @json = SessionSerializer.new(@session, root: false).to_json
  end

  it 'should contain id as string' do
    expect(@json).to match(/"id":"#{@session.id}"/)
  end

  it 'should contain title as string' do
    expect(@json).to match(/"title":"#{@session.title}"/)
  end

  it 'should contain duration as integer' do
    expect(@json).to match(/"duration":#{@session.duration}/)
  end

  it 'should contain timeSlotSpan as an integer' do
    expect(@json).to match(/"timeSlotSpan":\d+/)
  end
end

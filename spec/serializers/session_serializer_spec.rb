describe SessionSerializer do
  before :each do
    @session = FactoryGirl.build :session, id: BSON::ObjectId.new
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
end

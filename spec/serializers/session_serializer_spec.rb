describe SessionSerializer do
  before :each do
    @session = FactoryGirl.create :session
    @json = SessionSerializer.new(@session, root: false).to_json
  end

  it 'should contain id as string' do
    expect(@json).to match(/"id":"#{@session.id.to_s}"/)
  end
end

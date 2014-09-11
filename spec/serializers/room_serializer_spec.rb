describe RoomSerializer do
  before :each do
    @room = FactoryGirl.build :room
    @json = RoomSerializer.new(@room, root: false).to_json
  end

  it 'contains id as a string' do
    expect(@json).to match(/"id":"#{@room.id}"/)
  end

  it 'contains name as string' do
    expect(@json).to match(/"name":"#{@room.name}"/)
  end
end

describe TimeRowSerializer do
  before :each do
    @time = FactoryGirl.build :time, id: BSON::ObjectId.new, slots: [FactoryGirl.build(:blank_slot)]
    @json = TimeRowSerializer.new(@time, root: false).to_json
  end

  it 'contains id as a string' do
    expect(@json).to match(/"id":"#{@time.id}"/)
  end

  it 'contains start as a string' do
    expect(@json).to match(/"start":"#{@time.start}"/)
  end

  it 'contains slots as an array' do
    expect(@json).to match(/"slots":\[{"id":"#{@time.slots[0].id}".+\]/)
  end
end

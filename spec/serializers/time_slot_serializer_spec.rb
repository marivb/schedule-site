describe TimeSlotSerializer do
  before :each do
    @time_slot = TimeSlot.new(11.hours + 15.minutes)
    @json = TimeSlotSerializer.new(@time_slot, root: false).to_json
  end

  it 'should contain id as a number' do
    expect(@json).to match(/"id":\d+/)
  end

  it 'should contain start as a string' do
    expect(@json).to match(/"start":"#{@time_slot.start}"/)
  end
end

describe TimeSlot do
  before :each do
    @time_slot = TimeSlot.new(11.hours + 15.minutes)
  end

  it 'should have numeric id' do
    expect(@time_slot.id).to eq(40500)
  end

  it 'should have formatted time as start' do
    expect(@time_slot.start).to eq('11:15')
  end
end

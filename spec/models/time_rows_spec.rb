require 'rails_helper'

describe TimeRow, type: :model do
  it 'validates slots' do
    time = TimeRow.new start_delta: 6.hours
    time.slots.build type: Slot::TYPES.SESSION
    expect(time).to_not be_valid
  end

  it 'formats start_delta' do
    time = TimeRow.new start_delta: 6.hours + 15.minutes
    expect(time.start).to eq('06:15')
  end
end

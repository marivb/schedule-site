require 'rails_helper'

describe Schedule do
  before :each do
    @schedule = Schedule.build_empty start_time: 9.hours, end_time: 11.hours, slot_interval: 30
  end

  describe 'with ScheduleTime type' do
    it 'allows creating and retrieving by ActiveSupport::Duration' do
      @schedule.save!

      expect(Schedule.where(start_time: 9.hours).first).to eq(@schedule)
    end
  end

  describe 'self.build_empty' do
    context 'with required attributes' do
      it 'creates times for each interval' do
        expect(@schedule.times.collect(&:start)).to eq(['09:00', '09:30', '10:00', '10:30'])
      end

      it 'no slots are present' do
        slot_counts = @schedule.times.collect { |time| time.slots.size }
        expect(slot_counts).to eq([0, 0, 0, 0])
      end
    end

    context 'without required attributes' do
      it 'raises error' do
        expect {
          Schedule.build_empty
        }.to raise_error('Cannot build full schedule')
      end
    end
  end

  describe 'validations' do
    context 'no rooms and no slots' do
      it 'is valid' do
        expect(@schedule).to be_valid
      end
    end

    context 'number of rooms matches number of columns' do
      it 'is valid' do
        @schedule.rooms.build name: 'Room 1'
        @schedule.add_slot_column
        expect(@schedule).to be_valid
      end
    end

    context 'number of rooms less than number of columns' do
      it 'is not valid' do
        @schedule.add_slot_column
        expect(@schedule).to_not be_valid
      end
    end

    context 'number of rooms more than number of columns' do
      it 'is not valid' do
        @schedule.rooms.build name: 'Room 1'
        expect(@schedule).to_not be_valid
      end
    end

    context 'uneven number of slots in times' do
      it 'is not valid' do
        @schedule.times[1].slots.build type: Slot::TYPES.BLANK
        expect(@schedule).to_not be_valid
      end
    end
  end

  describe 'add_slot_column' do
    it 'adds a slot to all times' do
      @schedule.add_slot_column
      expect(@schedule.times.collect {|t| t.slots.size}).to eq([1, 1, 1, 1])
    end
  end

  describe 'add_session' do
    before :each do
      @schedule.add_slot_column
      @session = FactoryGirl.build :session, schedule: @schedule
      @slot = @schedule.times[0].slots[0]
    end

    context 'session spanning one time' do
      before :each do
        @session.duration = 30
        @schedule.add_session @slot, @session
      end

      it 'changes slot to that session' do
        expect(@slot).to be_session
      end

      it 'does not change slot in following time' do
        expect(@schedule.times[1].slots[0]).to be_blank
      end
    end

    context 'session spanning two times' do
      before :each do
        @session.duration = 60
        @schedule.add_session @slot, @session
      end

      it 'changes first slot to session' do
        expect(@slot).to be_session
      end

      it 'changes second slot to cont' do
        expect(@schedule.times[1].slots[0]).to be_cont
      end

      it 'does not change third slot' do
        expect(@schedule.times[2].slots[0]).to be_blank
      end
    end

    context 'session spanning two times with second slot taken' do
      before :each do
        scheduled_session = @schedule.sessions.build duration: 30
        second_slot = @schedule.times[1].slots[0]
        @schedule.add_session second_slot, scheduled_session

        @session.duration = 60
        @schedule.add_session @slot, @session
      end

      it 'changes first slot to invalid' do
        expect(@slot.type).to eq('invalid')
      end

      it 'does not change second slot' do
        expect(@schedule.times[1].slots[0]).to be_session
      end
    end

    context 'session spanning two times at end of schedule' do
      before :each do
        @slot = @schedule.times[3].slots[0]
        @session.duration = 60
        @schedule.add_session @slot, @session
      end

      it 'changes first slot to invalid' do
        expect(@slot.type).to eq('invalid')
      end
    end

    context 'session spanning two times on second column' do
      before :each do
        @schedule.add_slot_column
        @slot = @schedule.times[0].slots[1]
        @session.duration = 60
        @schedule.add_session @slot, @session
      end

      it 'changes first slot to session' do
        expect(@slot).to be_session
      end

      it 'changes second slot to cont' do
        expect(@schedule.times[1].slots[1]).to be_cont
      end

      it 'does not change third slot' do
        expect(@schedule.times[2].slots[1]).to be_blank
      end
    end
  end

  describe 'clear' do
    before :each do
      @schedule.add_slot_column
      @session = FactoryGirl.build :session, schedule: @schedule
      allow(Session).to receive(:find).with(@session.id).and_return(@session)
      @slot = @schedule.times[0].slots[0]
    end

    context 'session spanning one time' do
      before :each do
        @session.duration = 30
        @schedule.add_session @slot, @session
        @schedule.clear @slot
      end

      it 'clears the slot' do
        expect(@slot).to be_blank
      end
    end

    context 'session spanning two times' do
      before :each do
        @session.duration = 60
        @schedule.add_session @slot, @session
      end

      context 'clear session slot' do
        before :each do
          @schedule.clear @slot
        end

        it 'clears the slot' do
          expect(@slot).to be_blank
        end

        it 'clears the following slot' do
          expect(@schedule.times[1].slots[0]).to be_blank
        end
      end

      context 'clear cont slot' do
        it 'raises error' do
          expect {
            @schedule.clear @schedule.times[1].slots[0]
          }.to raise_error
        end
      end
    end

    context 'session spanning two times on second column' do
      before :each do
        @schedule.add_slot_column
        @slot = @schedule.times[0].slots[1]
        @session.duration = 60
        @schedule.add_session @slot, @session
        @schedule.clear @slot
      end

      it 'clears the slot' do
        expect(@slot).to be_blank
      end

      it 'clears the second slot' do
        expect(@schedule.times[1].slots[1]).to be_blank
      end
    end
  end
end

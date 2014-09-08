require 'rails_helper'

describe Schedule do
  describe 'with ScheduleTime type' do
    it 'allows creating and retrieving by ActiveSupport::Duration' do
      schedule = Schedule.create start_time: 9.hours

      expect(Schedule.where(start_time: 9.hours).first).to eq(schedule)
    end
  end

  describe 'self.build_full' do
    context 'with required attributes' do
      before :each do
        @schedule = Schedule.build_full start_time: 9.hours, end_time: 11.hours, slot_interval: 30
      end

      it 'creates times for each interval' do
        expect(@schedule.times.collect(&:start)).to eq(['09:00', '09:30', '10:00', '10:30'])
      end

      it 'creates blank slots for each time' do
        slot_types = @schedule.times.collect { |time| time.slots.collect(&:type) }
        expect(slot_types).to eq([[Slot::TYPES.BLANK]] * 4)
      end
    end

    context 'without required attributes' do
      it 'raises error' do
        expect {
          Schedule.build_full
        }.to raise_error('Cannot build full schedule')
      end
    end
  end

  describe 'add_session' do
    before :each do
      @schedule = Schedule.build_full start_time: 9.hours, end_time: 11.hours, slot_interval: 30
      @session = @schedule.sessions.build
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

      it 'changes first slot to session' do
        expect(@slot).to be_session
      end

      it 'changes second slot to invalid' do
        expect(@schedule.times[1].slots[0].type).to eq('invalid')
      end
    end
  end

  describe 'clear' do
    before :each do
      @schedule = Schedule.build_full start_time: 9.hours, end_time: 11.hours, slot_interval: 30
      @session = @schedule.sessions.build
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
  end
end

require 'rails_helper'

describe ScheduleEditor do
  before :each do
    @schedule = FactoryGirl.build :schedule, slot_interval: 15
    @session = FactoryGirl.build :session, schedule: @schedule, duration: 15
    allow(Session).to receive(:find).with(@session.id).and_return(@session)

    @editor = ScheduleEditor.new @schedule
  end

  context 'sessionAdd' do
    before :each do
      time = @schedule.times[0]
      slot = time.slots[0]

      data = { time_id: time.id, slot_id: slot.id, session_id: @session.id }
      @editor.process type: 'sessionAdd', data: data
    end

    describe 'process' do
      it 'adds session to schedule' do
        expect(@schedule.times[0].slots[0]).to be_session
      end

      it 'marks session as placed' do
        expect(@session).to be_placed
      end

      it 'does not save schedule' do
        expect(@schedule).to_not be_persisted
      end

      it 'does not save session' do
        expect(@session).to_not be_persisted
      end
    end

    describe 'save' do
      it 'returns true' do
        expect(@editor.save).to eq(true)
      end

      it 'persists schedule' do
        @editor.save
        expect(@schedule).to be_persisted
      end

      it 'persists session' do
        @editor.save
        expect(@session).to be_persisted
      end
    end
  end

  context 'sessionRemove' do
    before :each do
      time = @schedule.times[0]
      slot = time.slots[0]
      @schedule.add_session slot, @session
      @session.placed = true

      data = { time_id: time.id, slot_id: slot.id }
      @editor.process type: 'sessionRemove', data: data
    end

    describe 'process' do
      it 'removes session from schedule' do
        expect(@schedule.times[0].slots[0]).to be_blank
      end

      it 'marks session as not placed' do
        expect(@session).to_not be_placed
      end

      it 'does not save schedule' do
        expect(@schedule).to_not be_persisted
      end

      it 'does not save session' do
        expect(@session).to_not be_persisted
      end
    end

    describe 'save' do
      it 'returns true' do
        expect(@editor.save).to eq(true)
      end

      it 'persists schedule' do
        @editor.save
        expect(@schedule).to be_persisted
      end

      it 'persists session' do
        @editor.save
        expect(@session).to be_persisted
      end
    end
  end

  context 'roomAdd' do
    before :each do
      @editor.process type: 'roomAdd', data: {}
    end

    describe 'process' do
      it 'adds a new column to schedule' do
        expect(@schedule.times[0].slots.size).to eq(2)
      end
    end

    describe 'save' do
      it 'returns true' do
        expect(@editor.save).to eq(true)
      end

      it 'persists schedule' do
        @editor.save
        expect(@schedule).to be_persisted
      end
    end
  end

  context 'invalid change' do
    before :each do
      time = @schedule.times[0]
      slot = time.slots[0]
      @schedule.add_session slot, @session
      @session.placed = true

      data = { time_id: time.id, slot_id: slot.id, session_id: @session.id }
      @editor.process type: 'sessionAdd', data: data
    end

    it 'returns false' do
      expect(@editor.save).to eq(false)
    end

    it 'does not persist schedule' do
      @editor.save
      expect(@schedule).to_not be_persisted
    end

    it 'does not persist session' do
      @editor.save
      expect(@session).to_not be_persisted
    end

    it 'populates schedule errors' do
      @editor.save
      expect(@schedule.errors).to_not be_empty
    end
  end
end

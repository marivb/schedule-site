require 'rails_helper'

def it_does_not_save_document
  it 'does not save document' do
    schedule = FactoryGirl.create :schedule
    slot = schedule.times[0].slots[0]

    yield(slot, schedule)

    expect(slot).to be_changed
  end
end

describe Slot, type: :model do
  let(:session_id) { BSON::ObjectId.new }

  describe 'session' do
    context 'not session type' do
      it 'is nil' do
        slot = Slot.new type: Slot::TYPES.BLANK
        expect(slot.session).to be_nil
      end
    end

    context 'session type' do
      it 'is corresponding session' do
        session = FactoryGirl.create :session
        slot = Slot.new type: Slot::TYPES.SESSION, session_id: session.id
        expect(slot.session).to eq(session)
      end
    end
  end

  describe 'validations' do
    context 'blank' do
      context 'no session' do
        it 'is valid' do
          slot = Slot.new type: Slot::TYPES.BLANK
          expect(slot).to be_valid
        end
      end

      context 'with session' do
        it 'is not valid' do
          slot = Slot.new type: Slot::TYPES.BLANK, session_id: session_id
          expect(slot).to_not be_valid
        end
      end
    end

    context 'session' do
      context 'no session' do
        it 'is not valid' do
          slot = Slot.new type: Slot::TYPES.SESSION
          expect(slot).to_not be_valid
        end
      end

      context 'with session' do
        it 'is valid' do
          slot = Slot.new type: Slot::TYPES.SESSION, session_id: session_id
          expect(slot).to be_valid
        end
      end
    end

    context 'cont' do
      context 'no session' do
        it 'is valid' do
          slot = Slot.new type: Slot::TYPES.CONT
          expect(slot).to be_valid
        end
      end

      context 'with session' do
        it 'is not valid' do
          slot = Slot.new type: Slot::TYPES.CONT, session_id: session_id
          expect(slot).to_not be_valid
        end
      end
    end

    context 'no type' do
      it 'is not valid' do
        slot = Slot.new
        expect(slot).to_not be_valid
      end
    end

    context 'invalid type' do
      it 'is not valid' do
        slot = Slot.new type: 'invalid'
        expect(slot).to_not be_valid
      end
    end
  end

  describe 'modifiers' do
    describe 'add_session' do
      let(:session) { FactoryGirl.build :session, id: session_id }

      context 'from blank' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.BLANK
          @slot.add_session session
        end

        it 'sets type to session' do
          expect(@slot).to be_session
        end

        it 'sets session_id' do
          expect(@slot.session_id).to eq(session_id)
        end
      end

      context 'from cont' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.CONT
          @slot.add_session session
        end

        it 'sets type to invalid' do
          expect(@slot.type).to eq('invalid')
        end
      end

      context 'from session' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.SESSION
          @slot.add_session session
        end

        it 'sets type to invalid' do
          expect(@slot.type).to eq('invalid')
        end
      end

      context 'when persisted' do
        it_does_not_save_document do |slot, schedule|
          session = FactoryGirl.create :session, schedule: schedule
          slot.add_session session
        end
      end
    end

    describe 'continue' do
      context 'from blank' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.BLANK
          @slot.continue
        end

        it 'sets type to cont' do
          expect(@slot).to be_cont
        end
      end

      context 'from cont' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.CONT
          @slot.continue
        end

        it 'sets type to invalid' do
          expect(@slot.type).to eq('invalid')
        end
      end

      context 'from session' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.SESSION, session_id: session_id
          @slot.continue
        end

        it 'sets type to invalid' do
          expect(@slot.type).to eq('invalid')
        end
      end

      context 'when persisted' do
        it_does_not_save_document do |slot, schedule|
          slot.continue
        end
      end
    end

    context 'invalidate' do
      context 'from any type' do
        before :each do
          @slot = Slot.new
          @slot.invalidate
        end

        it 'sets type to invalid' do
          expect(@slot.type).to eq('invalid')
        end
      end

      context 'when persisted' do
        it_does_not_save_document do |slot, schedule|
          slot.invalidate
        end
      end
    end

    describe 'clear' do
      context 'from blank' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.BLANK
          @slot.clear
        end

        it 'leaves type as blank' do
          expect(@slot).to be_blank
        end
      end

      context 'from cont' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.CONT
          @slot.clear
        end

        it 'sets type to blank' do
          expect(@slot).to be_blank
        end
      end

      context 'from session' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.SESSION, session_id: session_id
          @slot.clear
        end

        it 'sets type to blank' do
          expect(@slot).to be_blank
        end

        it 'sets session_id to nil' do
          expect(@slot.session_id).to be_nil
        end
      end

      context 'when persisted' do
        it_does_not_save_document do |slot, schedule|
          slot.continue
          schedule.save!

          slot.clear
        end
      end
    end
  end
end

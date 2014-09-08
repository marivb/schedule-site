require 'rails_helper'

describe Slot, type: :model do
  let(:session) { FactoryGirl.build :session }

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
          slot = Slot.new type: Slot::TYPES.BLANK, session: session
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
          slot = Slot.new type: Slot::TYPES.SESSION, session: session
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
          slot = Slot.new type: Slot::TYPES.CONT, session: session
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
      context 'from blank' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.BLANK
          @slot.add_session session
        end

        it 'sets type to session' do
          expect(@slot).to be_session
        end

        it 'sets session' do
          expect(@slot.session).to eq(session)
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
        it 'does not save document' do
          schedule = FactoryGirl.create :schedule
          slot = schedule.times[0].slots[0]

          session = FactoryGirl.create :session, schedule: schedule
          slot.add_session session
          expect(slot).to be_changed
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
          @slot = Slot.new type: Slot::TYPES.SESSION, session: session
          @slot.continue
        end

        it 'sets type to invalid' do
          expect(@slot.type).to eq('invalid')
        end
      end

      context 'when persisted' do
        it 'does not save document' do
          schedule = FactoryGirl.create :schedule
          slot = schedule.times[0].slots[0]

          slot.continue
          expect(slot).to be_changed
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
          @slot = Slot.new type: Slot::TYPES.SESSION, session: session
          @slot.clear
        end

        it 'sets type to blank' do
          expect(@slot).to be_blank
        end

        it 'sets session to nil' do
          expect(@slot.session).to be_nil
        end
      end

      context 'when persisted' do
        it 'does not save document' do
          schedule = FactoryGirl.create :schedule
          slot = schedule.times[0].slots[0]
          slot.continue
          schedule.save!

          slot.clear
          expect(slot).to be_changed
        end
      end
    end
  end
end

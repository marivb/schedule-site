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
        slot = Slot.new type: 'any'
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
        end

        it 'raises error' do
          expect {
            @slot.add_session session
          }.to raise_error
        end
      end

      context 'from session' do
        before :each do
          @slot = Slot.new type: Slot::TYPES.SESSION
        end

        it 'raises error' do
          expect {
            @slot.add_session session
          }.to raise_error
        end
      end
    end

    describe 'clear' do
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
    end
  end
end

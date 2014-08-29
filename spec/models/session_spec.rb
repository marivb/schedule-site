describe Session do
  describe 'validation' do
    before :each do
      @valid_attributes = FactoryGirl.attributes_for :session
    end

    context 'valid attributes' do
      it 'is valid' do
        session = Session.new @valid_attributes
        expect(session).to be_valid
      end
    end

    context 'no title' do
      it 'is not valid' do
        session = Session.new @valid_attributes.merge(title: '')
        expect(session).to_not be_valid
      end
    end

    context 'no schedule_id' do
      it 'is not valid' do
        session = Session.new @valid_attributes.merge(schedule_id: '')
        expect(session).to_not be_valid
      end
    end

    context 'no duration' do
      it 'is not valid' do
        session = Session.new @valid_attributes.merge(duration: '')
        expect(session).to_not be_valid
      end
    end

    context 'non-integer duration' do
      it 'is not valid' do
        session = Session.new @valid_attributes.merge(duration: 10.5)
        expect(session).to_not be_valid
      end
    end

    context 'non-positive duration' do
      it 'is not valid' do
        session = Session.new @valid_attributes.merge(duration: 0)
        expect(session).to_not be_valid
      end
    end
  end
end

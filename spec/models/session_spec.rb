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
  end
end

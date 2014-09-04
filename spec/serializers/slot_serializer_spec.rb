describe SlotSerializer do
  context 'not session' do
    before :each do
      @slot = FactoryGirl.build :blank_slot, id: BSON::ObjectId.new
      @json = SlotSerializer.new(@slot, root: false).to_json
    end

    it 'contains id as string' do
      expect(@json).to match(/"id":"#{@slot.id}"/)
    end

    it 'contains type as string' do
      expect(@json).to match(/"type":"#{@slot.type}"/)
    end
  end

  context ' session' do
    before :each do
      @slot = FactoryGirl.build :session_slot, id: BSON::ObjectId.new
      @json = SlotSerializer.new(@slot, root: false).to_json
    end

    it 'contains id as string' do
      expect(@json).to match(/"id":"#{@slot.id}"/)
    end

    it 'contains type as string' do
      expect(@json).to match(/"type":"#{@slot.type}"/)
    end

    it 'contains session id as string' do
      expect(@json).to match(/"sessionId":"#{@slot.session.id}"/)
    end
  end
end

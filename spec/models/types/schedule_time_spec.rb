describe Types::ScheduleTime do
  describe '#mongoize' do
    it 'should store schedule time as seconds from midnight' do
      time = Types::ScheduleTime.new 6.hours
      expect(time.mongoize).to eq(6 * 60 * 60)
    end
  end

  describe 'self.demongoize' do
    it 'should create schedule time with value as seconds from midnight' do
      time = Types::ScheduleTime.demongoize(6 * 60 * 60)
      expect(time.duration).to eq(6.hours)
    end
  end

  describe 'self.mongoize' do
    it 'should store ScheduleTime as seconds from midnight' do
      time = Types::ScheduleTime.new 6.hours
      expect(Types::ScheduleTime.mongoize(time)).to eq(6 * 60 * 60)
    end

    it 'should store ActiveSupport::Duration as integer' do
      expect(Types::ScheduleTime.mongoize(6.hours)).to eq(6 * 60 * 60)
    end
  end

  describe 'self.evolve' do
    it 'should convert ScheduleTime to seconds from midnight' do
      time = Types::ScheduleTime.new 6.hours
      expect(Types::ScheduleTime.evolve(time)).to eq(6 * 60 * 60)
    end

    it 'should convert ActiveSupport::Duration to integer' do
      expect(Types::ScheduleTime.evolve(6.hours)).to eq(6 * 60 * 60)
    end
  end

  describe '#until' do
    it 'should range until given time by steps of given interval in minutes' do
      start_time = Types::ScheduleTime.new 6.hours
      end_time = Types::ScheduleTime.new 7.hours
      expect(start_time.until(end_time, 15)).to eq([6.hours,
                                                    6.hours + 15.minutes,
                                                    6.hours + 30.minutes,
                                                    6.hours + 45.minutes
      ])
    end
  end
end

class Types::ScheduleTime
  attr_reader :duration

  def initialize(duration)
    @duration = duration.seconds
  end

  def mongoize
    @duration.to_i
  end

  def until(time, interval = 1.minute)
    (@duration...time.duration).step(interval.minutes).to_a
  end

  class << self

    def demongoize(object)
      self.new(object.to_i)
    end

    def mongoize(object)
      case object
      when Types::ScheduleTime then object.mongoize
      else object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when Types::ScheduleTime then object.mongoize
      else object
      end
    end
  end
end

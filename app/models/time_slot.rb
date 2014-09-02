class TimeSlot
  include ActiveModel::Serialization

  def initialize(start)
    @start = start
  end

  def id
    @start.to_i
  end

  def start
    formatable_time = Time.now.beginning_of_day + @start
    formatable_time.strftime('%H:%M')
  end

  def == object
    object.is_a?(TimeSlot) && id == object.id
  end
end

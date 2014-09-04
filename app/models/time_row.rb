class TimeRow
  include Mongoid::Document

  field :start_delta, type: Types::ScheduleTime

  embedded_in :schedule
  embeds_many :slots, cascade_callbacks: true

  def start
    formatable_time = Time.now.beginning_of_day + start_delta.duration
    formatable_time.strftime('%H:%M')
  end
end

class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :rooms, :times

  def id
    object.id.to_s
  end
end

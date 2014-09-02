class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :times

  def id
    object.id.to_s
  end
end

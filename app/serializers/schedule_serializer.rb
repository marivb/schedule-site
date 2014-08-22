class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :name, :times

  def id
    object.id.to_s
  end
end

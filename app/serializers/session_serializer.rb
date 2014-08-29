class SessionSerializer < ActiveModel::Serializer
  attributes :id, :title, :duration

  def id
    object.id.to_s
  end
end

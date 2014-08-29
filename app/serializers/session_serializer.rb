class SessionSerializer < ActiveModel::Serializer
  attributes :id, :title

  def id
    object.id.to_s
  end
end

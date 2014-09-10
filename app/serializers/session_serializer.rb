class SessionSerializer < ActiveModel::Serializer
  attributes :id, :title, :duration, :timeSlotSpan, :placed

  def id
    object.id.to_s
  end

  def timeSlotSpan
    object.time_slot_span
  end

  def placed
    object.placed?
  end
end

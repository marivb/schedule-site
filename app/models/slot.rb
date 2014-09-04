class Slot
  include Mongoid::Document
  TYPES = OpenStruct.new(BLANK: 'blank', CONT: 'cont', SESSION: 'session').freeze

  field :type

  has_one :session
  embedded_in :time, class_name: 'TimeRow'

  validates :type, presence: true, inclusion: { in: TYPES.to_h.values }
  validates :session, presence: { if: :session? },
                      absence: { unless: :session? }

  def blank?
    type == TYPES.BLANK
  end

  def cont?
    type == TYPES.CONT
  end

  def session?
    type == TYPES.SESSION
  end

  def add_session session
    raise 'Not allowed' unless blank?
    set type: TYPES.SESSION, session: session
  end

  def clear
    set type: TYPES.BLANK, session: nil
  end
end

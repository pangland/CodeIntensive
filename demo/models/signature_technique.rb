require_relative '../../lib/sql_object'

class SignatureTechnique < SQLObject
  belongs_to :practitioner
  has_one_through :style, through: :practitioner
end

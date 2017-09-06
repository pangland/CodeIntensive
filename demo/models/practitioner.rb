require_relative '../../lib/sql_object'

class Practitioner < SQLObject
  belongs_to :style
  has_many :signature_techniques
end

require_relative '../../lib/sql_object'

class Style < SQLObject
  has_many :practitioners
end

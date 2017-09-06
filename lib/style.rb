require_relative '../lib/sql_object'

class Practitioner < EffectiveDoc::Base
  has_many :practitioners
end

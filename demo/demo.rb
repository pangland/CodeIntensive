require_relative '../lib/sql_object'
require_relative '../lib/db_connection'

# require_relative '../lib/practioner'
# require_relative '../lib/signature_technique'
# require_relative '../lib/style'

# require_relative './models/practioner'
# require_relative './models/signature_technique'
# require_relative './models/style'

# class Practitioner < SQLObject
#   belongs_to :style
#   has_many :signature_techniques
# end

DB_FILE = 'martial_arts.db'
SQL_FILE = 'martial_arts.sql'

`rm '#{DB_FILE}'`
`cat '#{SQL_FILE}' | sqlite3 '#{DB_FILE}'`

class Style < SQLObject
  has_many :practitioners
end

class Practitioner < SQLObject
  belongs_to :style
  has_many :signature_techniques
end

class SignatureTechnique < SQLObject
  belongs_to :practitioner
end

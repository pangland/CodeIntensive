require_relative '../lib/sql_object'
# require_relative '../lib/db_connection'
require 'sqlite3'
require 'byebug'

ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
SQL_FILE = File.join(ROOT_FOLDER, 'martial_arts.sql')
DB_FILE = File.join(ROOT_FOLDER, 'martial_arts.db')

debugger

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

# DB_FILE = 'martial_arts.db'
# SQL_FILE = 'martial_arts.sql'

`rm '#{DB_FILE}'`
`cat '#{SQL_FILE}' | sqlite3 '#{DB_FILE}'`

SQLite3::Database.new(DB_FILE)



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

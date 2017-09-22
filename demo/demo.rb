require_relative '../lib/sql_object'
# require_relative '../lib/db_connection'
require 'sqlite3'
require 'byebug'

# ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
# SQL_FILE = File.join(ROOT_FOLDER, 'martial_arts.sql')
# DB_FILE = File.join(ROOT_FOLDER, 'martial_arts.db')
#
# debugger
#
#
#
# "rm '#{DB_FILE}'"
# "cat '#{SQL_FILE}' | sqlite3 '#{DB_FILE}'"
#
# SQLite3::Database.new(DB_FILE)



class Style < SQLObject
  has_many :practitioners
  debugger
  has_one_through :signature_technique, :practitioner, :signature_techniques
  self.finalize!
end

class Practitioner < SQLObject
  debugger
  belongs_to :style
  has_many :signature_techniques
  self.finalize!
end

class SignatureTechnique < SQLObject
  belongs_to :practitioner, foreign_key: :owner_id
  self.finalize!
end

require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
require_relative 'searchable'
require_relative 'associatable'

class SQLObject
  extend Searchable
  include Searchable
  extend Associatable
  include Associatable

  def self.columns
    return @columns unless @columns.nil?

    column_names = DBConnection.execute2(<<-SQL)
      SELECT *
      FROM #{self.table_name}
    SQL

    @columns = column_names[0].map{ |el| el.to_sym }

  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do
        attributes[column]
      end

      define_method("#{column.to_s}=".to_sym) do |val|
        self.attributes[column] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
    hashes = DBConnection.execute(<<-SQL)
      SELECT *
      FROM "#{self.table_name}"
    SQL

    self.parse_all(hashes)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    self.all.find { |obj| obj.id == id }
  end

  def initialize(params = {})
    debugger
    params.each do |key, value|
      key = key.to_sym
      raise "unknown attribute '#{key}'" unless self.class.columns.include?(key)
      self.send("#{key}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attributes.values
  end

  def insert
    column_names = self.class.columns
    column_names = column_names.reject { |el| el == :id }.join(',')
    attributes_present = attribute_values.reject(&:nil?)
    question_marks = (['?'] * attributes_present.length).join(',')

    DBConnection.execute(<<-SQL, *attributes_present)
      INSERT INTO #{self.class.table_name} (#{column_names})
      VALUES (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    column_names = self.class.columns
    set_thing = column_names.map { |el| "#{el} = ?" }.join(',')
    attributes_present = attribute_values.reject(&:nil?)

    DBConnection.execute(<<-SQL, *attributes_present, self.id)
      UPDATE #{self.class.table_name}
      SET #{set_thing}
      WHERE id = ?
    SQL
  end

  def save
    self.id.nil? ? insert : update
  end
end

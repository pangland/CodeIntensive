require_relative '02_searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    @class_name.constantize.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    class_name = name.to_s.singularize.underscore.camelcase.downcase
    @foreign_key = "#{class_name}_id".to_sym
    @primary_key = "id".to_sym
    @class_name = name.to_s.singularize.capitalize

    options.each do |k, v|
      instance_variable_set("@#{k.to_s}", v)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    class_name = self_class_name.to_s.singularize.underscore.camelcase.downcase
    @foreign_key = "#{class_name}_id".to_sym
    @primary_key = "id".to_sym
    @class_name = name.to_s.singularize.capitalize

    options.each do |k, v|
      instance_variable_set("@#{k.to_s}", v)
    end
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)
    options = self.assoc_options[name]

    define_method(name) do
      f_key = self.send(options.foreign_key)
      options.model_class.where(options.primary_key => f_key).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.name, options)

    define_method(name) do
      options.model_class.where(options.foreign_key => self.send(options.primary_key))
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end
end

class SQLObject
  extend Associatable
  include Associatable
end

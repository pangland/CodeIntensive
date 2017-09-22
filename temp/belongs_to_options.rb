require_relative 'assoc_options'
require_relative 'has_many_options'
require_relative 'searchable'
require 'active_support/inflector'

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

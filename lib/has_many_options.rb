require_relative 'assoc_options'

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

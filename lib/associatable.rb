require_relative 'has_many_options'
require_relative 'belongs_to_options'

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

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      # *[through_table, source_table, source_fkey, source_pkey, through_pkey, through_fkey_val] = Associatable.get_SQL_terms(through_options, source_options)

      through_table = through_options.table_name
      source_table = source_options.table_name

      source_fkey = source_options.foreign_key
      source_pkey = source_options.primary_key

      through_pkey = through_options.primary_key
      through_fkey_val = self.send(through_options.foreign_key).to_s

      blah = DBConnection.execute(<<-SQL,)
        SELECT #{source_table}.*
        FROM #{through_table}
        JOIN #{source_table}
        ON #{through_table}.#{source_fkey} = #{source_table}.#{source_pkey}
        WHERE #{through_table}.#{through_pkey} = #{through_fkey_val}
      SQL

      source_options.model_class.parse_all(blah).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end

  private

  def get_SQL_terms(through_options, source_options)
    # through_table = through_options.table_name
    # source_table = source_options.table_name
    #
    # source_fkey = source_options.foreign_key
    # source_pkey = source_options.primary_key
    #
    # through_pkey = through_options.primary_key
    # through_fkey_val = self.send(through_options.foreign_key).to_s
    #
    # *[through_table, source_table, source_fkey, source_pkey, through_pkey, through_fkey_val]
  end
end

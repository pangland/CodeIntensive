require_relative '03_associatable'

module Associatable
  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      source_table = source_options.table_name

      source_fkey = source_options.foreign_key
      source_pkey = source_options.primary_key

      through_pkey = through_options.primary_key
      through_fkey_val = self.send(through_options.foreign_key).to_s

      # join_stuff = [through_options.foreign_key.to_s,
      #   source_options.primary_key.to_s]

      join_stuff = ["#{through_options.table_name}.#{source_options.foreign_key}",
        "#{source_options.table_name}.#{source_options.primary_key}"]

      # where_line = [source_options.primary_key.to_s,
      #   self.send(through_options.foreign_key.to_s)]

      where_line = ["#{through_options.table_name}.#{through_options.primary_key}",
        self.send(through_options.foreign_key).to_s]

      blah = DBConnection.execute(<<-SQL,)
        SELECT #{source_table}.*
        FROM #{through_table}
        JOIN #{source_table}
        ON #{through_table}.#{source_fkey} = #{source_table}.#{source_pkey}
        WHERE #{through_table}.#{through_pkey} = #{through_fkey_val}
      SQL

      source_options.model_class.parse_all(blah).first

      # ON #{through_options.table_name}.#{source_options.foreign_key} = #{source_options.table_name}.#{source_options.primary_key}
      # WHERE #{through_options.table_name}.#{through_options.primary_key} = #{self.send(through_options.foreign_key).to_s}
    end
  end
end

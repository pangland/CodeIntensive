require_relative '03_associatable'

module Associatable
  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      # join_stuff = [through_options.foreign_key.to_s,
      #   source_options.primary_key.to_s]

      join_stuff = ["#{through_options.table_name}.#{source_options.foreign_key}",
        "#{source_options.table_name}.#{source_options.primary_key}"]

      # where_line = [source_options.primary_key.to_s,
      #   self.send(through_options.foreign_key.to_s)]

      where_line = ["#{through_options.table_name}.#{through_options.primary_key}",
        self.send(through_options.foreign_key).to_s]

      blah = DBConnection.execute(<<-SQL, *join_stuff, *where_line)
        SELECT #{source_options.table_name}.*
        FROM #{through_options.table_name}
        JOIN #{source_options.table_name}
        ON ? = ?
        WHERE ? = ?
      SQL

      debugger
      source_options.model_class.parse_all(blah).first

      # ON #{through_options.table_name}.#{source_options.foreign_key} = #{source_options.table_name}.#{source_options.primary_key}
      # WHERE #{through_options.table_name}.#{through_options.primary_key} = #{self.send(through_options.foreign_key).to_s}
    end
  end
end

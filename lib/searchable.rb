module Searchable
  def where(params)
    where_line = params.keys.map { |el| "#{el} = ?"}.join(' AND ')
    param_values = params.values.map(&:to_s)
    search_query = DBConnection.execute(<<-SQL, *param_values)
      SELECT *
      FROM #{table_name}
      WHERE #{where_line}
    SQL

    parse_all(search_query)
  end
end

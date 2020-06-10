
module QueryModelPatch
  def sql_for_field(field, operator, value, db_table, db_field, is_custom_filter=false)
    if field == 'project_id' && operator == '=*'
        value_str = value.join(",")
        sql = "#{db_table}.#{db_field} IN (SELECT id FROM projects where id IN (#{value_str}) OR parent_id IN (#{value_str}))"
    else
        super
    end
  end
end

# Add module to Query Model
Query.prepend QueryModelPatch


module QueryModelPatch
  def get_parents(value, all = [])
    if all.empty?
      all = value
    end
    projects = Project.where(parent_id: value)
    new_ids = []
    projects.each do |project|
      new_ids.push(project.id)
      all.push(project.id)
    end
    unless new_ids.empty?
      get_parents(new_ids, all)
    else
      all
    end
  end
  def sql_for_field(field, operator, value, db_table, db_field, is_custom_filter=false)
    if field == 'project_id' && operator == '=*'
        ids = get_parents(value)
        value_str = ids.join(",")
        sql = "#{db_table}.#{db_field} IN (SELECT id FROM projects where id IN (#{value_str}) OR parent_id IN (#{value_str}))"
    else
        super
    end
  end
end

# Add module to Query Model
Query.prepend QueryModelPatch


module QueryModelPatch

  # Get all descendants projects for given ids.
  def get_descendant_projects(value, all = [])
    if all.empty?
      all = value
    end
    projects = Project.where(parent_id: value)
    new_ids = []
    projects.each do |project|
      new_ids.push(project.id)
      all.push(project.id)
    end
    # If no more new items, return all collected ids, otherwise keep looking.
    unless new_ids.empty?
      get_descendant_projects(new_ids, all)
    else
      all
    end
  end
  def sql_for_field(field, operator, value, db_table, db_field, is_custom_filter=false)
    if field == 'project_id' && operator == '=*'
        ids = get_descendant_projects(value)
        value_str = ids.join(",")
        sql = "#{db_table}.#{db_field} IN (SELECT id FROM projects where id IN (#{value_str}))"
    elsif field == 'spent_on' && operator == 'tlm'
        prevDate = User.current.today.prev_month
        currentDate = User.current.today
        sql = date_clause(db_table, db_field,
                          prevDate.beginning_of_month, currentDate.end_of_month,
                          is_custom_filter)
    else
        super
    end
  end

  def add_filter_error(field, message)
    unless message == :blank && field == 'spent_on'
      super
    end
  end

end

# Add module to Query Model
Query.prepend QueryModelPatch

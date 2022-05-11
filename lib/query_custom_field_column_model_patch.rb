
module QueryCustomFieldColumnModelPatch

  def value_object(object)
    if (not object.instance_variable_defined?(:@project)) || custom_field.visible_by?(object.project, User.current)
      cv = object.custom_values.select {|v| v.custom_field_id == @cf.id}
      cv.size > 1 ? cv.sort_by {|e| e.value.to_s} : cv.first
    else
      nil
    end
  end
end

# Add module to Query Model
QueryCustomFieldColumn.prepend QueryCustomFieldColumnModelPatch

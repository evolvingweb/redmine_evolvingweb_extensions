
module TimeEntryQueryModelPatch

  def user_custom_fields
    UserCustomField.sorted
  end

  def available_columns
    return @available_columns if @available_columns

    @available_columns = super

    @available_columns += user_custom_fields.visible.
                            map {|cf| QueryAssociationCustomFieldColumn.new(:user, cf)}

    @available_columns
  end
end

# Add module to TimeEntryQuery Model
TimeEntryQuery.prepend TimeEntryQueryModelPatch

# Patch issue import to account for new values.
module IssueImportPatch

  private

  def build_object(row, item)
    field_name = "cf_#{settings["unique_id"]["field"]}"
    unique_id = row_value(row, field_name)
    update = settings["unique_id"]["update"]
    issue = super
    issues = Issue.find_by_sql(["
      SELECT * FROM issues i
      INNER JOIN custom_values cv ON cv.customized_id = i.id
        AND cv.customized_type = 'Issue'
        AND cv.custom_field_id = ?
        AND cv.value = ?", settings["unique_id"]["field"], unique_id])
    unless issues.empty?
      existing_issue = issues.first
      if update == 'on'
        # @TODO: Update issue?
        #issue.id = existing_issue.id
      else
        issue = nil
      end
    end

    issue
  end
end

IssueImport.prepend IssueImportPatch

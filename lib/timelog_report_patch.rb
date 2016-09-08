# Prints issues as links in time reports
module TimelogHelperPatch
  def format_criteria_value(criteria_options, value)
    return link_to_issue(Issue.find(value)) \
      if criteria_options[:label] == :label_issue
    super
  end
end

TimelogHelper.prepend TimelogHelperPatch

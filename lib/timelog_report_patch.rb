# Prints issues as links in time reports
module TimelogHelperPatch
  def format_criteria_value(criteria_options, value)
    # If it's an issue, and value looks like an integer, make it a link
    if criteria_options[:label] == :label_issue
      begin
        intvalue = Integer(value)
        return link_to_issue(Issue.find(value))
      rescue
      end
    end

    super
  end
end

TimelogHelper.prepend TimelogHelperPatch

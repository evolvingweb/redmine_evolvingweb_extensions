module EvolvingwebExtensions
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
      p = context[:request].params
      Rails.logger.warn(p)
      if p[:controller] == "issues" && p[:action] == "show"
        javascript_include_tag "inject_subtask_clone_link", :plugin => 'redmine_evolvingweb_extensions'
      end
      if p[:controller] == "timelog" && p[:action] == "report"
        js_files = %w{moment.min.js redmine-time-entries-report-week.js}
        js_files.map do |file|
          javascript_include_tag(file, :plugin=> 'redmine_evolvingweb_extensions')
        end
      end
    end
  end
end

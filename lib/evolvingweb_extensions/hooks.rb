module EvolvingwebExtensions
  class JSTimelogReportHooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
      p = context[:request].params
      if p[:controller] == "timelog"
        js_files = %w{moment.min.js redmine-time-entries-report.js}
        if p[:action] == "report"
          js_files = %w{moment.min.js redmine-time-entries-report.js time-report-sort.js}
        end
        js_files.map do |file|
          javascript_include_tag(file, :plugin=> 'redmine_evolvingweb_extensions')
        end
      end
    end
  end
  class JSIssueShowHooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
      p = context[:request].params
      if p[:controller] == "issues" && p[:action] == "show"
        js_files = %w{inject_subtask_clone_link.js image-notes.js}
        js_files.map do |file|
          javascript_include_tag(file, :plugin=> 'redmine_evolvingweb_extensions')
        end
      end
    end
  end
  class CSSHooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
      p = context[:request].params
      if p[:controller] == "timelog"
        css_files = %w{redmine-time-entries-report.css}
        css_files.map do |file|
          stylesheet_link_tag(file, :plugin=> 'redmine_evolvingweb_extensions')
        end
      end
    end
  end
end

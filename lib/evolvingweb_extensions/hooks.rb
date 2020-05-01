module EvolvingwebExtensions
  class JSHooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
      p = context[:request].params
      if p[:controller] == "issues" && p[:action] == "show"
        javascript_include_tag "inject_subtask_clone_link", :plugin => 'redmine_evolvingweb_extensions'
      end
      if p[:controller] == "timelog" && p[:action] == "report"
        js_files = %w{moment.min.js redmine-time-entries-report.js}
        js_files.map do |file|
          javascript_include_tag(file, :plugin=> 'redmine_evolvingweb_extensions')
        end
      end
    end
  end
  class CSSHooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
      p = context[:request].params
      if p[:controller] == "issues" && p[:action] == "show"
        javascript_include_tag "inject_subtask_clone_link", :plugin => 'redmine_evolvingweb_extensions'
      end
      if p[:controller] == "timelog" && p[:action] == "report"
        css_files = %w{redmine-time-entries-report.css}
        css_files.map do |file|
          stylesheet_link_tag(file, :plugin=> 'redmine_evolvingweb_extensions')
        end
      end
    end
  end
end

module EvolvingwebExtensions
  class Hooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
      p = context[:request].params
      return unless p[:controller] == "issues" && p[:action] == "show"
      javascript_include_tag "inject_subtask_clone_link", :plugin => 'redmine_evolvingweb_extensions'
    end
  end
end

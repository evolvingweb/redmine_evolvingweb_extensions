module EvolvingwebExtensions
  module Hooks
    class JsIssueShowHooks < Redmine::Hook::ViewListener
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
  end
end

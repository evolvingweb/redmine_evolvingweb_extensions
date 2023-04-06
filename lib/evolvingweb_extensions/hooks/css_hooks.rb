module EvolvingwebExtensions
  module Hooks
    class CssHooks < Redmine::Hook::ViewListener
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
end

module EvolvingwebExtensions
  module Hooks
    class JsTimelogReportHooks < Redmine::Hook::ViewListener
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
  end
end

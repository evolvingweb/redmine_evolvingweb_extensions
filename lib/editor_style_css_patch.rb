# Fix the broken Issue description text area due to wiki plugin.

require_dependency 'application_helper'

class EditorStyleCssPatch < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context={})
    return unless ["WikiController", "IssuesController"].include?(context[:controller].class.name)

    css_files = %w{editor_style_patch.css}

    css_files.map do |file|
      stylesheet_link_tag(file, :plugin=> 'redmine_evolvingweb_extensions')
    end
  end
end

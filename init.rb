require 'redmine'
#require 'lib/redmine/helpers/time_report'

Rails.configuration.to_prepare do
  # redirects homepage to /my/home
  require_dependency "welcome_controller_patch"
  require_dependency "timelog_helper_patch"
  require_dependency "evolvingweb_extensions/hooks/js_timelog_report_hooks"
  require_dependency "evolvingweb_extensions/hooks/js_issue_show_hooks"
  require_dependency "evolvingweb_extensions/hooks/css_hooks"
  require_dependency "editor_style_css_patch"
  require_dependency "timelog_controller_patch"
  require_dependency "query_model_patch"
  require_dependency "issue_import_patch"
  require_dependency "evolvingweb_extensions/changeset_link_creator"
  require_dependency "evolvingweb_extensions/issue_query_patch"
  require_dependency "evolvingweb_extensions/time_entry_query_patch"
  require_dependency "evolvingweb_extensions/time_report_helper_patch"
  require_dependency "query_custom_field_column_model_patch"
end

Redmine::Plugin.register :redmine_evolvingweb_extensions do
  name 'Redmine Evolving Web Extensions'
  author 'Alex Dergachev'
  url 'https://github.com/evolvingweb/redmine_evolvingweb_extensions'
  author_url 'http://evolvingweb.ca'
  description 'Contains misc extensions to our local Redmine instance'
  version '0.0.1'
  requires_redmine :version_or_higher => '0.8.0'


  Redmine::WikiFormatting::Macros.register do
    desc "Alias {{id(100)}} to {{issue_details(100)}}"
    macro :id do |obj, args|
      # return Redmine::WikiFormatting::Macros::Definitions.new.methods.inspect
      args = args.join(", ")
      return exec_macro('issue_details', obj, args, nil)
      return Redmine::WikiFormatting::Macros.available_macros.inspect
      return macro_exists?("issue_details")
    end
  end

  menu :top_menu, :my_timesheet, "/time_entries/report?utf8=✓&criteria[]=user&criteria[]=project&criteria[]=issue&f[]=spent_on&op[spent_on]=><t-&v[spent_on][]=7&f[]=&c[]=project&c[]=spent_on&c[]=user&c[]=activity&c[]=issue&c[]=comments&c[]=hours&columns=day"

end

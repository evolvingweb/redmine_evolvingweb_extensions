module TimelogControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      before_action :update_filters, :only => :report
    end
  end

  module InstanceMethods
    def update_filters
      if params.has_key?(:project_id)
        project_id = @project.id
        params.delete(:project_id)
        params[:f] = [] unless params.has_key?(:f)
        if (!params[:f].include?("project_id"))
          if (params[:f].length > 0)
            params[:f].insert(params[:f].length - 2, "project_id")
          else
            unless params.has_key?(:issue_id)
              params[:f] << "project_id"
            end
          end
          params[:op] = {} unless params.has_key?(:op)
          params[:op][:project_id] = "=*"

          params[:v] = {} unless params.has_key?(:v)
          params[:v][:project_id] = [project_id]
        end
        if params.has_key?(:issue_id)
          params[:f] << "issue_id"
          params[:op][:issue_id] = "~"
          params[:v][:issue_id] = [params[:issue_id][1..-1]]
          params[:criteria] = ["user"]
        elsif (!params[:f].include?("spent_on"))
          params[:f] << "spent_on"
          params[:op][:spent_on] = "m"
        end
      end
      if !params.has_key?(:criteria)
        params[:criteria] = ["project", "user", "issue"]
      end
      if !params.has_key?(:columns)
        params[:columns] = "week"
      end
    end
  end
end

module TimelogControllerReportPatch

  def report
    project_copy = @project
    @project = nil
    retrieve_time_entry_query
    scope = time_entry_scope

    @report = Redmine::Helpers::TimeReport.new(nil, @issue, params[:criteria], params[:columns], scope)

    respond_to do |format|
      format.html { render :layout => !request.xhr?, :locals => {:values => params[:v], :project => project_copy} }
      format.csv  { send_data(report_to_csv(@report), :type => 'text/csv; header=present', :filename => 'timelog.csv') }
    end
  end
end

# Add module to Welcome Controller
TimelogController.send(:include, TimelogControllerPatch)
TimelogController.prepend TimelogControllerReportPatch

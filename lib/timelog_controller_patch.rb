# redirects homepage to /my/home

module TimelogControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      before_filter :update_filters, :only => :report
    end
  end

  module InstanceMethods
    def update_filters
      if params.has_key?(:project_id)
        project_copy = @project
        project_id = @project.id
        params.delete(:project_id)
        params[:f] = [] unless params.has_key?(:f)
        spent_on_added = false
        @project = nil
        if (!params[:f].include?("project_id"))
          if (params[:f].length > 0)
            params[:f].insert(params[:f].length - 2, "project_id")
          else
            params[:f] << "project_id"
            params[:f] << "spent_on"
            params[:f] << ""
            spent_on_added = true
          end
          params[:op] = {} unless params.has_key?(:op)
          params[:op][:project_id] = "="
          if spent_on_added
            params[:op][:spent_on] = "m"
          end
          params[:v] = {} unless params.has_key?(:v)
          params[:v][:project_id] = [project_id]
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
end

# Add module to Welcome Controller
TimelogController.send(:include, TimelogControllerPatch)

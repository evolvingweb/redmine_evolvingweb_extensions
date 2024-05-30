
module EvolvingwebExtensions
    module TimeReportHelperPatch

      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method :load_available_criteria_without_ucf, :load_available_criteria
          alias_method :load_available_criteria, :load_available_criteria_with_ucf
        end
      end

      module InstanceMethods

        def load_available_criteria_with_ucf
          return @available_criteria if @available_criteria

          @available_criteria = load_available_criteria_without_ucf

          custom_fields = UserCustomField.visible

          custom_fields.select {|cf| %w(list bool).include?(cf.field_format) && !cf.multiple?}.each do |cf|
            @available_criteria["cf_#{cf.id}"] = {:sql => cf.group_statement,
                                                   :joins => cf.join_for_order_statement,
                                                   :format => cf.field_format,
                                                   :custom_field => cf,
                                                   :label => cf.name}
          end

          @available_criteria
        end
      end
    end

  # Add module to TimeReport helper
  Redmine::Helpers::TimeReport.send(:include, TimeReportHelperPatch)
  end

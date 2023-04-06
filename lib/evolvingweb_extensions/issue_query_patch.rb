
module EvolvingwebExtensions
  module IssueQueryPatch

    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method :available_columns_without_groupable_parent, :available_columns
        alias_method :available_columns, :available_columns_with_groupable_parent
      end
    end

    module InstanceMethods
      def available_columns_with_groupable_parent
        @available_columns = available_columns_without_groupable_parent
        @available_columns.each do |column|
          if column.name == :parent
            column.groupable = true
            column.sortable = "#{Issue.table_name}.parent_id, #{Issue.table_name}.lft"
          end
        end
        Rails.logger.debug("columns!")
        Rails.logger.debug(@available_columns)
        @available_columns
      end
    end
  end

  # Add module to IssueQuery Model
  IssueQuery.send(:include, IssueQueryPatch)
end


module EvolvingwebExtensions
  module TimeEntryQueryPatch

    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method :available_columns_without_ucf, :available_columns
        alias_method :available_columns, :available_columns_with_ucf
      end
    end

    module InstanceMethods
      def user_custom_fields
        UserCustomField.sorted
      end

      def available_columns_with_ucf
        return @available_columns if @available_columns

        @available_columns = available_columns_without_ucf

        @available_columns += user_custom_fields.visible.
                                map {|cf| QueryAssociationCustomFieldColumn.new(:user, cf)}

        @available_columns
      end
    end
  end

# Add module to TimeEntryQuery Model
  TimeEntryQuery.send(:include, TimeEntryQueryPatch)
end

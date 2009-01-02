module Extlib
  module Hook
    module ClassMethods

      alias_method :singular_before, :before
      alias_method :singular_after, :after

      def before(target_methods, filter_methods = nil, &block)
        insert_multiple_hooks "before", target_methods, filter_methods, &block
      end

      def after(target_methods, filter_methods = nil, &block)
        insert_multiple_hooks "after", target_methods, filter_methods, &block
      end

      private

      def insert_multiple_hooks(context, target_methods, filter_methods, &block)
        targets = [target_methods].flatten
        filters = [filter_methods].flatten

        targets.each do |target|
          filters.each do |filter|
            send("singular_#{context}", target.to_sym, filter.to_sym, &block)
          end
        end
      end

    end
  end
end

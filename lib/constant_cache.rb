module Viget
  module ConstantCache
    module ClassMethods
      def caches_constants(additional_options = {})
        options = {:key => :name, :limit => 64}.merge(additional_options)
        find(:all).each do |model| 
          const = model.send(options[:key].to_sym).constant_name
          unless const.blank?
            const = const[0, options[:limit]]
            const_set(const, model) if !const.blank? && !const_defined?(const)
          end
        end
      end
    end
  end
end
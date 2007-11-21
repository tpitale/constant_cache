module Viget
  module ConstantCache
    module ClassMethods
      def caches_constants(additional_options = {})
        options = {:key => :name, :limit => 64}.merge(additional_options)
        find(:all).each {|model| model.set_instance_as_constant(options) }
      end
    end
    
    module InstanceMethods
      
      def set_instance_as_constant(options)
        const = self.send(options[:key].to_sym).constant_name
        unless const.blank?
          const = const[0, options[:limit]]
          if !const.blank?
            raise RuntimeError, "Constant #{self.class.to_s}::#{const} has already been defined" if self.class.const_defined?(const)
            self.class.const_set(const, self) if !const.blank?
          end
        end
      end
      
    end
  end
end
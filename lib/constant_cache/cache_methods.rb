module ConstantCache
  
  class DuplicateConstantError < StandardError; end
  class InvalidLimitError < StandardError; end
  
  module CacheMethods

    module ClassMethods
      def caches_constants(additional_options = {})
        cattr_accessor :cache_options

        self.cache_options = {:key => :name, :limit => 64}.merge(additional_options)
        
        raise ConstantCache::InvalidLimitError, "Limit of #{self.cache_options[:limit]} is invalid" if self.cache_options[:limit] < 1        
        find(:all).each {|model| model.set_instance_as_constant }
      end
    end

    module InstanceMethods

      def constant_name
        constant_name = self.send(self.class.cache_options[:key].to_sym).constant_name
        constant_name = constant_name[0, self.class.cache_options[:limit]] unless constant_name.blank?
        constant_name
      end

      def set_instance_as_constant
        const = constant_name
        if !const.blank?
          raise ConstantCache::DuplicateConstantError, "Constant #{self.class.to_s}::#{const} has already been defined" if self.class.const_defined?(const)
          self.class.const_set(const, self) if !const.blank?
        end
      end

      # TODO: do we want this behavior?
      # def constant_cache_destroy
      #   constant_name = constant_name()
      #   self.class.send(:remove_const, constant_name) if self.class.const_defined?(constant_name)
      # end

    end
    
  end
end
module ConstantCache

  CHARACTER_LIMIT = 64
  
  # 
  # Generated constant conflicts with an existing constant
  #
  class DuplicateConstantError < StandardError; end
  class InvalidLimitError < StandardError #:nodoc:
  end
  
  module CacheMethods #:nodoc:

    module ClassMethods
      
      #
      # The caches_constants method is the core of the functionality behind this mix-in.  It provides
      # a simple interface to cache the data in the corresponding table as constants on the model:
      #
      #   class Status
      #     caches_constants
      #   end
      # 
      # It makes certain assumptions about your schema: the constant created is based off of a <tt>name</tt>
      # column in the database and long names are truncated to ConstantCache::CHARACTER_LIMIT characters before 
      # being set as constants. If there is a 'Pending' status in the database, you will now have a 
      # Status::PENDING constant that points to an instance of ActiveRecord.
      #
      # Beyond the basics, some configuration is allowed. You can change both the column that is used to generate
      # the constant and the truncation length:
      #
      #   class State
      #     caches_constants :key => :abbreviation, :limit => 2
      #   end
      #
      # This will use the <tt>abbreviation</tt> column to generate constants and will truncate constant names to 2 
      # characters at the maximum.
      #
      # Note: In the event that a generated constant conflicts with an existing constant, a 
      # ConstantCache::DuplicateConstantError is raised.
      #
      def caches_constants(additional_options = {})
        cattr_accessor :cache_options

        self.cache_options = {:key => :name, :limit => ConstantCache::CHARACTER_LIMIT}.merge(additional_options)
        
        raise ConstantCache::InvalidLimitError, "Limit of #{self.cache_options[:limit]} is invalid" if self.cache_options[:limit] < 1        
        find(:all).each {|model| model.set_instance_as_constant }
      end
    end

    module InstanceMethods

      def constant_name #:nodoc:
        constant_name = self.send(self.class.cache_options[:key].to_sym).constant_name
        constant_name = constant_name[0, self.class.cache_options[:limit]] unless constant_name.blank?
        constant_name
      end
      private :constant_name

      # 
      # Create a constant on the class that pointing to an instance
      #
      def set_instance_as_constant
        const = constant_name
        if !const.blank?
          if self.class.const_defined?(const)
            message = "Constant #{self.class.to_s}::#{const} has already been defined"
            raise ConstantCache::DuplicateConstantError, message
          end
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
module ConstantCache

  CHARACTER_LIMIT = 64

  def self.included(model)
    model.extend(ClassMethods)
    (@descendants ||= []) << model
  end

  def self.cache!
    @descendants.each {|klass| klass.all.each {|instance| instance.set_instance_as_constant }}
  end

  #
  # Error raised when duplicate constant defined
  #
  class DuplicateConstantError < StandardError; end

  module ClassMethods
    #
    # The caches_constants method is the core of the functionality behind this mix-in.  It provides
    # a simple interface to cache the data in the corresponding table as constants on the model:
    #
    #   class Status
    #     include ConstantCache
    #   end
    # 
    # It makes certain assumptions about your schema: the constant created is based off of a <tt>name</tt>
    # column in the database and long names are truncated to ConstantCache::CHARACTER_LIMIT characters before 
    # being set as constants. If there is a 'Pending' status in the database, you will now have a 
    # Status::PENDING constant that points to an instance of ActiveRecord or DataMapper::Resource.
    #
    # Beyond the basics, some configuration is allowed. You can change both the column that is used to generate
    # the constant and the truncation length:
    #
    #   class State
    #     include ConstantCache
    # 
    #     cache_as :abbreviation
    #     cache_limit 2
    #   end
    #
    # This will use the <tt>abbreviation</tt> column to generate constants and will truncate constant names to 2 
    # characters at the maximum.
    #
    # Note: In the event that a generated constant conflicts with an existing constant, a 
    # ConstantCache::DuplicateConstantError is raised.

    def cache_as(key)
      self.cache_options[:key] = key
    end

    def cache_limit(limit)
      self.cache_options[:limit] = (limit > 0 ? limit : CHARACTER_LIMIT)
    end

    def cache_options
      @cache_options ||= {:key => :name, :limit => CHARACTER_LIMIT}
    end

    def reset_cache_options
      @cache_options = {:key => :name, :limit => CHARACTER_LIMIT}
    end
  end

  # 
  # Create a constant on the class that pointing to an instance
  #
  def set_instance_as_constant
    unless constant_name.nil? || self.class.const_defined?(constant_name)
      self.class.const_set(constant_name, self)
    end
  end

  def constant_name #:nodoc:
    name = self.send(self.class.cache_options[:key].to_sym)
    if name.is_a?(String) && name != ''
      @constant_name ||= name.constant_name[0,self.class.cache_options[:limit]]
    end
  end
  private :constant_name
end

require 'constant_cache/core_ext'
require 'constant_cache/cache_methods'

ActiveRecord::Base.send(:extend, ConstantCache::CacheMethods::ClassMethods)
ActiveRecord::Base.send(:include, ConstantCache::CacheMethods::InstanceMethods)
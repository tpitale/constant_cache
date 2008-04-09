require 'constant_cache/format'
require 'constant_cache/cache_methods'

String.send(:include, ConstantCache::Format)
ActiveRecord::Base.send(:extend, ConstantCache::CacheMethods::ClassMethods)
ActiveRecord::Base.send(:include, ConstantCache::CacheMethods::InstanceMethods)
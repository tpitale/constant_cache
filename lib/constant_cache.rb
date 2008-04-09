lib_dir = File.dirname(__FILE__) + '/constant_cache'

require "#{lib_dir}/format"
require "#{lib_dir}/constant_cache"

String.send(:include, Viget::Format)
ActiveRecord::Base.send(:extend, Viget::ConstantCache::ClassMethods)
ActiveRecord::Base.send(:include, Viget::ConstantCache::InstanceMethods)

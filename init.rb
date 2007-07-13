lib_dir = File.dirname(__FILE__) + '/lib'

require "#{lib_dir}/format"
require "#{lib_dir}/constant_cache"

String.send(:include, Viget::Format)
ActiveRecord::Base.send(:extend, Viget::ConstantCache::ClassMethods)

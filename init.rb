require 'format'
require 'constant_cache'

ActiveRecord::Base.send(:extend, Viget::ConstantCache::ClassMethods)

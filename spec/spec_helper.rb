require 'rubygems'
require 'spec'
require 'mocha'

require 'activesupport'
require 'activerecord'



lib_dir = File.join(File.dirname(__FILE__), %w(.. lib constant_cache))

Dir.glob("#{lib_dir}/*.rb").each {|file| require file }

module ConstantCache
  module SpecHelper
    
    def enable_caching(klass, values = [], additional_options = {})
      return_values = values.empty? ? [] : values.map {|params| klass.new(params) }

      klass.expects(:find).with(:all).returns(return_values)
      klass.caches_constants(additional_options)
    end
    
  end
end

Spec::Runner.configuration.mock_with :mocha
Spec::Runner.configuration.include ConstantCache::SpecHelper

String.send(:include, ConstantCache::Format)
ActiveRecord::Base.send(:include, ConstantCache::CacheMethods::InstanceMethods)
ActiveRecord::Base.send(:extend, ConstantCache::CacheMethods::ClassMethods)

class BaseClass < ActiveRecord::Base
  def self.columns; []; end
end

class SimpleClass < BaseClass
  PREDEFINED = 'foo'
  attr_accessor :name, :value
end

class AlternateClass < BaseClass; 
  attr_accessor :name2, :value
end

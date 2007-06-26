lib_dir = File.dirname(__FILE__) + '/lib'
require File.dirname(__FILE__) + '/../../../config/boot'
require 'rubygems'
require 'test/unit'
require 'mocha'
require 'active_record'
require "#{lib_dir}/viget/format"
require "#{lib_dir}/caches_constants"
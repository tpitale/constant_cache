require 'rubygems'
require 'rake/gempackagetask'

GEM = "constant_cache"
VERSION = "0.0.1"
AUTHOR = "Patrick Reagan"
EMAIL = "patrick.reagan@viget.com"
HOMEPAGE = "http://www.viget.com/extend/"
SUMMARY = "Patches active record to add a caches_constants class method that will cache lookup data for your application."

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README MIT-LICENSE)
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  s.add_dependency "activerecord"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(MIT-LICENSE README Rakefile) + Dir.glob("{lib,specs}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{VERSION}}
end
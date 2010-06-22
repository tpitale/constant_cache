require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/constant_cache/version'

spec = Gem::Specification.new do |s|
  s.name             = "dm-constant-cache"
  s.version          = ConstantCache::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.md)
  s.summary          = ""
  s.authors          = ["Tony Pitale", "Patrick Reagan"]
  s.email            = "tony.pitale@viget.com"
  s.homepage         = "http://www.viget.com/extend/"
  s.files = %w(MIT-LICENSE README.md Rakefile) + Dir.glob("{lib,test}/**/*")

  # s.add_dependency('gem', '~> version')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc 'Generate the gemspec to serve this Gem from Github'
task :github do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

begin
  require 'rcov/rcovtask'

  desc "Generate RCov coverage report"
  Rcov::RcovTask.new(:rcov) do |t|
    t.test_files = FileList['test/**/*_test.rb']
    t.rcov_opts << "-x lib/constant_cache.rb -x lib/constant_cache/version.rb"
  end
rescue LoadError
  nil
end

task :default => :test
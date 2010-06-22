require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name              = "dm-constant-cache"
    gem.summary           = ""
    gem.description       = ""
    gem.authors           = ["Tony Pitale", "Patrick Reagan"]
    gem.email             = "tony.pitale@viget.com"
    gem.homepage          = "http://www.viget.com/extend/"
    gem.files = %w(MIT-LICENSE README.md Rakefile) + Dir.glob("{lib,test}/**/*")

    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.test_files = FileList["test/**/*_test.rb"]
  test.verbose = true
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

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "constant_cache #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

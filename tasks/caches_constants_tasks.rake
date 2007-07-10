desc "Run unit tests for caches_constants plugin"
namespace :caches_constants do
  task :test do
    test_dir = File.dirname(__FILE__) + '/../test'
    Dir.glob("#{test_dir}/*_test.rb").each {|file| require file }
  end
end

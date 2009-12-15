# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{constant_cache}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Reagan", "Tony Pitale"]
  s.date = %q{2009-12-15}
  s.email = %q{patrick.reagan@viget.com}
  s.extra_rdoc_files = ["README.md"]
  s.files = ["MIT-LICENSE", "README.md", "Rakefile", "lib/constant_cache", "lib/constant_cache/cache_methods.rb", "lib/constant_cache/core_ext.rb", "lib/constant_cache/version.rb", "lib/constant_cache.rb", "test/constant_cache", "test/constant_cache/cache_methods_test.rb", "test/constant_cache/core_ext_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://www.viget.com/extend/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

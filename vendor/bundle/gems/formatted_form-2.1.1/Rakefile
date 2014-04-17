begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "formatted_form"
    gem.homepage    = "http://github.com/twg/formatted_form"
    gem.license     = "MIT"
    gem.summary     = "A Rails form builder that generates Twitter Bootstrap markup and helps keep your code clean"
    gem.description = ''
    gem.email       = "jack@twg.ca"
    gem.authors     = ["Jack Neto", 'Oleg Khabarov', 'The Working Group Inc.']
  end
  Jeweler::RubygemsDotOrgTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end
task :default => :test
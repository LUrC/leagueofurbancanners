# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'formatted_form/version'

Gem::Specification.new do |s|
  s.name        = "formatted_form"
  s.version     = FormattedForm::VERSION
  s.authors     = ["Jack Neto", "Oleg Khabarov", "The Working Group Inc."]
  s.email       = ["jack@twg.ca"]
  s.homepage    = "http://github.com/twg/formatted_form"
  s.summary     = "Rails form helper the generates Bootstrap 2 markup"
  s.description = "Rails form helper the generates Bootstrap 2 markup"
  s.license     = "MIT"
  
  s.files         = `git ls-files`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  
  s.add_dependency 'rails', '>= 3.1'
end


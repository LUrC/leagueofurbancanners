# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "formatted_form"
  s.version = "2.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jack Neto", "Oleg Khabarov", "The Working Group Inc."]
  s.date = "2013-10-25"
  s.description = "Rails form helper the generates Bootstrap 2 markup"
  s.email = ["jack@twg.ca"]
  s.homepage = "http://github.com/twg/formatted_form"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Rails form helper the generates Bootstrap 2 markup"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.1"])
    else
      s.add_dependency(%q<rails>, [">= 3.1"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.1"])
  end
end

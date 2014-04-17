# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "comfortable_mexican_sofa"
  s.version = "1.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oleg Khabarov", "The Working Group Inc"]
  s.date = "2013-04-24"
  s.description = "ComfortableMexicanSofa is a powerful CMS Engine for Ruby on Rails 3 applications"
  s.email = ["oleg@khabarov.ca"]
  s.homepage = "http://github.com/comfy/comfortable-mexican-sofa"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "CMS Engine for Rails 3 apps"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.1.0"])
      s.add_runtime_dependency(%q<formatted_form>, [">= 2.1.0"])
      s.add_runtime_dependency(%q<active_link_to>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<paperclip>, [">= 3.4.0"])
      s.add_runtime_dependency(%q<redcarpet>, [">= 2.2.0"])
      s.add_runtime_dependency(%q<jquery-rails>, [">= 2.2.0"])
      s.add_runtime_dependency(%q<haml-rails>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<sass-rails>, [">= 3.1.0"])
      s.add_runtime_dependency(%q<coffee-rails>, [">= 3.1.0"])
    else
      s.add_dependency(%q<rails>, [">= 3.1.0"])
      s.add_dependency(%q<formatted_form>, [">= 2.1.0"])
      s.add_dependency(%q<active_link_to>, [">= 1.0.0"])
      s.add_dependency(%q<paperclip>, [">= 3.4.0"])
      s.add_dependency(%q<redcarpet>, [">= 2.2.0"])
      s.add_dependency(%q<jquery-rails>, [">= 2.2.0"])
      s.add_dependency(%q<haml-rails>, [">= 0.3.0"])
      s.add_dependency(%q<sass-rails>, [">= 3.1.0"])
      s.add_dependency(%q<coffee-rails>, [">= 3.1.0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.1.0"])
    s.add_dependency(%q<formatted_form>, [">= 2.1.0"])
    s.add_dependency(%q<active_link_to>, [">= 1.0.0"])
    s.add_dependency(%q<paperclip>, [">= 3.4.0"])
    s.add_dependency(%q<redcarpet>, [">= 2.2.0"])
    s.add_dependency(%q<jquery-rails>, [">= 2.2.0"])
    s.add_dependency(%q<haml-rails>, [">= 0.3.0"])
    s.add_dependency(%q<sass-rails>, [">= 3.1.0"])
    s.add_dependency(%q<coffee-rails>, [">= 3.1.0"])
  end
end

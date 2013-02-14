# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'devise_trialable/version'

Gem::Specification.new do |s|
  s.name         = "devise_trialable"
  s.version      = DeviseTrialable::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Timothy Little"]
  s.email        = ["timothy@ikayzo.com"]
  s.homepage     = "https://github.com/ikayzo/devise_trialable"
  s.summary      = "A trial period strategy for Devise"
  s.description  = "It allows setting a trial period to allow access to site until enrolled with billing information"
  s.files        = Dir["{config,lib}/**/*"] + %w[LICENSE README.rdoc]
  s.require_path = "lib"
  s.rdoc_options = ["--main", "README.rdoc", "--charset=UTF-8"]

  s.required_ruby_version     = '>= 1.8.6'
  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency('bundler', '>= 1.1.0')

  {
    'railties' => '~> 3.0',
    'actionmailer' => '~> 3.0',
    'devise'   => '>= 1.5.4'
  }.each do |lib, version|
    s.add_runtime_dependency(lib, *version)
  end

end

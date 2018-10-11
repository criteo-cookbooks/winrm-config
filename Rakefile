#!/usr/bin/env rake
require 'rspec/core/rake_task'
require 'foodcritic'

FoodCritic::Rake::LintTask.new do |fc|
  # TODO: update following lines once we remove Chef 12 support
  fc.options[:chef_version] = '12.1'
  fc.options[:tags] = %w(~FC113)
end
RSpec::Core::RakeTask.new(:rspec)

task default: [:foodcritic, :rspec]

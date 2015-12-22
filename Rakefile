require 'bundler'
Bundler.require

require 'opal/minitest/rake_task'
# Opal::Minitest::RakeTask.new

task :test do
  sh "bundle exec ruby -r opal/minitest -S opal -Dwarning -Itest -Iopal test/**/*_test.rb"
end

task default: :test

require 'bundler/gem_tasks'

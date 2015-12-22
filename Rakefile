require 'bundler'
Bundler.require

require 'opal/minitest/rake_task'
# Opal::Minitest::RakeTask.new

task :test do
  files = Dir['test/**/*_test.rb'].map {|f| "-r #{f.chomp('.rb').sub(/^test\//, '')}"}
  sh "bundle exec ruby -r opal/minitest -S opal -Dwarning -Itest -Iopal #{files.join(' ')} -e puts"
end

task default: :test

require 'bundler/gem_tasks'

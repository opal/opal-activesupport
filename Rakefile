require 'bundler'
Bundler.require
require 'bundler/gem_tasks'


task :test do
  require 'opal'
  require 'opal/cli_runners'
  require 'opal/minitest'

  Opal::Config.arity_check_enabled = true
  Opal::Config.dynamic_require_severity = :warning

  Opal.append_path 'opal'
  Opal.append_path 'test'

  builder = Opal::Builder.new
  builder.build 'opal'
  builder.build 'opal/platform'
  builder.build 'minitest'
  Dir['test/**/*_test.rb'].map do |file|
    builder.build file.sub(%r{^test/}, '')
  end
  builder.build_str 'Minitest.run', 'minitest-runner.rb'

  runner_name = ENV['RUNNER'] || 'nodejs'
  runner_class = Opal::CliRunners.const_get(runner_name.capitalize)
  runner_class.new(output: $stdout).run(builder.to_s, [])
end

task default: :test

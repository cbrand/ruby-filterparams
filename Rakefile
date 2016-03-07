begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:rspec)

  if ENV['GENERATE_REPORTS'] == 'true'
    require 'ci/reporter/rake/rspec'
    task :rspec => 'ci:setup:rspec'
  end
rescue
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns = ['lib/**/*.rb']
    task.fail_on_error = false
  end
rescue
end

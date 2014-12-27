def rake_task(name, argument_hash)
  Rake::Task[name].execute Rake::TaskArguments.new(argument_hash.keys, argument_hash.values)
end

def release_info(environment = :development)
  status = `divshot status #{environment}`
  releases = status.scan /^\s*release #\s+(\d+).*?^\s*build id\s+(\S+)/m
  release_number, hash = releases.last
  return {environment: environment, number: release_number, hash: hash}
end

def git_tag(environment)
  release = release_info environment
  "divshot-#{release[:environment]}-v#{release[:number]}-#{release[:hash]}"
end

desc 'Build site into /build directory'
task :build do
  sh *%w(middleman build --clean)
end

desc 'Build and deploy to Divshot'
task deploy: :'deploy:all'

task :tag, [:environment, :ref] do |_, args|
  args.with_defaults ref: 'head'
  sh 'git', 'tag', git_tag(args[:environment]), args[:ref]
end

namespace :deploy do
  task all: [:build, :push] do
    rake_task :tag, environment: 'development'
  end

  task :push do
    sh *%w(divshot push development)
  end
end

namespace :promote do
  desc 'Promote current development version to staging'
  task :staging do
    sh *%w(divshot promote development staging)
    rake_task :tag, environment: 'staging', ref: git_tag(:development)
  end
end

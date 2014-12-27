def release_info(environment = :development)
  status = `divshot status #{environment}`
  releases = status.scan /^\s*release #\s+(\d+).*?^\s*build id\s+(\S+)/m
  release_number, hash = releases.last
  return {environment: environment, number: release_number, hash: hash}
end

def tag(release_info)
  "divshot-#{release_info[:environment]}-v#{release_info[:number]}-#{release_info[:hash]}"
end

desc 'Build site into /build directory'
task :build do
  sh 'middleman', 'build', '--clean'
end

desc 'Build and deploy to Divshot'
task deploy: :'deploy:all'

task :tag, [:environment, :ref] do |_, args|

  sh 'git', 'tag', tag(release_info args[:environment]), args[:ref]
end

namespace :deploy do
  task all: [:build, :push, :'tag[development]']

  task :push do
    sh *%w(divshot push development)
  end
end

namespace :promote do
  desc 'Promote current development version to staging'
  task :staging do
    development_tag = tag(release_info :development)
    sh *%w(divshot promote development staging)
    Rake::Task[:tag].execute Rake::TaskArguments.new([:environment, :ref], ['staging', development_tag])
  end
end

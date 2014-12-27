desc 'Build site into /build directory'
task :build do
  sh 'middleman', 'build', '--clean'
end

desc 'Build and deploy to Divshot'
task deploy: :'deploy:all'

task :tag, [:environment] do |_, args|
  environment = args[:environment]
  status = `divshot status #{environment}`
  releases = status.scan /^\s*release #\s+(\d+).*?^\s*build id\s+(\S+)/m
  release_number, hash = releases.last
  sh 'git', 'tag', "divshot-#{environment}-v#{release_number}-#{hash}"
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
    sh *%w(divshot promote development staging)
    Rake::Task[:tag].execute 'staging'
  end
end

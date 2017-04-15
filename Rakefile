require 'json'

def rake_task(name, argument_hash)
  Rake::Task[name].execute Rake::TaskArguments.new(argument_hash.keys, argument_hash.values)
end

def git_tag
  hosting_key = @deploy_status['result']['hosting']
  "firebase-#{hosting_key}"
end

def promote(from: :development, to: :staging)
  sh 'firebase', 'promote', from.to_s, to.to_s
  rake_task :tag, environment: to, ref: git_tag(from)
end

desc 'Build site into /build directory'
task :build do
  sh *%w(middleman build --clean)
end

desc 'Build and deploy to Firebase'
task deploy: :'deploy:all'

task :tag, [:environment, :ref] do |_, args|
  args.with_defaults ref: 'head'
  sh 'git', 'tag', git_tag, args[:ref]
end

namespace :deploy do
  task all: [:build, :push] do
    rake_task :tag, environment: 'development'
  end

  task :push do
    git_commit = `git rev-parse HEAD`.strip
    deploy_output = `firebase deploy --only hosting -j -m 'Git commit #{git_commit}'`
    deploy_output.sub! %r(\A[^{]*), ''
    @deploy_status = JSON.parse deploy_output
    warn "Deploy status:"
    warn @deploy_status.inspect
  end
end

namespace :promote do
  desc 'Promote current development version to staging'
  task :staging do
    promote from: :development, to: :staging
  end

  desc 'Promote current staging version to production'
  task :production do
    promote from: :staging, to: :production
  end
end

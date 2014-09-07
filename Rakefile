desc 'Build site into /build directory'
task :build do
  sh 'middleman', 'build', '--clean'
end

desc 'Build and deploy to Divshot'
task :deploy => :build do
  sh 'divshot', 'push', 'development'
  status = `divshot status development`
  releases = status.scan /^\s*release #\s+(\d+).*?^\s*build id\s+(\S+)/m
  release_number, hash = releases.last
  sh 'git', 'tag', "divshot-development-v#{release_number}-#{hash}"
end
load "vendor/ceedling/lib/rakefile.rb"

task :default => "build:release"

desc "run hello"
task :run => "build:release" do
  sh "build/artifacts/release/hello"
end

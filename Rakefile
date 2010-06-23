load "vendor/ceedling/lib/rakefile.rb"

task :default => :run

desc "run hello"
task :run => "build:release" do
  sh "build/artifacts/release/mch_gui"
end

desc "build it"
task :build => "build:release"

namespace :proto do
  def gtk_cflags
    `pkg-config --cflags --libs gtk+-2.0`.strip
  end

  desc "run proto"
  task :run do
    sh "gcc #{gtk_cflags} proto/hello.c -o proto/hello"
    sh "proto/hello"
  end

  desc "clean proto"
  task :clean do
    sh "rm -f proto/hello"
  end
end

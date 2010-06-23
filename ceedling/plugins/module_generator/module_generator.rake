
namespace :module do

  desc "Generate module (source, header and test files)"
  task :create, :module_path do |t, args|
    @ceedling[:module_generator].create(args[:module_path])
  end

  desc "Destroy module (source, header and test files)"
  task :destroy, :module_path do |t, args|
    @ceedling[:module_generator].create(args[:module_path], {:destroy => true})
  end
  
  desc "Add new method to module"
  task :add_function, :module_path, :declaration do |t, args|
    @ceedling[:module_generator].add_function(args[:module_path], {:declaration => args[:declaration]})
  end

end

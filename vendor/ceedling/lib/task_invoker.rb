
class TaskInvoker

  constructor :configurator, :rake_wrapper


  def invoke_mocks(mocks)
    invoke_with_enhancements(mocks)
  end
  
  def invoke_runners(runners)
    invoke_with_enhancements(runners)
  end

  def invoke_shallow_include_lists(files)
    invoke_with_enhancements(files)    
  end

  def invoke_preprocessed_files(files)
    invoke_with_enhancements(files)
  end

  def invoke_dependencies_files(files)
    invoke_with_enhancements(files)
  end

  def invoke_results(results)
    # since everything needed to create results will have been regenerated
    # appropriately, there's no needed to enhance the dependencies -
    # they will always be superfluous
    results.each do |result|
      @rake_wrapper[result].invoke
    end
  end


  private #############################
  
  def invoke_with_enhancements(tasks)
    tasks.each do |task|
      @rake_wrapper[task].enhance(@configurator.collection_environment_dependencies)
      @rake_wrapper[task].invoke
    end
  end
  
end

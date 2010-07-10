
class Dependinator

  constructor :configurator, :test_includes_extractor, :file_finder, :file_path_utils, :rake_wrapper


  def setup_object_dependencies(*files_lists)
    files_lists.each do |files_list|
      dependencies_list = @file_path_utils.form_test_dependencies_filelist(files_list)
      dependencies_list.each do |dependencies_file|
        @rake_wrapper.load_dependencies(dependencies_file)
      end
    end
  end


  def enhance_object_with_environment_dependencies(sources)
    sources.each do |source|
      @rake_wrapper[@file_path_utils.form_test_build_object_filepath(source)].enhance(@configurator.collection_environment_dependencies)
    end
  end
  

  def setup_executable_dependencies(test)
    dependencies = []
    headers = @test_includes_extractor.lookup_includes_list(test)
    sources = @file_finder.find_source_files_from_headers(headers)
    
    dependencies = @file_path_utils.form_test_build_objects_filelist(sources + @configurator.test_fixture_link_objects)
    dependencies.include( @file_path_utils.form_runner_object_filepath_from_test(test) )
    dependencies.include( @file_path_utils.form_test_build_object_filepath(test) )
    
    dependencies.uniq!

    @rake_wrapper.create_file_task(@file_path_utils.form_test_executable_filepath(test), dependencies)
  end

end

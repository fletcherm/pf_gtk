require 'rubygems'
require 'rake'            # for ext() method
require 'file_path_utils' # for form_vendor_path() class method
require 'constants'       # for Verbosity constants class



class ConfiguratorBuilder
  
  constructor :project_file_loader, :file_system_utils, :file_wrapper
    
  
  def build_global_constants(config)
    config.each_pair do |key, value|
      formatted_key = key.to_s.upcase
      # undefine global constant if it already exists
      Object.send(:remove_const, formatted_key.to_sym) if Object.constants.include?(formatted_key)
      # create global constant
      Object.module_eval("#{formatted_key} = value")
    end
  end

  
  def build_accessor_methods(config, context)
    config.each_pair do |key, value|
      # fill configurator object with accessor methods
      eval("def #{key.to_s.downcase}() return @project_config_hash[:#{key.to_s}] end", context)
    end
  end

  
  # create a flattened hash from the original configuration structure
  def flattenify(config)
    new_hash = {}
    
    config.each_key do | parent |

      # gracefully handle empty top-level entries
      next if (config[parent].nil?)

      case config[parent]
      when Array
        config[parent].each do |hash|
          key = "#{parent.to_s.downcase}_#{hash.keys[0].to_s.downcase}".to_sym
          new_hash[key] = hash[hash.keys[0]]
        end
      when Hash
        config[parent].each_pair do | child, value |
          key = "#{parent.to_s.downcase}_#{child.to_s.downcase}".to_sym
          new_hash[key] = value
        end
      # handle entries with no children, only values
      else
        new_hash["#{parent.to_s.downcase}".to_sym] = config[parent]
      end
      
    end
    
    return new_hash
  end

  
  def populate_default_test_tools(config, new_config)
    new_config[:tools][:test_compiler] = DEFAULT_TEST_COMPILER_TOOL if (config[:tools].nil? or config[:tools][:test_compiler].nil?)
    new_config[:tools][:test_linker]   = DEFAULT_TEST_LINKER_TOOL   if (config[:tools].nil? or config[:tools][:test_linker].nil?)
    new_config[:tools][:test_fixture]  = DEFAULT_TEST_FIXTURE_TOOL  if (config[:tools].nil? or config[:tools][:test_fixture].nil?)
  end
  
  
  def populate_default_test_helper_tools(config, new_config)
    use_test_preprocessor = (( config[:project].nil? or config[:project][:use_test_preprocessor].nil? or (config[:project][:use_test_preprocessor] == false) ) ? false : true )
    use_aux_dependencies  = (( config[:project].nil? or config[:project][:use_auxiliary_dependencies].nil? or (config[:project][:use_auxiliary_dependencies] == false) ) ? false : true )
    
    new_config[:tools][:test_includes_preprocessor]  = DEFAULT_TEST_INCLUDES_PREPROCESSOR_TOOL   if (use_test_preprocessor and (config[:tools].nil? or config[:tools][:test_includes_preprocessor].nil?))
    new_config[:tools][:test_file_preprocessor]      = DEFAULT_TEST_FILE_PREPROCESSOR_TOOL       if (use_test_preprocessor and (config[:tools].nil? or config[:tools][:test_file_preprocessor].nil?))
    new_config[:tools][:test_dependencies_generator] = DEFAULT_TEST_DEPENDENCIES_GENERATOR_TOOL  if (use_aux_dependencies and (config[:tools].nil? or config[:tools][:test_dependencies_generator].nil?))
  end


  def populate_default_release_tools(config, new_config)
    release_build         = (( config[:project].nil? or config[:project][:release_build].nil? or (config[:project][:release_build] == false) ) ? false : true )
    use_aux_dependencies  = (( config[:project].nil? or config[:project][:use_auxiliary_dependencies].nil? or (config[:project][:use_auxiliary_dependencies] == false) ) ? false : true )
    use_assembly          = (( config[:release_build].nil? or config[:release_build][:use_assembly].nil? or (config[:release_build][:use_assembly] == false) ) ? false : true )
        
    new_config[:tools][:release_compiler]               = DEFAULT_RELEASE_COMPILER_TOOL                if (release_build and (config[:tools].nil? or config[:tools][:release_compiler].nil?))
    new_config[:tools][:release_assembler]              = DEFAULT_RELEASE_ASSEMBLER_TOOL               if (release_build and use_assembly and (config[:tools].nil? or config[:tools][:release_assembler].nil?))
    new_config[:tools][:release_linker]                 = DEFAULT_RELEASE_LINKER_TOOL                  if (release_build and (config[:tools].nil? or config[:tools][:release_linker].nil?))
    new_config[:tools][:release_dependencies_generator] = DEFAULT_RELEASE_DEPENDENCIES_GENERATOR_TOOL  if (release_build and use_aux_dependencies and (config[:tools].nil? or config[:tools][:release_dependencies_generator].nil?))
  end
  
  
  def clean(in_hash)
    # ensure that include files inserted into test runners have file extensions & proper ones at that
    in_hash[:test_runner_includes].map!{|include| include.ext(in_hash[:extension_header])}
  end


  def set_build_paths(in_hash)
    test_path    = 'tests'
    release_path = 'release'

    build_paths = []
    out_hash = {}

    project_build_artifacts_root = File.join(in_hash[:project_build_root], 'artifacts')
    project_build_tests_root     = File.join(in_hash[:project_build_root], test_path)
    project_build_release_root   = File.join(in_hash[:project_build_root], release_path) if in_hash[:project_release_build]
    
    out_hash[:project_build_artifacts_root] = project_build_artifacts_root
    out_hash[:project_build_tests_root]     = project_build_tests_root
    out_hash[:project_build_release_root]   = project_build_release_root if in_hash[:project_release_build]

    if (in_hash[:project_release_build])
      out_hash[:project_release_artifacts_path]        = File.join(project_build_artifacts_root, release_path)
      out_hash[:project_release_build_output_path]     = File.join(project_build_release_root, 'out')
      out_hash[:project_release_build_output_asm_path] = File.join(project_build_release_root, 'out', 'asm')
      out_hash[:project_release_build_output_c_path]   = File.join(project_build_release_root, 'out', 'c')
      out_hash[:project_release_dependencies_path]     = File.join(project_build_release_root, 'dependencies') if in_hash[:project_use_auxiliary_dependencies]
    end
    
    out_hash[:project_test_artifacts_path]    = File.join(project_build_artifacts_root, test_path)
    out_hash[:project_test_runners_path]      = File.join(project_build_tests_root, 'runners')
    out_hash[:project_test_results_path]      = File.join(project_build_tests_root, 'results')
    out_hash[:project_test_build_output_path] = File.join(project_build_tests_root, 'out')
    out_hash[:project_log_path]               = File.join(in_hash[:project_build_root], 'logs')
    
    out_hash[:project_temp_path] = File.join(in_hash[:project_build_root], 'temp') if in_hash[:project_use_test_preprocessor]

    out_hash[:project_test_preprocess_includes_path] = File.join(project_build_tests_root, 'preprocess/includes') if in_hash[:project_use_test_preprocessor]
    out_hash[:project_test_preprocess_files_path]    = File.join(project_build_tests_root, 'preprocess/files')    if in_hash[:project_use_test_preprocessor]

    out_hash[:project_test_dependencies_path] = File.join(project_build_tests_root, 'dependencies') if in_hash[:project_use_auxiliary_dependencies]

    # fetch already set mock path
    build_paths << in_hash[:cmock_mock_path] if in_hash[:project_use_mocks]
    
    out_hash.each_pair do |key, value|
      build_paths << out_hash[key]
    end

    out_hash[:project_build_paths] = build_paths

    return out_hash
  end


  def set_log_filepath(in_hash)
    return {} if (not in_hash[:project_logging])

    log_name = File.basename(@project_file_loader.main_project_filepath).ext('')
    
    if (not @project_file_loader.user_project_filepath.empty?)
      log_name += "_#{File.basename(@project_file_loader.user_project_filepath).ext('')}"
    end
    
    if (not @project_file_loader.project_options_filepath.empty?)
      log_name += "_#{File.basename(@project_file_loader.project_options_filepath).ext('')}"
    end

    return {
      # tempted to make a helper method in file_path_utils? stop right there, pal. you'll introduce a cyclical dependency
      :project_log_filepath => File.join( in_hash[:project_log_path], log_name.ext('.log') )
      }
  end


  def set_rakefile_components(in_hash)
    out_hash = {
      :project_rakefile_component_files => 
        [File.join(CEEDLING_LIB, 'tasks_base.rake'),
         File.join(CEEDLING_LIB, 'tasks_filesystem.rake'),
         File.join(CEEDLING_LIB, 'tasks_tests.rake'),
         File.join(CEEDLING_LIB, 'rules_tests.rake')]}

    out_hash[:project_rakefile_component_files] << File.join(CEEDLING_LIB, 'rules_cmock.rake') if (in_hash[:project_use_mocks])
    out_hash[:project_rakefile_component_files] << File.join(CEEDLING_LIB, 'rules_preprocess.rake') if (in_hash[:project_use_test_preprocessor])
    out_hash[:project_rakefile_component_files] << File.join(CEEDLING_LIB, 'rules_tests_aux_dependencies.rake') if (in_hash[:project_use_auxiliary_dependencies])

    # order is important because of how rake processes and collapses the tasks & rules defined within
    out_hash[:project_rakefile_component_files] << File.join(CEEDLING_LIB, 'rules_release_aux_dependencies.rake') if (in_hash[:project_release_build] and in_hash[:project_use_auxiliary_dependencies])
    out_hash[:project_rakefile_component_files] << File.join(CEEDLING_LIB, 'rules_release.rake') if (in_hash[:project_release_build])
    out_hash[:project_rakefile_component_files] << File.join(CEEDLING_LIB, 'tasks_release_aux_dependencies.rake') if (in_hash[:project_release_build] and in_hash[:project_use_auxiliary_dependencies])
    out_hash[:project_rakefile_component_files] << File.join(CEEDLING_LIB, 'tasks_release.rake') if (in_hash[:project_release_build])

    return out_hash
  end
  
  
  def set_release_target(in_hash)
    return {} if (not in_hash[:project_release_build])
    return {
      # tempted to make a helper method in file_path_utils? stop right there, pal. you'll introduce a cyclical dependency
      :project_release_build_target => File.join(in_hash[:project_release_artifacts_path], in_hash[:release_build_output])
      }
  end
  
  
  def collect_project_options(in_hash)
    return {
      :collection_project_options => @file_wrapper.directory_listing( File.join(in_hash[:project_options_path], '*.yml') )
      }
  end
  

  def expand_all_path_globs(in_hash)
    out_hash = {}
    path_keys = []
    
    in_hash.each_key do |key|
      next if (not key.to_s[0..4] == 'paths')
      path_keys << key
    end
    
    # sorted to provide assured order of traversal in test calls on mocks
    path_keys.sort.each do |key|
      out_hash["collection_#{key.to_s}".to_sym] = @file_system_utils.collect_paths( in_hash[key] )
    end
    
    return out_hash
  end


  def collect_source_and_include_paths(in_hash)
    extra_paths = []
    extra_paths << FilePathUtils::form_ceedling_vendor_path('c_exception/lib') if (in_hash[:project_use_exceptions])

    return {
      :collection_paths_source_and_include => 
        in_hash[:collection_paths_source] + 
        in_hash[:collection_paths_include] + 
        extra_paths
      }    
  end

  
  def collect_test_and_source_and_include_paths(in_hash)
    extra_paths = []
    insert_vendor_paths(extra_paths, in_hash)

    return {
      :collection_paths_test_and_source_and_include => 
        in_hash[:collection_paths_test] +
        in_hash[:collection_paths_support] +
        in_hash[:collection_paths_source] + 
        in_hash[:collection_paths_include] + 
        extra_paths
      }    
  end

    
  def collect_test_and_source_paths(in_hash)
    extra_paths = []
    insert_vendor_paths(extra_paths, in_hash)
    extra_paths << in_hash[:project_test_runners_path]

    return {
      :collection_paths_test_and_source => 
        in_hash[:collection_paths_test] +
        in_hash[:collection_paths_support] +
        in_hash[:collection_paths_source] + 
        extra_paths
      }    
  end
  
  
  def collect_tests(in_hash)
    all_tests = @file_wrapper.instantiate_file_list

    in_hash[:collection_paths_test].each do |path|
      all_tests.include( File.join(path, "#{in_hash[:project_test_file_prefix]}*#{in_hash[:extension_source]}") )
    end

    return {:collection_all_tests => all_tests}
  end


  def collect_assembly(in_hash)
    all_assembly = @file_wrapper.instantiate_file_list

    return {:collection_all_assembly => all_assembly} if (not in_hash[:release_build_use_assembly])
    
    in_hash[:collection_paths_source].each do |path|
      all_assembly.include( File.join(path, "*#{in_hash[:extension_assembly]}") )
    end
    
    return {:collection_all_assembly => all_assembly}
  end


  def collect_source(in_hash)
    all_source = @file_wrapper.instantiate_file_list
    
    in_hash[:collection_paths_source].each do |path|
      all_source.include( File.join(path, "*#{in_hash[:extension_source]}") )
    end
    
    return {:collection_all_source => all_source}
  end


  def collect_headers(in_hash)
    all_headers = @file_wrapper.instantiate_file_list
    
    paths = in_hash[:collection_paths_support] + in_hash[:collection_paths_source] + in_hash[:collection_paths_include]
    
    (paths).each do |path|
      all_headers.include( File.join(path, "*#{in_hash[:extension_header]}") )
    end
    
    return {:collection_all_headers => all_headers}
  end


  def collect_all_existing_compilation_input(in_hash)
    all_input = @file_wrapper.instantiate_file_list

    paths = 
      in_hash[:collection_paths_test] + 
      in_hash[:collection_paths_support] + 
      in_hash[:collection_paths_source] + 
      in_hash[:collection_paths_include] +
      [FilePathUtils::form_ceedling_vendor_path('unity/src')]
    
    paths << FilePathUtils::form_ceedling_vendor_path('c_exception/lib') if (in_hash[:project_use_exceptions])
    paths << FilePathUtils::form_ceedling_vendor_path('cmock/src') if (in_hash[:project_use_mocks])

    (paths).each do |path|
      all_input.include( File.join(path, "*#{in_hash[:extension_header]}") )
      all_input.include( File.join(path, "*#{in_hash[:extension_source]}") )
    end
    
    return {:collection_all_existing_compilation_input => all_input}    
  end


  def collect_test_defines(in_hash)
    test_defines = in_hash[:defines_test].clone
    
    test_defines << "UNITY_INT_WIDTH=#{in_hash[:unity_int_width]}"
    
    if (in_hash[:unity_exclude_float])
      test_defines << 'UNITY_EXCLUDE_FLOAT'
    else
      test_defines << "UNITY_FLOAT_TYPE=#{in_hash[:unity_float_type]}"
      test_defines << "UNITY_FLOAT_PRECISION=#{in_hash[:unity_float_precision]}"
    end
    
    return {:collection_defines_test => test_defines}
  end


  # gather up all files that if changed should cause generated files on-disk to be regenerated
  def collect_environment_dependencies
    dependencies = []
    
    ceedling_build_file = File.join(CEEDLING_RELEASE, 'build.info')
    cmock_build_file    = File.join(CEEDLING_VENDOR, 'cmock/release', 'build.info')

    # project files: anything changes in them & everything should regenerate
    dependencies << @project_file_loader.main_project_filepath
    user_project_file = @project_file_loader.user_project_filepath
    dependencies << user_project_file if (not user_project_file.empty?)
    
    # ceedling itself: if it changes we gotta regenerate files
    dependencies << ceedling_build_file
    
    # cmock: same as ceedling
    dependencies << cmock_build_file
    
    # Note: since Unity and CException are C files, changes to them are noticed elsewhere

    out_hash = {
      :collection_environment_dependencies => dependencies
    }
    
    return out_hash
  end

  private ##############################
  
  def insert_vendor_paths(paths, config)
    paths << FilePathUtils::form_ceedling_vendor_path('unity/src')
    paths << FilePathUtils::form_ceedling_vendor_path('c_exception/lib') if (config[:project_use_exceptions])
    paths << FilePathUtils::form_ceedling_vendor_path('cmock/src') if (config[:project_use_mocks])
    paths << config[:cmock_mock_path] if (config[:project_use_mocks])
  end
  
end

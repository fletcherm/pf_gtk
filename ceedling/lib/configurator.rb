require 'defaults'
require 'constants'
require 'file_path_utils'
require 'deep_merge'



class Configurator
  
  attr_reader :project_config_hash, :cmock_config_hash, :environment, :script_plugins, :rake_plugins
  
  constructor :configurator_helper, :configurator_builder, :configurator_plugins, :yaml_wrapper, :system_wrapper
  
  def setup
    # special copy of cmock config to provide to cmock for construction
    @cmock_config_hash = {}

    # capture our source config for later merge operations
    @source_config_hash = {}
    
    # note: project_config_hash is an instance variable so constants and accessors created
    # in eval() statements in build() have something of proper scope and persistence to reference
    @project_config_hash = {}
    @project_config_hash_backup = {}
    
    @script_plugins = []
  end

  
  def replace_flattened_config(config)
    @project_config_hash.merge!(config)
    @configurator_helper.build_constants_and_accessors(@project_config_hash, binding())
  end

  
  def store_config
    @project_config_hash_backup = @project_config_hash.clone
  end
  
  
  def restore_config
    @project_config_hash = @project_config_hash_backup
    @configurator_helper.build_constants_and_accessors(@project_config_hash, binding())
  end


  def populate_defaults(config)
    new_config = DEFAULT_CEEDLING_CONFIG.clone

    new_config.deep_merge!(config)

    @configurator_builder.populate_default_test_tools(new_config)
    @configurator_builder.populate_default_test_helper_tools(new_config)
    @configurator_builder.populate_default_release_tools(new_config)

    config.replace(new_config)
  end
  
  
  def populate_cmock_defaults(config)
    # cmock has its own internal defaults handling, but we need to set these specific values
    # so they're present for the build environment to access;
    # note: these need to end up in the hash given to initialize cmock for this to be successful
    cmock = {}    
    cmock = config[:cmock] if not config[:cmock].nil?
    
    cmock[:mock_prefix] = 'Mock'                                                 if (cmock[:mock_prefix].nil?)
    cmock[:enforce_strict_ordering] = true                                       if (cmock[:enforce_strict_ordering].nil?)
    cmock[:mock_path] = File.join(config[:project][:build_root], 'tests/mocks')  if (cmock[:mock_path].nil?)
    cmock[:verbosity] = config[:project][:verbosity]                             if (cmock[:verbosity].nil?)
    
    config[:cmock] = cmock if config[:cmock].nil?
    
    @cmock_config_hash = config[:cmock].clone
  end


  # grab tool names from yaml and insert into tool structures so available for error messages
  def populate_tool_names(config)
    config[:tools].each_key do |name|
      tool = config[:tools][name]
      tool[:name] = name.to_s
    end
  end
  

  def find_and_merge_plugins(config)
    @system_wrapper.add_load_path(config[:plugins][:auxiliary_load_path]) if (not config[:plugins][:auxiliary_load_path].nil?)
  
    @rake_plugins   = @configurator_plugins.find_rake_plugins(config)
    @script_plugins = @configurator_plugins.find_script_plugins(config)
    config_plugins  = @configurator_plugins.find_config_plugins(config)
    
    config_plugins.each do |plugin|
      config.deep_merge( @yaml_wrapper.load(plugin) )
    end
  end

  
  def eval_environment_variables(config)
    config[:environment].each do |hash|
      key = hash.keys[0]
      value_string = hash[key].to_s
      if (value_string =~ RUBY_STRING_REPLACEMENT_PATTERN)
        value_string.replace(@system_wrapper.eval(value_string))
      end
      @system_wrapper.env_set(key.to_s.upcase, value_string)
    end    
  end

  
  def eval_paths(config)
    individual_paths = [
      config[:project][:build_root],
      config[:project][:options_path],
      config[:plugins][:base_path],
      config[:plugins][:auxiliary_load_path]]
      
    # these are intended to be only single paths but we don't validate that until later
    # hence, we'll complain about them having multiple entries later
    # for now, just eval them
    individual_paths.each do |individual|
      individual.each { |path| path.replace(@system_wrapper.eval(path)) if (path =~ RUBY_STRING_REPLACEMENT_PATTERN) }
    end
  
    config[:paths].each_pair do |key, list|
      list.each { |path_entry| path_entry.replace(@system_wrapper.eval(path_entry)) if (path_entry =~ RUBY_STRING_REPLACEMENT_PATTERN) }
    end    
  end
  
  
  def standardize_paths(config)
    individual_paths = [
      config[:project][:build_root],
      config[:project][:options_path],
      config[:plugins][:base_path],
      config[:plugins][:auxiliary_load_path],
      config[:cmock][:mock_path]] # cmock path in case it was explicitly set in config

    # these are intended to be only single paths but we don't validate that until later
    # hence, we'll complain about them having multiple entries later
    # for now, just standardize them
    individual_paths.each do |individual|
      individual.each{|path| FilePathUtils::standardize(path)}
    end

    config[:paths].each_pair do |key, list|
      list.each{|path| FilePathUtils::standardize(path)}
      # ensure that list is an array (i.e. handle case of list being a single string)
      config[:paths][key] = [list].flatten
    end

    config[:tools].each_pair do |key, tool_config|
      FilePathUtils::standardize(tool_config[:executable])
    end    
  end


  def validate(config)
    # collect felonies and go straight to jail
    raise if (not @configurator_helper.validate_required_sections(config))
    
    # collect all misdemeanors, everybody on probation
    blotter = []
    blotter << @configurator_helper.validate_required_section_values(config)
    blotter << @configurator_helper.validate_paths(config)
    blotter << @configurator_helper.validate_tools(config)
    blotter << @configurator_helper.validate_plugins(config)
    
    raise if (blotter.include?(false))
  end
    
  
  def build(config)
    built_config = @configurator_helper.build_project_config(config)
    
    @source_config_hash   = config.clone
    @project_config_hash  = built_config.clone
    store_config()

    @configurator_helper.build_constants_and_accessors(built_config, binding())
  end
    
  
  def insert_rake_plugins(plugins)
  
    plugins.each do |plugin|
      @project_config_hash[:project_rakefile_component_files] << plugin
    end
  end
  
end

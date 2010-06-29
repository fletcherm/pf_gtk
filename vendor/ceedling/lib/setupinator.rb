
class Setupinator

  constructor :project_file_loader, :configurator, :test_includes_extractor, :plugin_manager, :plugin_reportinator, :file_finder

  def load_project_files
    @project_file_loader.find_project_files
    return @project_file_loader.load_project_file
  end

  def do_setup(system_objects, config_hash)
    # load up all the constants and accessors our rake files, objects, & external scripts will need;
    # note: configurator modifies the cmock section of the hash with a couple defaults to tie 
    #       project together - the modified hash is used to build cmock object
    @configurator.populate_defaults(config_hash)
    @configurator.populate_cmock_defaults(config_hash)
    @configurator.find_and_merge_plugins(config_hash)
    @configurator.populate_tool_names(config_hash)
    @configurator.eval_environment_variables(config_hash)
    @configurator.eval_paths(config_hash)
    @configurator.standardize_paths(config_hash)
    @configurator.validate(config_hash)
    @configurator.build(config_hash)
    @configurator.insert_rake_plugins(@configurator.rake_plugins)

    @plugin_manager.load_plugin_scripts(@configurator.script_plugins, system_objects)
    @plugin_reportinator.set_system_objects(system_objects)

    # must wait until the configurator is done with setup before we can and do use it;
    # dependencies / order of construction demands this approach
    @test_includes_extractor.configurator = @configurator
    
    @file_finder.prepare_search_sources
  end

end

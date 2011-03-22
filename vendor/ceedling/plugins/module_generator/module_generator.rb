require 'plugin'
require 'file_path_utils'
require 'constants'


class ModuleGenerator < Plugin

  attr_reader :config

  def setup
  
    #---- New module templates
    
    @test_template = (<<-EOS).left_margin
      #include "unity.h"
      <%if defined?(MODULE_GENERATOR_TEST_INCLUDES) && (MODULE_GENERATOR_TEST_INCLUDES.class == Array) && !MODULE_GENERATOR_TEST_INCLUDES.empty?%>
      <%MODULE_GENERATOR_TEST_INCLUDES.each do |header_file|%>
      #include "<%=header_file%>"
      <%end%>
      <%end%>
      #include "<%=hash[:headername]%>"
      
      void setUp(void)
      {
      }
      
      void tearDown(void)
      {
      }
      
      void test_<%=hash[:name]%>_NeedToImplement(void)
      {
          TEST_IGNORE();
      }
      EOS

    @source_template = (<<-EOS).left_margin
      <%if defined?(MODULE_GENERATOR_SOURCE_INCLUDES) && (MODULE_GENERATOR_SOURCE_INCLUDES.class == Array) && !MODULE_GENERATOR_SOURCE_INCLUDES.empty?%>
      <%MODULE_GENERATOR_SOURCE_INCLUDES.each do |header_file|%>
      #include "<%=header_file%>"
      <%end%>
      <%end%>
      #include "<%=hash[:headername]%>"
      EOS

    @header_template = (<<-EOS).left_margin
      #ifndef _<%=hash[:name]%>_H
      #define _<%=hash[:name]%>_H
      
      <%if defined?(MODULE_GENERATOR_HEADER_INCLUDES) && (MODULE_GENERATOR_HEADER_INCLUDES.class == Array) && !MODULE_GENERATOR_HEADER_INCLUDES.empty?%>
      <%MODULE_GENERATOR_HEADER_INCLUDES.each do |header_file|%>
      #include "<%=header_file%>"
      <%end%>
      <%end%>
      
      #endif // _<%=hash[:name]%>_H
      EOS
      
      
    #---- New function templates
      
    @func_test_template = (<<-EOS).left_margin
      
      /* ------ <%=@declaration[:name]%> ------ */
      
      void test_<%=@declaration[:name]%>_needs_to_be_implemented(void)
      {
          TEST_IGNORE();
      }
      
      EOS
  end

  def create(path, optz={})
  
    context = extract_context(path, optz)

    if !optz.nil? && (optz[:destroy] == true)
      @ceedling[:streaminator].stdout_puts "Destroying '#{path}'..."
      @files.each do |file|
        if @ceedling[:file_wrapper].exist?(file[:path])
          @ceedling[:file_wrapper].rm_f(file[:path])
        else
          @ceedling[:streaminator].stdout_puts "File #{file[:path]} does not exist!"
        end
      end
      exit
    end

    @ceedling[:streaminator].stdout_puts "Generating '#{path}'..."

    @files[0][:template] = @test_template
    @files[1][:template] = @source_template
    @files[2][:template] = @header_template

    @files.each do |file|
      if @ceedling[:file_wrapper].exist?(file[:path])
        @ceedling[:streaminator].stdout_puts "File #{file[:path]} already exists!"
      else
        @ceedling[:file_wrapper].open(file[:path], 'w') do |file_stream|
          @ceedling[:plugin_reportinator].run_report( file_stream, file[:template], context )
          @ceedling[:streaminator].stdout_puts "File #{file[:path]} created"
        end
      end
    end

  end
    
  private
  
  def extract_context(path, optz={})
    if (!defined?(PROJECT_ROOT) ||
        !defined?(MODULE_GENERATOR_SOURCE_ROOT) ||
        !defined?(MODULE_GENERATOR_TEST_ROOT))
      raise "You must have 'PROJECT_ROOT', '[:module_generator][:source_root]' and '[:module_generator][:test_root]' defined in your Ceedling configuration file."
    end
    
    context = {}

    context[:paths] = {
      :base => FilePathUtils.standardize( @ceedling[:file_wrapper].get_expanded_path(PROJECT_ROOT) ),
      :src  => FilePathUtils.standardize( MODULE_GENERATOR_SOURCE_ROOT ),
      :test => FilePathUtils.standardize( MODULE_GENERATOR_TEST_ROOT )
    }

    location = File.dirname( FilePathUtils.standardize( path ) )
    location.sub!(/^\/?#{context[:paths][:base]}\/?/i, '')
    location.sub!(/^\/?#{context[:paths][:src]}\/?/i, '')
    location.sub!(/^\/?#{context[:paths][:test]}\/?/i, '')
    
    context[:location] = location

    context[:name] = File.basename(path).sub(/\.[ch]$/, '')
    
    context[:testname] = "test_#{context[:name]}.c"
    context[:sourcename] = "#{context[:name]}.c"
    context[:headername] = "#{context[:name]}.h"

    @files = [
      {:path => File.join(PROJECT_ROOT, context[:paths][:test], location, context[:testname])},
      {:path => File.join(PROJECT_ROOT, context[:paths][:src],  location, context[:sourcename])},
      {:path => File.join(PROJECT_ROOT, context[:paths][:src],  location, context[:headername])}
    ]
    
    return context
  end
  
end
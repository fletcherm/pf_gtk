# ==========================================
#   CMock Project - Automatic Mock Generation for C
#   Copyright (c) 2007 Mike Karlesky, Mark VanderVoord, Greg Williams
#   [Released under MIT License. Please refer to license.txt for details]
# ========================================== 

class CMockConfig
  
  CMockDefaultOptions = 
  {
    :framework                => :unity,
    :mock_path                => 'mocks',
    :mock_prefix              => 'Mock',
    :plugins                  => [],
    :includes                 => [],
    :attributes               => ['__ramfunc', '__irq', '__fiq', 'register', 'extern'],
    :enforce_strict_ordering  => false,
    :cexception_include       => nil,
    :unity_helper             => false,
    :treat_as                 => {},
    :treat_as_void            => [],
    :memcmp_if_unknown        => true,
    :when_no_prototypes       => :warn,           #the options being :ignore, :warn, or :error
    :when_ptr                 => :compare_data,   #the options being :compare_ptr, :compare_data, or :smart
    :verbosity                => 2,               #the options being 0 errors only, 1 warnings and errors, 2 normal info, 3 verbose
    :treat_externs            => :exclude,        #the options being :include or :exclude
    :ignore                   => :args_and_calls, #the options being :args_and_calls or :args_only
    :callback_include_count   => true,
    :callback_after_arg_check => false,
  }
  
  def initialize(options=nil)
    case(options)
      when NilClass then options = CMockDefaultOptions.clone 
      when String   then options = CMockDefaultOptions.clone.merge(load_config_file_from_yaml(options))
      when Hash     then options = CMockDefaultOptions.clone.merge(options)
      else          raise "If you specify arguments, it should be a filename or a hash of options"
    end
    
    #do some quick type verification
    [:plugins, :includes, :attributes, :treat_as_void].each do |opt|
      unless (options[opt].class == Array)
        options[opt] = []
        puts "WARNING: :#{opt.to_s} should be an array." unless (options[:verbosity] < 1)
      end
    end

    @options = options
    @options[:treat_as].merge!(standard_treat_as_map)
    @options.each_key { |key| eval("def #{key}() return @options[:#{key}] end") }
  end
  
  def load_config_file_from_yaml yaml_filename
    require 'yaml'
    require 'fileutils'
    YAML.load_file(yaml_filename)[:cmock]
  end
  
  def set_path(path)
    @src_path = path
  end
  
  def load_unity_helper
    return File.new(@options[:unity_helper]).read if (@options[:unity_helper])
    return nil
  end

  def standard_treat_as_map 
    {
      'int'             => 'INT',
      'char'            => 'INT8',
      'short'           => 'INT16',
      'long'            => 'INT',
      'int8'            => 'INT8',
      'int16'           => 'INT16',
      'int32'           => 'INT',
      'int8_t'          => 'INT8',
      'int16_t'         => 'INT16',
      'int32_t'         => 'INT',
      'INT8_T'          => 'INT8',
      'INT16_T'         => 'INT16',
      'INT32_T'         => 'INT',
      'bool'            => 'INT',
      'bool_t'          => 'INT',
      'BOOL'            => 'INT',
      'BOOL_T'          => 'INT',
      'unsigned int'    => 'HEX32',
      'unsigned long'   => 'HEX32',
      'uint32'          => 'HEX32',
      'uint32_t'        => 'HEX32',
      'UINT32'          => 'HEX32',
      'UINT32_T'        => 'HEX32',
      'void*'           => 'HEX32',
      'unsigned short'  => 'HEX16',
      'uint16'          => 'HEX16',
      'uint16_t'        => 'HEX16',
      'UINT16'          => 'HEX16',
      'UINT16_T'        => 'HEX16',
      'unsigned char'   => 'HEX8',
      'uint8'           => 'HEX8',
      'uint8_t'         => 'HEX8',
      'UINT8'           => 'HEX8',
      'UINT8_T'         => 'HEX8',
      'char*'           => 'STRING',
      'pCHAR'           => 'STRING',
      'cstring'         => 'STRING',
      'CSTRING'         => 'STRING',
      'float'           => 'FLOAT',
      'double'          => 'FLOAT',
    }
  end
end

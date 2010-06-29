
class TestIncludesExtractor

  constructor :yaml_wrapper, :file_wrapper

  attr_writer :configurator

  def setup
    @includes  = {}
    @mocks     = {}    
    @all_mocks = []
  end


  # for each includes_list file, slurp up array from yaml file and sort & store includes
  def parse_includes_lists(includes_lists)
    gather_and_store_includes(includes_lists) {|includes_list| @yaml_wrapper.load(includes_list)}
  end

  # for each test file, open, scan for, and sort & store includes
  def parse_test_files(tests)
    gather_and_store_includes(tests) {|test| extract_from_file(test)}
  end

  # with header file extensions
  def lookup_all_mocks
    return @all_mocks
  end
  
  # mocks with no file extension
  def lookup_raw_mock_list(test_file)
    file_key = form_file_key(test_file)
    return [] if @mocks[file_key].nil?
    return @mocks[file_key]
  end
  
  # includes with file extension
  def lookup_includes_list(file)
    file_key = form_file_key(file)
    return [] if (@includes[file_key]).nil?
    return @includes[file_key]
  end
  
  private #################################
  
  def form_file_key(filepath)
    return File.basename(filepath).to_sym
  end

  def extract_from_file(file)
    includes = []
    header_extension = @configurator.extension_header
    
    contents = @file_wrapper.read(file)

    # remove line comments
    contents = contents.gsub(/\/\/.*$/, '')
    # remove block comments
    contents = contents.gsub(/\/\*.*?\*\//m, '')
    
    contents.split("\n").each do |line|
      # look for include statement
      scan_results = line.scan(/#include\s+\"\s*(.+#{'\\'+header_extension})\s*\"/)
      
      includes << scan_results[0][0] if (scan_results.size > 0)
    end
    
    return includes.uniq
  end

  def gather_and_store_includes(files)
    mock_prefix      = @configurator.cmock_mock_prefix
    header_extension = @configurator.extension_header
  
    files.each do |file|
      file_key = form_file_key(file)
      @mocks[file_key] = []
      
      # pull out includes for file
      includes = yield(file)

      # add includes to lookup hash
      @includes[file_key] = includes
      
      includes.each do |include_file|          
        # check if include is a mock
        scan_results = include_file.scan(/(#{mock_prefix}.+)#{'\\'+header_extension}/)
        if (scan_results.size > 0)
          # add mock to list of all mocks and to lookup hash
          mock = scan_results[0][0]
          @all_mocks << "#{mock}#{header_extension}" 
          @mocks[file_key] << mock
        end          
      end
    end
    
    @all_mocks.uniq!    
  end
  
end

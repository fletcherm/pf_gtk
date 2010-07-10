require 'rubygems'
require 'rake' # for .ext()

 
class GeneratorTestResults
  TEST_STATISTICS_REGEX = /-+\s+(\d+)\s+Tests\s+(\d+)\s+Failures\s+(\d+)\s+Ignored\s+(OK|FAIL)\s*/i

  constructor :configurator, :generator_test_results_sanity_checker, :yaml_wrapper
 
  def process_and_write_results(raw_unity_output, results_file, test_file)
    output_file = results_file
    
    results = get_results_structure
    
    results[:source][:path] = File.dirname(test_file)
    results[:source][:file] = File.basename(test_file)
    
    # process test statistics
    if (raw_unity_output =~ TEST_STATISTICS_REGEX)
      results[:counts][:total]   = $1.to_i
      results[:counts][:failed]  = $2.to_i
      results[:counts][:ignored] = $3.to_i
      results[:counts][:passed]  = (results[:counts][:total] - results[:counts][:failed] - results[:counts][:ignored])
    end

    # remove test statistics lines
    raw_unity_output.sub!(TEST_STATISTICS_REGEX, '')
    
    # bust up the output into individual lines
    raw_unity_lines = raw_unity_output.split(/\n|\r\n/)
    
    raw_unity_lines.each do |line|
      # process unity output
      case line
      when /(:IGNORE)/
        elements = extract_line_elements(line, results[:source][:file])
        results[:ignores]   << elements[0]
        results[:stdout]    << elements[1] if (!elements[1].nil?)
      when /(:PASS$)/
        elements = extract_line_elements(line, results[:source][:file])
        results[:successes] << elements[0]
        results[:stdout]    << elements[1] if (!elements[1].nil?)
      when /(:FAIL)/
        elements = extract_line_elements(line, results[:source][:file])
        results[:failures]  << elements[0]
        results[:stdout]    << elements[1] if (!elements[1].nil?)
      else # collect up all other
        results[:stdout] << line.chomp
      end
    end
    
    @generator_test_results_sanity_checker.verify(results)
    
    output_file = results_file.ext(@configurator.extension_testfail) if (results[:counts][:failed] > 0)
    
    @yaml_wrapper.dump(output_file, results)
  end

  private

  def get_results_structure
    return {
      :source    => {:path => '', :file => ''},
      :successes => [],
      :failures  => [],
      :ignores   => [],
      :counts    => {:total => 0, :passed => 0, :failed => 0, :ignored  => 0},
      :stdout    => [],
      }
  end
  
  def extract_line_elements(line, filename)
    # handle anything preceding filename in line as extra output to be collected
    stdout = nil
    stdout_regex = /(.+)#{Regexp.escape(filename)}.+/i
    
    if (line =~ stdout_regex)
      stdout = $1.clone
      line.sub!(/#{Regexp.escape(stdout)}/, '')
    end
    
    # collect up test results minus and extra output
    elements = (line.strip.split(':'))[1..-1]
    return {:test => elements[1], :line => elements[0].to_i, :message => (elements[3..-1].join(':')).strip}, stdout
  end

end

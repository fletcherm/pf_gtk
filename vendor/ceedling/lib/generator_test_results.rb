require 'rubygems'
require 'rake' # for .ext()
require 'constants' # for Verbosity constants class


 
class GeneratorTestResults

  constructor :configurator, :yaml_wrapper, :streaminator

  
  def process_and_write_results(raw_unity_output, results_file, test_file)
    output_file = results_file
    
    results = get_results_structure
    
    results[:source][:path] = File.dirname(test_file)
    results[:source][:file] = File.basename(test_file)
    
    raw_unity_output.each_line do |line|
      # skip any blank lines
      if (line.strip.empty?)
        next
      # find any unity output messages 
      elsif (line.include?(':'))
        processed_line = line.strip

        if (processed_line =~ /(:IGNORE)/)
          results[:ignores]   << extract_line_elements(processed_line)
        elsif (processed_line =~ /(:PASS$)/)
          results[:successes] << extract_line_elements(processed_line)
        elsif (processed_line =~ /(:FAIL:)/)
          results[:failures]  << extract_line_elements(processed_line)
        end

      # process test statistics
      elsif (line =~ /^(\d+)\s+Tests\s+(\d+)\s+Failures\s+(\d+)\s+Ignored/i)
        results[:counts][:total]   = $1.to_i
        results[:counts][:failed]  = $2.to_i
        results[:counts][:ignored] = $3.to_i
        results[:counts][:passed]  = (results[:counts][:total] - results[:counts][:failed] - results[:counts][:ignored])
        break # skip anything following statistics line
      end
      
    end
    
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
      :counts    => {:total => 0, :passed => 0, :failed => 0, :ignored  => 0}
      }
  end
  
  def extract_line_elements(line)
    elements = (line.split(':'))[1..-1]
    return {:test => elements[1], :line => elements[0].to_i, :message => (elements[3..-1].join(':')).strip}
  end

end

require 'plugin'


class StdoutIdeTestsReport < Plugin

  def setup
    @test_list = []

    @template = %q{
      % ignored = results[:counts][:ignored]
      % failed  = results[:counts][:failed]
      % if (ignored > 0)
      <%=@ceedling[:plugin_reportinator].generate_banner('IGNORED UNIT TEST SUMMARY')%>
      %   results[:ignores].each do |ignore|
      %     ignore[:collection].each do |item|
      <%=File.join(ignore[:source][:path], ignore[:source][:file])%>:<%=item[:line]%>:<%=item[:test]%>:<%=item[:message]%>
      %     end
      %   end

      % end
      % if (failed > 0)
      <%=@ceedling[:plugin_reportinator].generate_banner('FAILED UNIT TEST SUMMARY')%>
      %   results[:failures].each do |failure|
      %     failure[:collection].each do |item|
      <%=File.join(failure[:source][:path], failure[:source][:file])%>:<%=item[:line]%>:<%=item[:test]%>:<%=item[:message]%>
      %     end
      %   end

      % end
      % total_string = results[:counts][:total].to_s
      % format_string = "%#{total_string.length}i"
      
      Passed <%=sprintf(format_string, results[:counts][:passed])%>/<%=results[:counts][:total].to_s%> tests (<%=sprintf(format_string, failed)%> failed; <%=sprintf(format_string, ignored)%> ignored)
    }.left_margin
  end

  def post_test_execute(arg_hash)
    test = File.basename(arg_hash[:executable], EXTENSION_EXECUTABLE)

    @test_list << test if not @test_list.include?(test)
  end

  def post_build
    return if (not @ceedling[:plugin_reportinator].test_build?)

    results = @ceedling[:plugin_reportinator].assemble_test_results(PROJECT_TEST_RESULTS_PATH, @test_list)

    @ceedling[:plugin_reportinator].run_report($stdout, @template, results) do
      message = ''
      message = 'Unit test failures.' if (results[:counts][:failed] > 0)
      message
    end
  end

end
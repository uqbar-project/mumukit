require 'yaml'

class Mumukit::TestServer
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def run!(request)
    content = request['content']
    extra = request['extra']

    test_results = run_tests! config, request['test'], extra, content
    expectation_results = run_expectations! config, request['expectations'], content, extra

    response = {exit: test_results[1], out: test_results[0], expectationResults: expectation_results}
    response[:feedback] = test_results[2] if test_results[2]

    response
  rescue Exception => e
    {exit: :failed, out: "#{e.message}:\n#{e.backtrace.join("\n")}"}
  end


  def run_tests!(config, test, extra, content)
    compiler = TestCompiler.new(config)
    runner = TestRunner.new(config)

    compilation = compiler.create_compilation!(test, extra, content)
    runner.run_compilation!(compilation)
  end

  def run_expectations!(config, expectations, content, extra)
    expectations_runner = ExpectationsRunner.new(config)

    if expectations
      expectations_runner.run_expectations!(expectations, content, extra)
    else
      []
    end
  end
end
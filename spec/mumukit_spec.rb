require_relative './spec_helper.rb'
require 'rack/test'

describe Mumukit do
  include Rack::Test::Methods

  def app
    Mumukit::Server::App.new
  end

  it { expect { Mumukit.runner_url }.to raise_exception }

  it "should respond with the request's url" do
    get '/info'

    last_response.should be_ok
    expect(Mumukit.runner_url).to eq 'http://example.org'
  end

  it "should add the repo_url property" do
    get '/info'

    expect(JSON.parse(last_response.body)["repo_url"]).to eq 'https://github.com/mumuki/mumuki-demo-runner'
  end

end
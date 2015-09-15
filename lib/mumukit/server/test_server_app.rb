require 'sinatra/base'
require 'yaml'
require 'json'


class Mumukit::TestServerApp < Sinatra::Base
  configure do
    set :mumuki_url, 'http://mumuki.io'
  end

  configure :development do
    set :config_filename, 'config/development.yml'
  end

  configure :production do
    set :config_filename, 'config/production.yml'
  end

  config = YAML.load_file(settings.config_filename) rescue nil
  server = Mumukit::TestServer.new(config)

  helpers do
    def parse_request
      r = JSON.parse(request.body.read)
      I18n.locale = r['locale'] || :en
      r
    end
  end

  post '/test' do
    JSON.generate(server.test!(parse_request))
  end

  post '/query' do
    JSON.generate(server.query!(parse_request))
  end

  get '/*' do
    redirect settings.mumuki_url
  end
end

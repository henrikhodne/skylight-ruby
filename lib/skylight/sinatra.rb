require 'skylight'
require 'rails'

module Skylight
  module Sinatra
    def self.registered(base)
      config = Skylight::Config.load(nil, base.environment, ENV)
      config['root'] = base.root
      config['agent.sockfile_path'] = File.join(config['root'], 'tmp')
      config.validate!

      Skylight.start!(config)

      base.use Skylight::Middleware
    end

    def route(verb, path, *)
      condition do
        trace = ::Skylight::Instrumenter.instance.current_trace
        trace.endpoint = "#{verb} #{uri(path, false)}"

        true
      end

      super
    end
  end
end

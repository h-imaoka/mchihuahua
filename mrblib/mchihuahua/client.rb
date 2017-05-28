# coding: utf-8
module Mchihuahua
  class Client
    def initialize
      raise 'API Key does not exist.' unless ENV['DATADOG_API_KEY']
      raise 'Application Key does not exist.' unless ENV['DATADOG_APP_KEY']
      @api_key = ENV['DATADOG_API_KEY']
      @app_key = ENV['DATADOG_APP_KEY']
    end

    def dog
      config = {
        :api_key => @api_key,
        :app_key => @app_key
      }
      Datadog::Monitors.new(config)
    end
  end
end

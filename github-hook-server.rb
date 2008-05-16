require 'rubygems'
require 'json'
require 'sinatra'
require 'yaml'

CONFIG = YAML.load_file('config.yml')
CONFIG["template"] ||= "[<%= commit['repo'] %>] <%= commit['url'] %> by <%= commit['author']['name'] %> - <%= commit['message'] %>"

class GithubHookServer
  def initialize(payload)
    payload = JSON.parse(payload)
    return unless payload.keys.include?("repository")

    repo = payload["repository"]["name"]

    CONFIG[repo]["hooks"].each do |hook_config|
      name = "#{hook_config[0]}_hook"
      clsn = "#{name}".split('_').map {|w| w.capitalize}.join
      require "hooks/#{name}"
      Module.const_get(clsn).new.invoke(payload, hook_config.last, CONFIG)
    end
  end
end

post '/' do
  GithubHookServer.new(params[:payload])
  "OMGLITTLEHORSES! IT WORKED!"
end

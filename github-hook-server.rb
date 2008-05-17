#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'sinatra'
require 'yaml'

class GithubHookServer
  def process_payload(json_payload)
    # Load server config
    @config = YAML.load_file('config.yml')
    
    # Set the default template
    @config["template"] ||= "[<%= commit['repo'] %>] <%= commit['url'] %> by <%= commit['author']['name'] %> - <%= commit['message'] %>"
    
    # Parse the packet
    payload = JSON.parse(json_payload)

    # Quick and dirty sanity check
    return unless payload.keys.include?("repository")

    # Grab the repo name
    repo = payload["repository"]["name"]

    # Iterate configured hooks and fire appropriate plugins
    @config[repo]["hooks"].each do |hook_config|
      # Concat the hook name
      name = "#{hook_config[0]}_hook"
      # Concat the hook class name
      clsn = "#{name}".split('_').map {|w| w.capitalize}.join
      # Require the appropriate hook
      require "hooks/#{name}"
      # Fire!
      Module.const_get(clsn).new.invoke(payload, hook_config.last, @config)
    end
  
    "OMGLITTLEHORSES! IT WORKED!"
  end
end

post '/' do
  GithubHookServer.new.process_payload(params['payload']) unless params.keys.include?('payload')
end
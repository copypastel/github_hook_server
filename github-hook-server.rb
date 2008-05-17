#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'sinatra'
require 'yaml'
require 'simple-daemon'

# Prevent Sinatra from running until we're ready
Sinatra::Application.default_options.merge!(:run => false)

# Set Sinatra's working directory
SimpleDaemon::WORKING_DIRECTORY = "#{File.dirname(__FILE__)}"

class GithubHookServer < SimpleDaemon::Base
  def initialize
    # Ignore logout
    Signal.trap('HUP', 'IGNORE')
    
    # Load server config
    @config = YAML.load_file('config.yml')
    
    # Set the default template
    @config["template"] ||= "[<%= commit['repo'] %>] <%= commit['url'] %> by <%= commit['author']['name'] %> - <%= commit['message'] %>"
    
    post '/' do
      # Quick and dirty sanity check
      return unless params.keys.include?("payload")
      
      # Parse the packet
      payload = JSON.parse(params[:payload])

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
  
  def self.start
    Sinatra.run
  end
  
  def self.stop
    puts "Daemon dying"
  end
end

GithubHookServer.daemonize
#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'sinatra'
require 'yaml'

require 'database-support'

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

    return if @config[repo].nil?
    # Iterate configured hooks and fire appropriate plugins
    @config[repo]["hooks"].each do |hook_config|
      # Concat the hook name
      name = "#{hook_config[0]}_hook"
      # Concat the hook class name
      clsn = "#{name}".split('_').map {|w| w.capitalize}.join
      # Require the appropriate hook
      require "hooks/#{name}"
      
      hook_data = hook_config.last
      #hack for right now since database only supports plurk... but in future it could be integrated...
      #kindof sucks github does this automatically but doesn't do it for plurk
      if hook_data["command"] == use_database
        account = Account.find(payload[:commits])
        hook_data[:username]
      end
      
      hook_data['template'] = @config['template'] if hook_data['template'].nil?
      # Fire!
      Module.const_get(clsn).new.process_payload(payload, hook_data)
    end
  
    "OMGLITTLEHORSES! IT WORKED!"
  end
end

#views

post '/' do
  GithubHookServer.new.process_payload(params['payload']) if params.keys.include?('payload')
  
  erb :index, :locals => { :saved => nil }
end

get '/' do
  erb :index, :locals => { :saved => nil }
end

get '/account' do
  erb :account_form
end

post '/account' do
 k# account = Account.create(:username => params[:username], :password => params[:password])
  account = Account.new
  account.username = params[:username]
  account.password = params[:password]
  account.email = params[:email]
  #WHAT THE HELL!! VALIDATIONS DON'T WORK account.save is always true!
  erb :index, :locals => { :saved => account.save }
end


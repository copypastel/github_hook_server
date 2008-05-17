require 'twitter'
require 'erb'

class TwitterHook

  def process_payload(payload, hook_config, server_config)
    template = server_config['template'] || hook_config['template']
    twitter = Twitter::Base.new(hook_config['username'], hook_config['password'])
    erb = ERB.new(template)

    payload['commits'].each do |commit_obj|
      commit = commit_obj.last
      commit['repo'] = payload['repository']['name']
      twitter.post(erb.result(Proc.new { commit }))
    end
  end

end

require 'tinder'
require 'erb'

class CampfireHook

  def process_payload(payload, hook_config, server_config)
    template = server_config['template'] || hook_config['template']

    campfire = Tinder::Campfire.new(hook_config['subdomain'], :ssl => hook_config['ssl'] || false)
    campfire.login(hook_config['username'], hook_config['password'])
    room = campfire.find_room_by_name(hook_config['room'])

    erb = ERB.new(template)

    payload['commits'].each do |commit_obj|
      commit = commit_obj.last
      commit['repo'] = payload['repository']['name']
      room.speak(erb.result(Proc.new { commit }))
    end

    campfire.logout
  end

end

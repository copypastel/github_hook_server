Dir[File.dirname(__FILE__) + "/../vendor/*"].each do |l|
  $:.unshift "#{File.expand_path(l)}/lib"
end

require 'plurk'
require 'erb'

class PlurkHook
  
  def process_payload(payload, hook_config)
     template = hook_config['template']
     plurk = Plurk.new
     plurk.login(hook_config['username'], hook_config['password'])

     erb = ERB.new(template)
     
     

     payload['commits'].each do |commit_obj|
       commit = commit_obj
       puts commit
       puts "DEBUG"
       commit['repo'] = payload['repository']['name']
       plurk_msg = erb.result(Proc.new { commit })
       
       puts plurk_msg
       plurk.add_plurk(plurk_msg,"shares")
     end
   end
end
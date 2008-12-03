Dir[File.dirname(__FILE__) + "/../vendor/*"].each do |l|
  $:.unshift "#{File.expand_path(l)}/lib"
end

require 'plurk'

class PlurkHook
  
  def process_payload(payload, hook_config)
     template = hook_config['template']
     plurk = Plurk.new
     puts "DUBUG"
     puts hook_config['username']
     puts "DEBUG"
     puts hook_config['password']
     puts "DEBUG"
     plurk.login(hook_config['username'], hook_config['password'])

     erb = ERB.new(template)
     
     

     payload['commits'].each do |commit_obj|
       commit = commit_obj.last
       commit['repo'] = payload['repository']['name']
       plurk.add_plurk(erb.result(Proc.new { commit }),"shares")
     end
   end
end
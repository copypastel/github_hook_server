Dir[File.dirname(__FILE__) + "../vendor/*"].each do |l|
  $:.unshift "#{File.expand_path(l)}/lib"
end

require 'simplemail'

class SendmailHook
  
  def process_payload(payload, hook_config, server_config)
    mail         = SimpleMail.new
    mail.to      = hook_config['to']
    mail.from    = hook_config['from']
    mail.sender  = hook_config['sender']
    mail.text    = hook_config['text']
    mail.html    = hook_config['html']
    mail.subject = hook_config['subject']
    
    mail.send
  end
  
end
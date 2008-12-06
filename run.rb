#!/usr/bin/env ruby
require 'rubygems'
require 'simple-daemon'


class Processor < SimpleDaemon::Base
  SimpleDaemon::WORKING_DIRECTORY = '/var/www/projects.copypastel/github_hook_server/'

  def self.start
    puts "hello"
    #loop do
    #  system("echo 'HELLO DAMN IT'")
          system('/var/www/projects.copypastel/github_hook_server/github-hook-server.rb')
    #  system("echo 'FUCK'")
   # end
  end

  def self.stop
    #implement
  end
end

Processor.daemonize

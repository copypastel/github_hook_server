TODO: Re-merge old README

to run..

Github Hook Server
==================
In order to have a project with multiple colaberators, but allow the collaberators to plurk/twitter/ect github-hook-server to the rescue.

Colaberators sign up and enter their cradentials to their various services, and the admin sets the post-receive message to go to the server.
The rest is a simple config file

Getting Started
---------------
edit database-support.rb for your given database
edit config.yml.example and save as config.yml.template

$bash ./init_db.rb
$bash ./github-hook-server.rb

You can also run it as a daemon... hack for now
$bash ./run.rb start

visit localhost:4567 (or whatever sinatra starts on)
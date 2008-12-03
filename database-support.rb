require 'rubygems'
require 'dm-core'
DataMapper.setup(:default, "sqlite3:///./github_hook_server.db")

#modles

class Account
  include DataMapper::Resource
  
  property :id, Serial
  property :username, String, :nullable => false,:unique => true
  property :password, String, :nullable => false
  property :email, String, :nullable => false
end

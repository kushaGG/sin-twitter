ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

task "s" do
	exec "shotgun --server=thin --port=3005 config.ru"
end

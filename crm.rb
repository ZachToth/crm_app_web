require 'sinatra'
require_relative 'contact'
require_relative 'rolodex'

$rolodex= Rolodex.new

#routes
get '/' do 
	@crm_app_name = "My CRM"
	erb :index
end

get '/contacts' do
	erb :contacts
end

get '/contacts/new' do
	erb :new_contact
end
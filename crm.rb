require 'sinatra'
require_relative 'contact'
require_relative 'rolodex'
require "pry"

$rolodex= Rolodex.new

#routes
#gets
get '/' do 
	@crm_app_name = "My CRM"
	erb :index
end


get '/contacts' do
	erb :contacts
end

get '/contacts/new_contact' do
	erb :new_contact
end

get '/contacts/:id' do
	@contact = $rolodex.get_contact(params[:id].to_i)
	# binding.pry
	erb :show
end

#posts
post '/contacts' do
	new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
	$rolodex.add_contact(new_contact)
	redirect to('/contacts')
end
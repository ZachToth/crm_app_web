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
	if @contact
		erb :show
	else
		raise sinatra::NotFound
	end
end

get '/contacts/:id/edit' do
	@contact = $rolodex.get_contact(params[:id].to_i)
	if @contact
		erb :edit
	else
		raise sinatra::NotFound
	end
end

#puts
put '/contacts/:id' do
  @contact = $rolodex.get_contact(params[:id].to_i)
  if @contact
    @contact.first_name = params[:first_name]
    @contact.last_name = params[:last_name]
    @contact.email = params[:email]
    @contact.note = params[:note]

    redirect to('/contacts')
  else
    raise Sinatra::NotFound
  end
end

#posts
post '/contacts' do
	new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
	$rolodex.add_contact(new_contact)
	redirect to('/contacts')
end

#deletes
delete "/contacts/:id" do
  @contact = $rolodex.get_contact(params[:id].to_i)
  if @contact
    $rolodex.remove_contact(@contact)
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end
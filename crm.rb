require 'sinatra'
require_relative 'rolodex'
require 'pry'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
  include DataMapper::Resource
    # attr_accessor :id, :first_name, :last_name, :email, :note

    property :id, Serial
    property :first_name, String
    property :last_name, String
    property :email, String
    property :note, String 

  # def initialize(first_name, last_name, email, note)
  #   @id = id
  #   @first_name = first_name
  #   @last_name = last_name
  #   @email = email
  #   @note = note
  # end

  # def to_s
  #   "\nId: #{@id}\nFirst Name: #{@first_name}\nLast Name: #{@last_name}\nEmail: #{@email}\nNote: #{@note}\n"
  # end
end

DataMapper.finalize
DataMapper.auto_upgrade!

$rolodex= Rolodex.new

#routes
#gets
get '/' do 
	@crm_page_name = "My CRM"
	erb :index
end


get '/contacts' do
	@crm_page_name = "All Contacts"
  @contacts = Contact.all
	erb :contacts
end

get '/contacts/new_contact' do
	@crm_page_name = "Add a New Contact"
	erb :new_contact
end

get '/contacts/:id' do
	  @contact = Contact.get(params[:id].to_i)
	@crm_page_name = @contact.first_name
	# binding.pry
	if @contact
		erb :show
	else
		raise sinatra::NotFound
	end
end

get '/contacts/:id/edit' do
	@contact = $rolodex.get_contact(params[:id].to_i)
	@crm_page_name = "Edit #{@contact.first_name}"
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
	 contact = Contact.create(
    :first_name => params[:first_name],
    :last_name => params[:last_name],
    :email => params[:email],
    :note => params[:note]
  )
	redirect to('/contacts')
end

#deletes
delete "/contacts/:id" do
  contact = $rolodex.get_contact(params[:id].to_i)
  if contact
    $rolodex.remove_contact(contact)
    redirect to("/contacts")
  else
    raise Sinatra::NotFound
  end
end
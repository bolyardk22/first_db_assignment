require 'sinatra'
require 'pg'
load './local_env.rb' if File.exist?('./local_env.rb')

db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}

db = PG::Connection.new(db_params)

get '/' do
	erb :index
end

post '/index' do
	first_name = params[:first_name]
	last_name = params[:last_name]
	street_address = params[:street_address]
	city = params[:city]
	state = params[:state]
	zip = params[:zip]
	phone_number = params[:phone_number]
	email_address = params[:email_address]
	db.exec("INSERT INTO phonebook(first_name, last_name, street_address, city, state, zip, phone_number, email_address) VALUES('#{first_name}', '#{last_name}', '#{street_address}', '#{city}', '#{state}', '#{zip}', '#{phone_number}', '#{email_address}')");
	redirect '/success'
end

get '/success' do
	erb :success
end

get '/phone_book' do
	phonebook = db.exec("Select * From phonebook")
	erb :phone_book, locals: {phonebook: phonebook}
end

get '/edit_select' do
	phonebook = db.exec("Select * From phonebook")
	erb :edit_select
end

post '/edit' do
	edit_num = params[:edit_select_table_radio]
	redirect '/edit_info?edit_num=' + edit_num
end

get '/edit_info' do
	phonebook = db.exec("Select * From phonebook")
	edit_num = params[:edit_num]
	user_row = db.exec("SELECT * FROM phonebook WHERE phone_number = '#{edit_num}'")
	erb :edit_page
end

post '/delete' do
	phonebook = db.exec("Select * From phonebook")
    deleted = params[:user_delete]    
    db.exec("DELETE FROM phonebook WHERE phone_number = '#{deleted}'");
    redirect '/phone_book'
end
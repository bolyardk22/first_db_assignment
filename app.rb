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
	erb :edit_select, locals: {phonebook: phonebook}
end

post '/edit' do
	edit_num = params[:edit_select_table_radio]
	redirect '/edit_info?edit_num=' + edit_num
end

get '/edit_info' do
	phonebook = db.exec("Select * From phonebook")
	edit_num = params[:edit_num]
	user_row = db.exec("SELECT * FROM phonebook WHERE phone_number = '#{edit_num}'")
	erb :edit_page, locals: {edit_num: edit_num, user_row: user_row, phonebook: phonebook}
end

post '/edited' do
	edit_num = params[:edit_num]
	phonebook = db.exec("Select * From phonebook")
	newfirst_name = params[:newfirst_name]
	newlast_name = params[:newlast_name]
	newstreet_address = params[:newstreet_address]
	newcity = params[:newcity]
	newstate = params[:newstate]
	newzip = params[:newzip]
	newphone_number = params[:newphone_number]
	newemail_address = params[:newemail_address]
	db.exec("UPDATE phonebook SET first_name = '#{newfirst_name}', last_name = '#{newlast_name}', street_address = '#{newstreet_address}', city = '#{newcity}', state = '#{newstate}', zip = '#{newzip}', phone_number = '#{newphone_number}', email_address = '#{newemail_address}' WHERE phone_number = '#{edit_num}'")
	redirect '/phone_book'
end

post '/deleted' do
	phonebook = db.exec("Select * From phonebook")
    edit_num = params[:edit_num]  
    db.exec("DELETE FROM phonebook WHERE phone_number = '#{edit_num}'");
    redirect '/phone_book'
end
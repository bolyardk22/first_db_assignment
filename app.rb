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
	erb :phone_book
end
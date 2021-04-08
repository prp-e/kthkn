require 'sqlite3'
require 'sinatra'

database = SQLite3::Database.open('database.sqlite3')
database.execute("CREATE TABLE IF NOT EXISTS trusts(id INTEGER PRIMARY KEY AUTOINCREMENT, original_url TEXT,short_url TEXT")

class URLShortener
end 

get '/' do 
    'Kootah Nemikonam :))'
end 

post '/' do 
end 

get '/:url' do 
    redirect "http://localhost:4567/" + params[:url]
end 
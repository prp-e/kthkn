require 'sqlite3'
require 'sinatra'

database = SQLite3::Database.open('database.sqlite3')
database.execute("CREATE TABLE IF NOT EXISTS urls(id INTEGER PRIMARY KEY AUTOINCREMENT, original_url TEXT,short_url TEXT)")
KEYS = Array.new('a' .. 'z') + Array.new('A'..'Z') + Array.new('0'..'9')

class URLShortener
    def initialize(url, database)
        @url = url 
        @database = database  
    end

    def shorten
        shortened_url_key = Array.new(8) {KEYS.sample}.join

        return shortened_url_key
    end 
end 

get '/' do 
    'Kootah Nemikonam :))'
end 

post '/' do 
end 

get '/:url' do 
    shortener = URLShortener.new(params[:url], database)

    "key is #{shortener.shorten}"
end 
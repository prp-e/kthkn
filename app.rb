require 'json'
require 'sqlite3'
require 'sinatra'

database = SQLite3::Database.open('database.sqlite3')
database.execute("CREATE TABLE IF NOT EXISTS urls(id INTEGER PRIMARY KEY AUTOINCREMENT, original_url TEXT,short_url TEXT)")
KEYS = Array('a' .. 'z') + Array('A'..'Z') + Array('0'..'9')

class URLShortener
    def initialize(url, database)
        @url = url 
        @database = database  
    end

    def shorten
        if !@url.include?"http" 
            @url = "http://" + url 
        end 
        shortened_url_key = Array.new(8) {KEYS.sample}.join
        @database.execute("INSERT INTO urls (original_url, short_url) values (\"#{@url}\", \"#{shortened_url_key}\")")
        return shortened_url_key
    end 
end 

get '/' do 
    'Kootah Nemikonam :))'
end 

post '/' do 
    shortener = URLShortener.new(params[:url], database)
    shortened_key = shortener.shorten 

    {:original_url => "#{params[:url]}", :shortened_url => "http://localhost:4567/#{shortened_key}"}.to_json 
end 

get '/:url' do 
    query = "SELECT original_url FROM urls WHERE short_url=\"#{params[:url]}\""
    response = database.execute(query)
    response = response[0][0]
    
    redirect response
end 
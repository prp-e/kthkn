require 'json'
require 'sqlite3'
require 'sinatra'

database = SQLite3::Database.open(ENV['kthkn_db'])
database.execute("CREATE TABLE IF NOT EXISTS urls(id INTEGER PRIMARY KEY AUTOINCREMENT, original_url TEXT,short_url TEXT)")
KEYS = Array('a' .. 'z') + Array('A'..'Z') + Array('0'..'9')

class URLShortener
    def initialize(url, database)
        @url = url 
        @database = database  
    end

    def shorten
        if !@url.include?"http" 
            @url = "http://" + @url 
        end 
        shortened_url_key = Array.new(8) {KEYS.sample}.join
        @database.execute("INSERT INTO urls (original_url, short_url) values (\"#{@url}\", \"#{shortened_url_key}\")")
        return shortened_url_key
    end 
end 

set :bind, '0.0.0.0' 
set :public_folder, 'public' 
set :protection, except: :frame_options
set :protection, except: :json_csrf

before do 
    @req_data = request.body.read.to_s
end   

get '/' do 
    'Kootah Nemikonam :))'
end 

post '/' do 
    content_type :json 
    request = JSON.parse(@req_data)
    url = request['url']
    shortener = URLShortener.new(url, database)
    shortened_key = shortener.shorten 

    {:original_url => "#{url}", :shortened_url => "#{ENV['kthkn_domain']}/#{shortened_key}"}.to_json 
end 

get '/:url' do 
    query = "SELECT original_url FROM urls WHERE short_url=\"#{params[:url]}\""
    response = database.execute(query)
    response = response[0][0]
    
    redirect response
end 
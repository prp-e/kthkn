require 'sqlite3'
require 'sinatra'

get '/' do 
    'Kootah Nemikonam :))'
end 

post '/' do 
end 

get '/:url' do 
    redirect "http://localhost:4567/" + params[:url]
end 
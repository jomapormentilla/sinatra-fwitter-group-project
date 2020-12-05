require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'

    enable :sessions
    set :session_secret, 'fwitter_app'
  end

  get '/' do
    if session[:user_id]
      redirect '/tweets'
    end
    
    erb :login  
  end

  get '/login' do
    if session[:user_id]
      redirect '/tweets'
    end

    erb :login
  end

  post '/login' do
    user = User.find_by_username(params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    end

    flash[:message] = "Invalid Credentials"
    flash[:alert_type] = "warning"
    redirect '/login'
  end

  get '/signup' do

    if session[:user_id] != nil
      redirect "/tweets"
    else
      erb :signup
    end
  end

  post '/signup' do
    # user = User.find_by_username(params[:user][:username])

    # if user != nil
    #   flash[:message] = "This user already exists."
    #   flash[:alert_type] = "danger"

    #   redirect '/signup'
    # end

    if params.values.include?("")
      flash[:message] = "All fields are required."
      flash[:alert_type] = "danger"

      redirect '/signup'
    end

    # if params[:user][:username].split("").any?{ |char| /\W/ =~ char }
    #   flash[:message] = "Invalid Characters in Username."
    #   flash[:alert_type] = "danger"

    #   redirect '/signup'
    # end

    # if params[:user][:password] != params[:confirm]
    #   flash[:message] = "Confirm Password does not match."
    #   flash[:alert_type] = "warning"

    #   redirect '/signup'
    # end

    user = User.create(params)
    session[:user_id] = user.id

    redirect "/tweets"
  end

  get '/logout' do
    if session[:user_id]
      session.clear
    end
    redirect '/login'
  end

end

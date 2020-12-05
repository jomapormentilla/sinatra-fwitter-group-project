class TweetsController < ApplicationController
    get '/tweets' do
        if !session[:user_id]
            redirect '/login'
        end

        @user = User.find_by_id(session[:user_id])
        @tweets = Tweet.all
        erb :'tweets/index'
    end

    get '/tweets/new' do
        if !session[:user_id]
            redirect '/login'
        end

        erb :'tweets/new'
    end

    get '/tweets/:id' do
        if !session[:user_id]
            redirect '/login'
        end

        @tweet = Tweet.find_by_id(params[:id])
        erb :'tweets/show'
    end

    post '/tweets' do
        user = User.find_by_id(session[:user_id])

        if params[:content] == ""
            flash[:message] = "Tweet cannot be blank."
            flash[:alert_type] = "warning"

            redirect '/tweets/new'
        end

        user.tweets.create(content: params[:content])
    end

    get '/tweets/:id/edit' do
        if !session[:user_id]
            redirect '/login'
        end

        @tweet = Tweet.find_by_id(params[:id])
        erb :'tweets/edit'
    end

    patch '/tweets/:id' do
        tweet = Tweet.find_by_id(params[:id])

        if params[:content] == ""
            redirect "/tweets/#{ tweet.id }/edit"
        end

        if tweet.user_id == session[:user_id]
            tweet.update(content: params[:content])
        end

        redirect "tweets/#{ tweet.id }"
    end

    delete '/tweets/:id' do
        tweet = Tweet.find_by_id(params[:id])

        if tweet.user_id == session[:user_id]
            tweet.delete
        end

        redirect '/tweets'
    end
end

# -*- coding: utf-8 -*-

require 'sinatra/base'
require 'sinatra/assetpack'
require 'data_mapper'
require_relative 'models'

class Picus < Sinatra::Base

  enable :sessions
  set :root, File.dirname(__FILE__)
  register Sinatra::AssetPack

  helpers do  
    include Rack::Utils  
    alias_method :h, :escape_html  
  end  

  assets do

    js :main, [
       '/js/*.js'
    ]

    css :picus, [
      '/css/*.css'
    ]
    
    prebuild true
  end

  before /\/(flyports_project|register_new_project|project_create|flyport_project)/ do
    if session[:user] == nil and session[:apikey] == nil
      redirect '/'
    end
  end

  get '/' do
    
    erb :index
    
    
  end


  post '/remote_update' do

    @user = User.first(:user => params[:user], :password => Digest::MD5.hexdigest(params[:password]))
    params.delete("user")
    params.delete("password");
    if(@user != nil)
      
      project = params[:project]
      apikey = params[:apikey]
      params.delete("project")
      params.delete("apikey")

      params.each do |key,value|
        data = Datum.first(:apikey => apikey, :project_name => project, :name => key)
        data.update(:value => (h value))
      end
      "OK"      
    else
      "BAD AUTH"
    end
  end
  get '/flyports_project' do
    @projects = Flyport.all(:apikey => session[:apikey])

    erb :flyports_project
  end

  get '/flyport_project' do

    
    @data = Datum.all({:apikey => session[:apikey], :project_name => params[:project_name]})
    
    if(params[:project_name] == "Greenhouse")
      erb :greenhouse
    elsif(params[:project_name] == "Everpicus")
      erb :everpicus
    end
  end

  
  get '/register_new_project' do
    erb :register_new_project

  end

  get '/project_create' do


    if Flyport.first(:apikey => session[:apikey], :project_name => params[:project]) == nil
      if(params[:project] == "Greenhouse")
        Flyport.create(:apikey => session[:apikey], :project_name => "Greenhouse")
        Datum.create(:apikey => session[:apikey], :project_name => "Greenhouse", :value => "0", :name =>"humidity", :last_access =>Time.now)
        Datum.create(:apikey => session[:apikey], :project_name => "Greenhouse", :value => "0", :name =>"temperature", :last_access =>Time.now)
        Datum.create(:apikey => session[:apikey], :project_name => "Greenhouse", :value => "0", :name =>"brightness", :last_access =>Time.now)
      elsif(params[:project] == "Everpicus")
        Flyport.create(:apikey => session[:apikey], :project_name => "Everpicus")
        Datum.create(:apikey => session[:apikey], :project_name => "Everpicus", :value => "", :name =>"image", :last_access =>Time.now)
        Datum.create(:apikey => session[:apikey], :project_name => "Everpicus", :value => "0", :name =>"token", :last_access =>Time.now)
      end
      redirect '/flyports_project'
    else
      @user_error ="You have already created this project"
      erb :register_new_project
    end
  end

  
  get '/logout' do
    
    session[:user] = nil
    session[:apikey] = nil
    redirect '/'

  end

  get '/help' do

    erb :help
  end

  get '/user/access' do

    @user = User.first(:user => params[:user], :password => Digest::MD5.hexdigest(params[:passwd]))
      
    if @user != nil
      session[:user] = @user.user
      session[:apikey] = @user.apikey
      redirect :flyports_project
    else
      @user_error ="Username or password are wrong"
      erb :index
      
    end
  end

  get '/user/register' do
    erb :register
  end

  post '/user/register_account' do
    begin
      User.create(:user => params[:user],:password=> Digest::MD5.hexdigest(params[:passwd]), :email => params[:email], :apikey => Digest::MD5.hexdigest(params[:passwd]).slice(0,25))
      @new_user = true
      erb :index
      
    rescue StandardError => e
      e.to_s
    end
  end

end

if __FILE__ == $0
  Picus.run!
end


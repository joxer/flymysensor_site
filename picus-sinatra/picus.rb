# -*- coding: utf-8 -*-

require 'sinatra/base'
require 'sinatra/assetpack'
require 'data_mapper'
require "base64"
require_relative 'models'
require_relative 'evernote_config'
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

      if project == "everpicus"
        image = ""
        if params.length == 1
        
        
          0.upto(params[:image].length/2-1) do |i|
            
            image << [(params[:image][i*2]+params[:image][i*2+1]).hex].pack( "c")
          end

        elsif params.length > 1
          params[:image] = params[:image][0..-3]
          0.upto(params[:image].length/2-1) do |i|
            image << [(params[:image][i*2]+params[:image][i*2+1]).hex].pack( "c")
          end
          
          params.delete("image")
          
          params.each do |key,value|
            timage = key[2..-3]
            0.upto(timage.length/2-1) do |i|
              image << [(timage[i*2]+timage[i*2+1]).hex].pack( "c")
            end
          end
        end
        
        p image

        data = Datum.first(:flyport_user_apikey => apikey, :flyport_project_name => "Everpicus", :name => "image")
        data.update(:value => Base64.encode64(image).gsub("\n",""))
        
        edamurl = Datum.first(:flyport_user_apikey => apikey, :flyport_project_name => project, :name => "notestoreurl").value
        access = Datum.first(:flyport_user_apikey => apikey, :flyport_project_name => project, :name => "oauth_token").value
        
        Thread.new do
          
          noteStoreTransport = Thrift::HTTPClientTransport.new(edamurl)
          noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
          noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)
          notebooks = noteStore.listNotebooks(access)
          
          note = Evernote::EDAM::Type::Note.new
          note.title = "New image note from flyport"
          
          hashFunc = Digest::MD5.new
          
          data = Evernote::EDAM::Type::Data.new
          data.size = image.size
          data.bodyHash = hashFunc.digest(image)
          data.body = image
          
          
          resource = Evernote::EDAM::Type::Resource.new
          resource.mime = "image/jpeg"
          resource.data = data
          resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
          resource.attributes.fileName = "flyportimage.jpeg"
          
          note.resources = [resource]
          
          hashHex = hashFunc.hexdigest(image)
          note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Here is the Evernote logo:<br/>
<en-media type="image/png" hash="#{hashHex}"/>
</en-note>
EOF
          createdNote = noteStore.createNote(access, note)
          puts "Successfully created a new note with GUID: #{createdNote.guid}"
        end
      else
        params.each do |key,value|
          data = Datum.first(:flyport_user_apikey => apikey, :flyport_project_name => project, :name => key)
          data.update(:value => (h value))
        end
      end
      "OK"      
    else
      "BAD AUTH"
    end
  end
  get '/flyports_project' do
    @projects = Flyport.all(:user_apikey => session[:apikey])

    erb :flyports_project
  end

  get '/flyport_project' do

    
    @data = Datum.all({:flyport_user_apikey => session[:apikey], :flyport_project_name => params[:project_name]})
    
    if(params[:project_name] == "Greenhouse")
      erb :greenhouse
    elsif(params[:project_name] == "Everpicus")
      @object_login = Datum.first(:flyport_user_apikey => session[:apikey], :flyport_project_name => "Everpicus", :name => "notestoreurl")
      @object_image = Datum.first(:flyport_user_apikey => session[:apikey], :flyport_project_name => "Everpicus", :name => "image")

      erb :everpicus
    end
  end

  get '/get_image_everpicus' do
    
    @user = User.first(:user => params[:user])
    if( @user != nil )
      @object_image = Datum.first(:flyport_user_apikey => @user.apikey, :flyport_project_name => "Everpicus", :name => "image")
      if( @object_image != nil )
        content_type 'image/jpeg'
        Base64.decode64(@object_image.value)
      end
    end
  end

  
  get '/register_new_project' do
    erb :register_new_project

  end

  get '/project_create' do


    if Flyport.first(:user_apikey => session[:apikey], :project_name => params[:project]) == nil
      if(params[:project] == "Greenhouse")
        Flyport.create(:user_apikey => session[:apikey], :project_name => "Greenhouse")
        Datum.create(:flyport_user_apikey => session[:apikey], :flyport_project_name => "Greenhouse", :value => "0", :name =>"humidity", :last_access =>DateTime.now)
        Datum.create(:flyport_user_apikey => session[:apikey], :flyport_project_name => "Greenhouse", :value => "0", :name =>"temperature", :last_access =>DateTime.now)
        Datum.create(:flyport_user_apikey => session[:apikey], :flyport_project_name => "Greenhouse", :value => "0", :name =>"brightness", :last_access =>DateTime.now)
      elsif(params[:project] == "Everpicus")
        Flyport.create(:user_apikey => session[:apikey], :project_name => "Everpicus")
        Datum.create(:flyport_user_apikey => session[:apikey], :flyport_project_name => "Everpicus", :value => "", :name =>"image", :last_access =>DateTime.now)
        Datum.create(:flyport_user_apikey => session[:apikey],:flyport_project_name => "Everpicus", :value=> "",:name => "notestoreurl", :last_access=>DateTime.now)
        Datum.create(:flyport_user_apikey => session[:apikey], :flyport_project_name => "Everpicus", :value => "", :name =>"oauth_token", :last_access =>DateTime.now)
      end
      redirect '/flyports_project'
    else
      @error ="You have already created this project"
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
      @error ="Username or password are wrong"
      erb :index
      
    end
  end

  get '/user/register' do
    erb :register
  end

  post '/user/register_account' do
    begin

      if(User.all(:user => params[:user]) != [])
        @error = "User is already registered"
        erb :register
      else
        if(!validate_email(params[:email]))
           @error = "Please insert a valid email"
           erb :register

         else
           User.create(:user => params[:user],:password=> Digest::MD5.hexdigest(params[:passwd]), :email => params[:email], :apikey => Digest::MD5.hexdigest(params[:passwd]).slice(0,25))
           @notice = "do your first login"
           erb :index
         end           
      end
    rescue StandardError => e
      e.to_s
    end
  end
  
  get '/evernote/authorize' do
    
    callback_url = request.url.chomp("authorize").concat("callback")
    
    begin
      consumer = OAuth::Consumer.new(OAUTH_CONSUMER_KEY, OAUTH_CONSUMER_SECRET,{
                                       :site => EVERNOTE_SERVER,
                                       :request_token_path => "/oauth",
                                       :access_token_path => "/oauth",
                                       :authorize_path => "/OAuth.action"})
      session[:request_token] = consumer.get_request_token(:oauth_callback => callback_url)
      redirect session[:request_token].authorize_url
    rescue => e
      "Error obtaining temporary credentials: #{e.message}"
      
    end
  end
  get '/evernote/callback' do
    if params['oauth_verifier']
      oauth_verifier = params['oauth_verifier']
      begin
        access_token = session[:request_token].get_access_token(:oauth_verifier => oauth_verifier)
        @token = access_token.token
        with_dm_logger do
          Datum.first(:flyport_user_apikey => session[:apikey], :flyport_project_name => "Everpicus", :name => "notestoreurl").update(:value => access_token.params['edam_noteStoreUrl'])
          adapter = DataMapper.repository(:default).adapter
          adapter.execute("UPDATE `data` SET `value` = '#{@token}' WHERE `data`.`flyport_user_apikey` = '#{session['apikey']}' AND `data`.`flyport_project_name` = 'Everpicus' AND `data`.`name` = 'oauth_token'")
           redirect "/flyport_project?project_name=Everpicus"
        end
      rescue StandardError => e
        e.to_s
      end
    end
  end
end
if __FILE__ == $0
  Picus.run!
end


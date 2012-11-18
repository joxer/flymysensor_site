require 'rubygems'
require 'data_mapper'

DataMapper.setup(:default, 'mysql://root:joxer@localhost/picus')




class User
  include DataMapper::Resource
  property :user, String, :key => true
  property :email, String
  property :password, String
  property :apikey, Text
  
  has n, :flyports, :parent_key => [:apikey], :child_key => [:apikey]
end

class Flyport
  include DataMapper::Resource

  belongs_to :user,  :parent_key =>[:apikey], :child_key => [:apikey]

  property :apikey, Text, :key => true
  property :project_name, String, :key => true
  
  has n, :data, :parent_key => [:apikey, :project_name], :child_key => [:apikey, :project_name]
end

class Datum
  include DataMapper::Resource
  belongs_to :flyport, :parent_key =>[:apikey], :child_key => [:apikey, :project_name]
  property :apikey, Text, :key  => true
  property :project_name, String, :key => true
  property :name, String,  :key => true
  property :value, String
  property :last_access, Date
end

DataMapper.finalize


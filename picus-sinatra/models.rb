require 'rubygems'
require 'data_mapper'


DataMapper::Logger.new($stdout, :fatal)
DataMapper.setup(:default, 'mysql://root:root@localhost/picus')
def with_dm_logger(level = :debug)
  DataMapper.logger.level = DataMapper::Logger::Levels[level]
  yield
ensure
  DataMapper.logger.level = DataMapper::Logger::Levels[:fatal]
end

=begin

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

#Datum.raise_on_save_failure = true

DataMapper.finalize

=end

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, 'mysql://root:root@localhost/picus')


class User
  include DataMapper::Resource
  property :user, String, :unique => true
  property :email, String
  property :password, String
  property :apikey, String, :key => true
  
  has n, :flyports#, :child_key => [:apikey]
end

class Flyport
  include DataMapper::Resource

   belongs_to :user,:key => true#, :child_key => [:user_apikey]
#  property :apikey, String, :key => true
  property :project_name, String, :key => true
  
  has n, :data, :parent_key => [:project_name, :user_apikey]
end

class Datum
  include DataMapper::Resource
 belongs_to :flyport, :parent_key => [:project_name, :user_apikey]#, :parent_key =>[:apikey], :child_key => [:apikey, :project_name]
#  property :apikey, String, :key  => true
#  property :project_name, String, :key => true
  property :name, String,  :key => true
  property :value, Text
  property :last_access, Date
end


DataMapper.finalize

if __FILE__ == $0
DataMapper.auto_migrate!
end


def validate_email(email)

regex = Regexp.new("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
if regex.match(email) != nil
 return true
else
 return false
end
end


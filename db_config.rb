require 'active_record'


options = {
  adapter: 'postgresql',
  database: 'shakespeare'
}


ActiveRecord::Base.establish_connection(options)

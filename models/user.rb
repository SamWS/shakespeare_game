class User < ActiveRecord::Base
  ##### activerecord has the password digesting function
  has_secure_password
  ##### identifies the relationship
end

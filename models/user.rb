class User < ActiveRecord::Base
  ##### activerecord has the password digesting function
  has_secure_password
  ##### identifies the relationship

  class << self

    def logged_in?(session)
      if User.find_by(id: session[:id])
        return true
      else
        return false
      end
    end

    def current_user(session)
      User.find(session[:id])
    end
  end

end

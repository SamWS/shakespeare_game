require 'pry'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)


require_relative 'db_config'

require_relative 'models/quote'
require_relative 'models/play'
require_relative 'models/user'

binding.pry

# Here goes your database connection and options:

require_relative "../lib/iron_heel"
require "iron_heel/db"
DB=IronHeel.db
require_relative "./recording"
require_relative "./spoof"
require_relative "./user"
require_relative "./extension"
require_relative "./exclusion"
# adapter: postgresql
# database: ironheel 
# username: ironheel 
# password: heel!iron! 
# host: dougie


# Here go your requires for models:
# require 'model/user'

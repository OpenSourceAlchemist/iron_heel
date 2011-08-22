require "iron_heel"
module IronHeel
  class Extension < Sequel::Model
    set_dataset IronHeel.db[:extensions]
    many_to_many :users, :join_table => :users_extensions
  end
end

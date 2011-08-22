require "iron_heel"
module IronHeel
  class Exclusion < Sequel::Model
    set_dataset IronHeel.db[:exclusions]
    many_to_many :users, :join_table => :users_extensions
  end
end

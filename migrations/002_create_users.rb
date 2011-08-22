# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
Class.new Sequel::Migration do
  def up
    create_table(:users) do
      primary_key :id
      String :username, :null => false
      String :password
    end unless IronHeel.db.tables.include? :users
  end

  def down
    remove_table(:users) if IronHeel.db.tables.include? :users
  end
end

# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
Class.new Sequel::Migration do
  def up
    create_table(:spoofs) do
      primary_key :id
      String :extension, :null => false
      String :matcher
    end unless IronHeel.db.tables.include? :spoofs
  end

  def down
    remove_table(:spoofs) if IronHeel.db.tables.include? :spoofs
  end
end

# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
Class.new Sequel::Migration do
  def up
    create_table(:exclusions) do
      primary_key :id
      String :extension, :null => false
    end unless IronHeel.db.tables.include? :exclusions
  end

  def down
    remove_table(:exclusions) if IronHeel.db.tables.include? :exclusions
  end
end

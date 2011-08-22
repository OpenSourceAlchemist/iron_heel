# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
Class.new Sequel::Migration do
  def up
    create_table(:users_extensions) do
      primary_key :id
      foreign_key :user_id, :users, :on_delete => :cascade
      foreign_key :extension_id, :extensions, :on_delete => :cascade
    end unless IronHeel.db.tables.include? :users_extensions
  end

  def down
    remove_table(:users_extensions) if IronHeel.db.tables.include? :users_extensions
  end
end

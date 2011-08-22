Class.new  Sequel::Migration do
  def up
    create_table :recordings do
      primary_key :id
      String :src
      String :dst
      String :direction
      DateTime :timestamp
      String :server
      String :path
      String :filename
      Integer :level
      TrueClass :lost
      String :account_id
      String :iat_account_id
      DateTime :created_at
      DateTime :updated_at
    end unless IronHeel.db.tables.include? :recordings
  end

  def down
    remove_table(:recordings) if IronHeel.db.tables.include? :recordings
  end
end

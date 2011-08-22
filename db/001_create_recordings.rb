Class.new Sequel::Migration do
  def up
    create_table :recordings do
      primary_key :id
      String :src
      String :dst
      String :direction
      DateTime :timestamp
      String :path
      String :filename
      String :server
      Integer :level

    end unless DB.tables.include? :recordings
  end

  def down
    drop_table :recordings if DB.tables.include? :recordings
  end
end

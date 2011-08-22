class CreateRecordings < ActiveRecord::Migration
  def self.up
    create_table :recordings do |t|
      t.string :src
      t.string :dst
      t.string :direction
      t.datetime :timestamp
      t.string :server
      t.string :path
      t.string :filename
      t.string :server
      t.integer :level

      t.timestamps
    end
  end

  def self.down
    drop_table :recordings
  end
end

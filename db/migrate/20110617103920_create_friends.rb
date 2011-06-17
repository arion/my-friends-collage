class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.integer :user_id
      t.string :uid
      t.string :name
      t.string :photo_url
      t.string :provider
      t.text :other_info

      t.timestamps
    end
  end

  def self.down
    drop_table :friends
  end
end

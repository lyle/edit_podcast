class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.column "show_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
      t.column "role", :string, :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_at", :datetime, :null => false
    end
    drop_table "shows_users"
  end

  def self.down
    drop_table :participants
    create_table "shows_users", :id => false, :force => true do |t|
      t.column "show_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
      t.column "role", :string, :limit => 64
    end
  end
end

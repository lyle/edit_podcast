class ShowParticipation < ActiveRecord::Migration
  def self.up
    create_table "shows_users", :id => false, :force => true do |t|
      t.column "show_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
      t.column "role", :string, :limit => 64
    end
  end

  def self.down
    drop_table "shows_users"
  end
end

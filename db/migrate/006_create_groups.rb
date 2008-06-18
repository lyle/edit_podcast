class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups, :force => true do |t|
      t.column :name, :string, :limit => 64, :null => false
      t.column :description, :text
      t.column :created_on, :datetime, :null => false
      t.column :updated_on, :datetime, :null => false
    end
    create_table :groups_users, :id => false, :force => true do |t|
      t.column :group_id, :integer
      t.column :user_id, :integer
      t.column :created_on, :datetime
    end
    #make the Geeks and Admin groups and assign user lyle to them.
    Group.create :name => "Geeks", :description => "The Geeks of GeekSpeak"
    Group.find_by_name("Geeks").users<<(User.find_by_login('lyle'))
    Group.create :name => "Admin", :description => "The Administrators of GeekSpeak"
    Group.find_by_name("Admin").users<<(User.find_by_login('lyle'))
  end

  def self.down
    drop_table :groups
    drop_table :groups_users
  end
end

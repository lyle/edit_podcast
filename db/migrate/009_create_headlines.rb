class CreateHeadlines < ActiveRecord::Migration
  def self.up
    create_table :headlines do |t|
      t.column "user_id", :integer, :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_at", :datetime, :null => false
      t.column "title", :string, :limit => 64, :null => false
      t.column "content", :text
      t.column "status", :string, :limit => 64, :default => "new"
    end
    create_table :headline_discussions do |t|
      t.column "show_id", :integer, :null => false
      t.column "headline_id", :integer, :null => false
      t.column "position", :integer, :null => false
    end
  end

  def self.down
    drop_table :headlines
    drop_table :headline_discussion
  end
end
class CreateContributors < ActiveRecord::Migration
  def self.up
    create_table :contributors do |t|
      t.column "article_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
      t.column "role", :string, :null => false
      t.column "created_at", :datetime, :null => false
      t.column "updated_at", :datetime, :null => false
    end
  end

  def self.down
    drop_table :contributors
  end
end

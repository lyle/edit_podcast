class InitialSchema < ActiveRecord::Migration
  def self.up
  
  create_table "answers", :force => true do |t|
    t.column "question_id", :integer, :null => false
    t.column "content", :text, :null => false
    t.column "user_id", :integer, :null => false
    t.column "created_on", :datetime, :null => false
    t.column "updated_on", :datetime, :null => false
  end

  create_table "articles", :force => true do |t|
    t.column "user_id", :integer, :null => false
    t.column "category", :string, :limit => 128
    t.column "title", :string, :limit => 64, :null => false
    t.column "subtitle", :string, :limit => 64
    t.column "abstract", :string, :limit => 1024, :null => false
    t.column "publishdate", :datetime
    t.column "content", :text
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
    t.column "lock_version", :integer, :default => 0
    t.column "publishid", :integer
    t.column "teaser_id", :integer
    t.column "status", :string, :limit => 64, :default => "new"
  end

  create_table "articles_images", :id => false, :force => true do |t|
    t.column "article_id", :integer
    t.column "image_id", :integer
  end

  create_table "images", :force => true do |t|
    t.column "name", :string, :limit => 64
    t.column "mimetype", :string, :limit => 64
    t.column "height", :integer
    t.column "width", :integer
    t.column "data", :binary
    t.column "user_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  create_table "images_shows", :id => false, :force => true do |t|
    t.column "image_id", :integer, :null => false
    t.column "show_id", :integer, :null => false
  end

  create_table "questions", :force => true do |t|
    t.column "title", :string, :limit => 64, :null => false
    t.column "content", :text, :null => false
    t.column "person_name", :string, :limit => 64, :null => false
    t.column "location", :string, :limit => 64, :null => false
    t.column "user_id", :integer, :null => false
    t.column "created_on", :datetime, :null => false
    t.column "updated_on", :datetime, :null => false
    t.column "person_email", :string, :limit => 254
    t.column "status", :string, :limit => 64, :default => "new"
  end

  create_table "questions_shows", :id => false, :force => true do |t|
    t.column "question_id", :integer
    t.column "show_id", :integer
  end

  create_table "shows", :force => true do |t|
    t.column "title", :string, :limit => 64, :null => false
    t.column "category", :string, :limit => 254
    t.column "promo", :text
    t.column "abstract", :text, :null => false
    t.column "content", :text
    t.column "user_id", :integer, :null => false
    t.column "created_on", :datetime, :null => false
    t.column "updated_on", :datetime, :null => false
    t.column "status", :string, :limit => 64, :default => "new"
    t.column "showtime", :datetime
    t.column "teaser_id", :integer
    t.column "planning_notes", :text
  end

  create_table "users", :force => true do |t|
    t.column "login", :string, :limit => 80
    t.column "password", :string, :limit => nil
    t.column "display_name", :string, :limit => 64
    t.column "email", :string, :limit => 128
  end
  end

  def self.down
    drop_table "answers"
    drop_table "articles"
    drop_table "articles_images"
    drop_table "groups"
    drop_table "groups_users"
    drop_table "images"
    drop_table "images_shows"
    drop_table "questions"
    drop_table "questions_shows"
    drop_table "shows"
    drop_table "users"
  end
end

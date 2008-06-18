class AddUrlToHeadlines < ActiveRecord::Migration
  def self.up
    add_column("headlines", "url",  :string, :limit => 256  )
  end

  def self.down
    remove_column("headlines", "url")
  end
end

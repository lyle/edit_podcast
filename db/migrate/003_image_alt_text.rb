class ImageAltText < ActiveRecord::Migration
  def self.up
    add_column("images", "alternative_text",  :string, :limit => 64 )
  end

  def self.down
    remove_column("images", "alternative_text")
  end
end

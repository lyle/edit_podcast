class ModifyArticlesAddSlug < ActiveRecord::Migration

  # We decided that public article ids are kinda lame. So we are going to use a unique name
  # The Slug will be used as a unique name for the article and will normally be
  # the title modified to make it safe example: "segate_harddrive_80gb_scsi
  def self.up
    add_column("articles", "slug",  :string, :limit => 64 )
    remove_column("articles", "publishid")
  end

  def self.down
    remove_column("articles", "slug",  :string, :limit => 64 )
    add_column("articles", "publishid")
  end
end

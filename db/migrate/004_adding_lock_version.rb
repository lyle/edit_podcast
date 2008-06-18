class AddingLockVersion < ActiveRecord::Migration
  def self.up
    add_column("shows", "lock_version",  :integer, :default => 0  )
    execute "UPDATE shows SET lock_version = 0;"
  end

  def self.down
    remove_column("shows", "lock_version")
  end
end

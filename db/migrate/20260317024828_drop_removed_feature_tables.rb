class DropRemovedFeatureTables < ActiveRecord::Migration[8.0]
  def up
    drop_table :plugins, if_exists: true
    drop_table :plugin_window_details, if_exists: true
    drop_table :twitter_accounts, if_exists: true
    drop_table :tweetcontrols, if_exists: true
  end

  def down
    # These tables belonged to removed features (plugins, twitter).
    # They are not recreated on rollback.
  end
end

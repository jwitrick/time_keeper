class Teams < ActiveRecord::Migration
  def self.up
        create_table :teams do |t|
                t.column :name, :string, :limit => 30
		t.column :owner_id, :integer, :null => false
        end
  end

  def self.down
        drop_table :projects
  end
end

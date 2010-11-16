class Projects < ActiveRecord::Migration
  def self.up
        create_table :projects do |t|
                t.column :name, :string, :limit => 20, :null => false
                t.column :description, :text
                t.column :owner_id, :integer
		t.column :active, :boolean, :default => 1
		t.column :chartered, :boolean, :null => false
		t.column :team_id, :integer
        end
  end

  def self.down
        drop_tables :projects
  end
end

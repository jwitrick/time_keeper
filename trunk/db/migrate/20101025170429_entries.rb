class Entries < ActiveRecord::Migration
  def self.up
        create_table :entries do |t|
                t.column :name, :string, :limit => 30, :null => false
                t.column :project_id, :integer
                t.column :duration, :float
                t.column :description, :text
                t.column :user_id, :integer
                t.column :created_at, :timestamp
		t.column :work_type, :string
        end
  end

  def self.down
  end
end

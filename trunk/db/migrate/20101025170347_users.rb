class Users < ActiveRecord::Migration
  def self.up 
        create_table :users do |t| 
                t.column :first_name, :string, :limit => 20, :null => false 
                t.column :last_name, :string, :limit => 20, :null => false 
                t.column :username, :string, :limit => 10, :null => false
		t.column :password, :string, :null => false 
                t.column :email, :string, :null => false 
                t.column :active, :boolean, :default => 1 
                t.column :team_id, :integer
		t.column :isAdmin, :boolean, :default => 0
		t.column :isManager, :boolean, :default => 0
        end 
  end 
 
  def self.down 
        drop_tables :users 
  end
end

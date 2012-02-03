class AddUserInfo < ActiveRecord::Migration
  def up
  	add_column :users, :first_name, :string
  	add_column :users, :patronomic, :string
  	add_column :users, :last_name, :string
  	add_column :users, :position, :string
		add_column :users, :extension_number, :string
		add_column :users, :cell_phone, :string
		add_column :users, :icq, :string
		add_column :users, :skype, :string
		add_column :users, :city, :string
		add_column :users, :comment, :text
  end

  def down
  	remove_column :users, :first_name, :string
  	remove_column :users, :patronomic, :string
  	remove_column :users, :last_name, :string
  	remove_column :users, :position, :string
		remove_column :users, :extension_number, :string
		remove_column :users, :cell_phone, :string
		remove_column :users, :icq, :string
		remove_column :users, :skype, :string
		remove_column :users, :city, :string
		remove_column :users, :comment, :text
  end
end

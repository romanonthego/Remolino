class CreateDeputies < ActiveRecord::Migration
  def change
    create_table :deputies do |t|
    	t.integer :appointive_id
    	t.integer :sub_id
    	t.boolean :is_active, :default => false
      t.timestamps
    end
  end
end

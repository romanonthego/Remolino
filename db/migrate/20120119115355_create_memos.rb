class CreateMemos < ActiveRecord::Migration
  def change
    create_table :memos do |t|
    	t.string   "name"
    	t.text     "description"
      t.timestamps
    end
  end
end

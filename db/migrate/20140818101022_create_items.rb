class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :price
      t.string :category

      t.timestamps
    end
    add_index :items, :name, unique: true
    add_index :items, :category
  end
end

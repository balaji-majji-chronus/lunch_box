class CreateOrderedItems < ActiveRecord::Migration
  def change
    create_table :ordered_items do |t|
      t.integer :order_id
      t.integer :item_id

      t.timestamps
    end
    add_index :ordered_items, :order_id
  end
end

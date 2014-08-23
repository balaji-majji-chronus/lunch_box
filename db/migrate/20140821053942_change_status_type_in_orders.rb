class ChangeStatusTypeInOrders < ActiveRecord::Migration
  def up
  	change_column :orders, :status, 'tinyint(3)'
  end

  def down
  	change_column :orders, :status, :boolean
  end
end

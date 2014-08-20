class OrderedItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  validates :order_id, presence: true 
  validates :item_id, presence: true

  def OrderedItem.order_amount(oitems)
  	total = 0
  	oitems.each do |oitem|
  		total += Item.find(oitem.item_id).price
  	end
  	return total
  end
end

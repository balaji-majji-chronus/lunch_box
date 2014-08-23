class Item < ActiveRecord::Base

  before_save { self.name = name.downcase }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :price, presence: true, :numericality => true
  validates :category, presence: true


  # given items and quantity returns the total price, here price is current item price
  def Item.total_order_cost(items, quantities)
  	total = 0
  	items.each { |item| total += (quantities["#{item.id}"][:quantity].to_i) * item.price } 
  	return total
  end

end

class Item < ActiveRecord::Base

  before_save { self.name = name.downcase }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :price, presence: true, :numericality => true
  validates :category, presence: true

  def Item.total_price(items)
  	total = 0
  	items.each { |item| total += item.price } 
  	return total
  end

end

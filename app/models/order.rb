class Order < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  has_many :ordered_items, dependent: :destroy

  def orderedItems
  	ordered_items
  end

  def Order.todays_orders
  	Order.where("created_at > :ctime", {ctime: Date.today.beginning_of_day})
  end

  def Order.fresh_orders
  	Order.where("status in (:status, :status_val) and created_at > :ctime",{status: false, status_val: 0, ctime: Date.today.beginning_of_day})
  end

  def Order.inprogress_orders
  	Order.where("status = :status",{status: 1})
  end

  def Order.delivered_orders
  	Order.where("status = :status",{status: 2})
  end

  def Order.cancelled_orders
  	Order.where("status = :status",{status: 3})
  end

end

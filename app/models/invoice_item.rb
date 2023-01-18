class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  belongs_to :merchant, optional: true
  has_many :bulk_discounts, through: :item

  validates_presence_of :unit_price
  validates_presence_of :quantity


  enum status: ['pending', 'packaged', 'shipped']

  def qualified_discount
    self.bulk_discounts.where("quantity_threshold <= ?", self.quantity).order(quantity_threshold: :desc).limit(1)
  end

  def discounted_price
    if qualified_discount.any?
      percent = qualified_discount.first.percent_discount
      (1.0 - (percent / 100.0)) * unit_price
    else
      unit_price
    end
  end

  def total_item_discount
      discounted_price * quantity
  end
end

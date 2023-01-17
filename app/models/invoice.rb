class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :invoice_items

  enum status: ['in progress', 'completed', 'cancelled']

  def total_revenue
    self.invoice_items.sum("quantity * unit_price")
  end

  def discounted_revenue
      self.invoice_items.sum do |invoice_item|
        invoice_item.total_item_discount
      end
  end

  def self.invoice_items_not_shipped
    self.joins(:invoice_items)
        .where.not("invoice_items.status = ?", 2)
        .group(:id)
        .order(:created_at)
  end
end

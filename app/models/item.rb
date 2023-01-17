class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts, through: :merchant

  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price, only_integer: true
  
  enum status: [:disabled, :enabled]
  
  def invoice_date
    invoice_id = InvoiceItem.where(item_id:self.id).pluck(:invoice_id).first
    
    Invoice.where(id: invoice_id).first.created_at.strftime("%A, %B %d, %Y")
  end

  def top_selling_day
    self.invoice_items.joins(:invoice).select(Arel.sql("invoices.id, invoices.created_at"))
    .order(Arel.sql("invoice_items.unit_price * invoice_items.quantity  desc")).limit(1).first.created_at
  end
end

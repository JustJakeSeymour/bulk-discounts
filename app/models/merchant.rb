class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  has_many :bulk_discounts

  validates_presence_of :name
  
  enum status: [:disabled, :enabled]

  def self.top_five_by_revenue
    self.joins(:transactions).where(transactions:{result: 1})
        .select(Arel.sql("merchants.*, sum(invoice_items.quantity*invoice_items.unit_price) as total_revenue"))
        .group(:id).order("total_revenue desc").limit(5)
  end

  def total_revenue
    total = self.transactions.group(:id).where(transactions:{result: 1}).sum("invoice_items.quantity * invoice_items.unit_price")
    total.values.first
  end

  def best_day
    self.transactions.where(transactions:{result:1})
        .select(Arel.sql("invoices.id, invoice_items.id, invoices.created_at, 
          invoice_items.quantity, invoice_items.unit_price"))
        .order(Arel.sql("invoice_items.quantity * invoice_items.unit_price desc")).pluck("invoices.created_at").first
  end
  
  def top_customers
    self.customers
    .joins(:transactions)
    .where(transactions: {result: 1} )
    .select("customers.*, count(transactions.id) as successful_transactions")
    .group(:id).order("successful_transactions DESC").limit(5)
  end

  def ready_to_ship
    items.joins(:invoice_items)
    .select('items.*, invoice_items.invoice_id, invoice_items.status as invoice_item_status')
    .where('invoice_items.status = ?', 1)
    .order(:created_at)
  end

  def top_five_items_ordered
    self.items
        .joins(:transactions)
        .group(:id)
        .where(transactions: {result: "success"})
        .select("items.*, SUM(invoice_items.unit_price * invoice_items.quantity) as revenue")
        .order("revenue desc")
        .limit(5)
  end

  def items_ordered_by_most_recently_updated_at
    self.items.order(updated_at: :desc)
  end
end

class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  has_one :bulk_discount, through: :item

  enum status: ['pending', 'packaged', 'shipped']
end

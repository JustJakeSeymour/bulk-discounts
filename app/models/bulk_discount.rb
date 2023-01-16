class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  bas_many :invoice_items, through: :merchants
end

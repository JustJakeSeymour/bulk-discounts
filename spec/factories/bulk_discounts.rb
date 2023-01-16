FactoryBot.define do
  factory :bulk_discount do
    quantity_threshold { 1 }
    percent_discount { 1 }
    merchant { nil }
  end
end

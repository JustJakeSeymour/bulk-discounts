require 'rails_helper'

RSpec.describe 'The Merchant Invoices Index page', type: :feature do
  let!(:merchant1) { Merchant.create!(name: "Billy's Butters") }
  let!(:merchant2) { Merchant.create!(name: "Sandy's Sandwiches") }

  let!(:item1) { Item.create!(name: "Tissues", description: "Wipes Nose", unit_price: 1000, merchant: merchant1) }
  let!(:item2) { Item.create!(name: "Apples", description: "Delicious", unit_price: 1200, merchant: merchant1) }
  let!(:item3) { Item.create!(name: "Pizza", description: "Cheezy Delicious", unit_price: 1749, merchant: merchant1) }
  let!(:item4) { Item.create!(name: "Penguins", description: "Exotic pet", unit_price: 100005, merchant: merchant1) }

  let!(:invoice_item1) { InvoiceItem.create!(unit_price: 1000, item: item1, invoice: invoice1, status: 0, quantity: 1) }
  let!(:invoice_item2) { InvoiceItem.create!(unit_price: 1200, item: item2, invoice: invoice1, status: 1, quantity: 1) }
  let!(:invoice_item3) { InvoiceItem.create!(unit_price: 1749, item: item3, invoice: invoice2, status: 2, quantity: 1) }
  let!(:invoice_item4) { InvoiceItem.create!(unit_price: 100005, item: item4, invoice: invoice3, status: 1, quantity: 1) }

  let!(:customer1) {Customer.create!(first_name: "Bob", last_name: "Bobbert")}
  let!(:customer2) {Customer.create!(first_name: "Chad", last_name: "Chaddert")}

  let!(:invoice1) {customer1.invoices.create!(status: 0)}
  let!(:invoice2) {customer1.invoices.create!(status: 1)}
  let!(:invoice3) {customer2.invoices.create!(status: 2)}

  describe "When I visit the merchant invoice index page" do
    it "then I see all of the invoices that include at least one of my merchant's items" do
      visit merchant_invoices_path(merchant1.id)

      expect(page).to have_content("##{invoice1.id}")
      expect(page).to have_content("##{invoice2.id}")
    end

    it "for each invoice I see an id and each id links to a merchants invoice show page" do
      visit merchant_invoices_path(merchant1.id)

      click_link("#{invoice1.id}")
      expect(current_path).to eq(merchant_invoice_path(merchant1.id, invoice1.id))
    end


  end
end
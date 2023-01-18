require 'rails_helper'

RSpec.describe "Admin Invoices Index" do
  let!(:customer) {Customer.create!(first_name: "Bob", last_name: "Bobbert")}
  let!(:invoice1) {customer.invoices.create!(status: 0)}
  let!(:invoice2) {customer.invoices.create!(status: 0)}
  let!(:invoice3) {customer.invoices.create!(status: 0)}
  let!(:merchant1) {Merchant.create!(name: "Hockey Stop and Shop")}
  let!(:item1) {merchant1.items.create!(name: "Socks", description: "They're good socks.", unit_price: 1200)}
  let!(:invoice_item1) {InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, unit_price: 900, quantity: 3)}

  describe "User Story 32" do
    it "lists all invoice ids" do
      visit admin_invoices_path

      expect(page).to have_content("Invoice ##{invoice1.id}")
      expect(page).to have_content("Invoice ##{invoice3.id}")
      expect(page).to have_content("Invoice ##{invoice2.id}")
    end
    
    it "each id links to admin invoice show page" do
      visit admin_invoices_path
      
      click_link ("Invoice ##{invoice1.id}")
      expect(current_path).to eq(admin_invoice_path(invoice1.id))
    end
  end
end
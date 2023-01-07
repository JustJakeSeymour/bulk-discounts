require 'rails_helper'

RSpec.describe "Admin Invoices Show" do
  let!(:customer) {Customer.create!(first_name: "Bob", last_name: "Bobbert")}
  let!(:invoice1) {customer.invoices.create!(status: 0)}
  let!(:invoice2) {customer.invoices.create!(status: 0)}
  let!(:merchant1) {Merchant.create!(name: "Hockey Stop and Shop")}
  let!(:item1) {merchant1.items.create!(name: "Socks", description: "They're good socks.", unit_price: 1200)}
  let!(:invoice_item1) {InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 1200, status: 1)}

  describe "User Story 33" do
    it "lists specific invoice info" do
      visit admin_invoice_path(invoice1.id)

      expect(page).to have_content(invoice1.id)
      expect(page).to have_content(invoice1.status)
      expect(page).to have_content(invoice1.created_at.strftime("%A, %B %d, %Y"))
      expect(page).to have_content(customer.first_name)
      expect(page).to have_content(customer.last_name)
      expect(page).to_not have_content(invoice2.id)
    end
  end

  describe "User Story 34" do
    it "invoice item information" do
      visit admin_invoice_path(invoice1.id)

      expect(page).to have_content(invoice_item1.item.name)
      expect(page).to have_content(invoice_item1.quantity)
      expect(page).to have_content(invoice_item1.unit_price)
      expect(page).to have_content(invoice_item1.status)
    end
  end

  describe "User Story 35" do
    it "total revenue" do
      visit admin_invoice_path(invoice1.id)
      
      expect(page).to have_content(invoice1.total_revenue)
    end
  end

  describe "User Story 36" do
    it "update Invoice Status using selector" do
      visit admin_invoice_path(invoice1.id)

      expect(invoice1.status).to eq "in progress"

      within("#invoice_#{invoice1.id}_status") do
        has_field?("Status", with: invoice1.status)
        find(:select).find(:option, "completed").select_option
        expect(page).to have_button "Update Invoice Status"
        click_button("Update Invoice Status")
      end
        
      expect(current_path).to eq admin_invoice_path(invoice1.id)
      
      invoice1.reload
      expect(invoice1.status).to eq "completed"
    end
  end
end


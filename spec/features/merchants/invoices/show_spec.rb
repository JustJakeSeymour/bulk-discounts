require "rails_helper" 

RSpec.describe 'The Merchant Invoices Show page', type: :feature do
  let!(:merchant1) { Merchant.create!(name: "Billy's Butters") }
  let!(:merchant2) { Merchant.create!(name: "Sandy's Sandwiches") }

  let!(:item1) { Item.create!(name: "Tissues", description: "Wipes Nose", unit_price: 1000, merchant: merchant1) }
  let!(:item2) { Item.create!(name: "Apples", description: "Delicious", unit_price: 1200, merchant: merchant1) }
  let!(:item3) { Item.create!(name: "Pizza", description: "Cheezy Delicious", unit_price: 1749, merchant: merchant1) }
  let!(:item4) { Item.create!(name: "Penguins", description: "Exotic pet", unit_price: 100005, merchant: merchant1) }

  let!(:invoice_item1) { InvoiceItem.create!(quantity: 2, unit_price: 1000, item: item1, invoice: invoice1, status: 0) }
  let!(:invoice_item2) { InvoiceItem.create!(quantity: 6, unit_price: 1200, item: item2, invoice: invoice1, status: 1) }
  let!(:invoice_item3) { InvoiceItem.create!(quantity: 1, unit_price: 1749, item: item3, invoice: invoice2, status: 2) }
  let!(:invoice_item4) { InvoiceItem.create!(quantity: 2, unit_price: 100005, item: item4, invoice: invoice3, status: 1) }

  let!(:customer1) {Customer.create!(first_name: "Bob", last_name: "Bobbert")}
  let!(:customer2) {Customer.create!(first_name: "Chad", last_name: "Chaddert")}

  let!(:invoice1) {customer1.invoices.create!(status: 0)}
  let!(:invoice2) {customer1.invoices.create!(status: 1)}
  let!(:invoice3) {customer2.invoices.create!(status: 2)}

  describe "When I visit the merchants invoice show page" do
    it "shows information related to that invoice including :id, status, create_at, customer first and last name" do
      visit merchant_invoice_path(merchant1.id, invoice1.id)

      expect(page).to have_content(invoice1.id)
      expect(page).to have_content(invoice1.status)
      expect(page).to have_content(invoice1.created_at.strftime("%A, %B %d, %Y"))
      expect(page).to have_content(customer1.first_name)
      expect(page).to have_content(customer1.last_name)
    end

    it "then I see all of my items on the invoice including: name, quanity, price, status" do
      visit merchant_invoice_path(merchant1.id, invoice1.id)

      expect(page).to have_content(item1.name)
      expect(page).to have_content(invoice_item1.quantity)
      expect(page).to have_content(invoice_item1.unit_price)
      expect(page).to have_content(invoice_item1.status)
    end  

    it "I see the total revenue that will be generated from all of my items on the invoice" do
      visit merchant_invoice_path(merchant1, invoice1)

      expect(page).to have_content(invoice1.total_revenue)
    end

    it "I see that each invoice item status is a select field" do
      visit merchant_invoice_path(merchant1, invoice1)
      
      within "#item_status_#{item1.id}" do
        expect(page).to have_select(:status, selected: "pending")
      end
    end
    
    it "when I click this select field than I see a new status for the item " do
      visit merchant_invoice_path(merchant1, invoice1)
      
      within "#item_status_#{item1.id}" do
        select("packaged", from: "status")
        
        expect(current_path).to eq(merchant_invoice_path(merchant1, invoice1))
      end
    end
  end
  
  describe "BULK DISCOUNTS" do
    let!(:bulk_discount1) {create(:bulk_discount, merchant_id: merchant1.id, quantity_threshold: 10, percent_discount: 40)}
    let!(:bulk_discount2) {create(:bulk_discount, merchant_id: merchant1.id, quantity_threshold: 2, percent_discount: 10)}
    let!(:bulk_discount3) {create(:bulk_discount, merchant_id: merchant1.id, quantity_threshold: 5, percent_discount: 20)}
    let!(:item5) {create(:item, merchant_id: merchant1.id)}
    let!(:invoice_item5) { create(:invoice_item, quantity: 1, unit_price: 1000, item_id: item1.id, invoice_id: invoice1.id, status: 1) }

    describe "User Story 6" do
      it "displays total revenue and discounted revenue" do
        visit merchant_invoice_path(merchant1, invoice1)
        # Then I see the total revenue for my merchant from this invoice 
        # (not including discounts)
        expect(page).to have_content(invoice1.total_revenue)
        # And I see the total discounted revenue for my merchant from this invoice 
        # which includes bulk discounts in the calculation
        expect(page).to have_content(invoice1.discounted_revenue)
      end
    end
    
    describe "User Story 7" do
      it "link to bulk discount show page from invoice item" do
        visit merchant_invoice_path(merchant1, invoice1)

        within("#invoice_item_#{invoice_item1.id}") do
          expect(page).to have_content("Applied Discount: #{bulk_discount2.percent_discount}%!")
        end

        within("#invoice_item_#{invoice_item2.id}") do
          expect(page).to have_content("Applied Discount: #{bulk_discount3.percent_discount}%!")
        end
        
        within("#invoice_item_#{invoice_item5.id}") do
          expect(page).to_not have_content("Applied Discount:")
        end
      end
    end
  end
end

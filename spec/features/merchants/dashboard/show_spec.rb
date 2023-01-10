require 'rails_helper'

RSpec.describe 'Merchant Dashboard Index', type: :feature do
  let!(:merchant) { Merchant.create!(name: "Bill's Boardshop") }
  let!(:merchant1) { create(:merchant) }
  
  let!(:item1) { create(:item, merchant_id: merchant.id) }
  let!(:item2) { create(:item, merchant_id: merchant.id) }
  let!(:item3) { create(:item, merchant_id: merchant.id) }
  let!(:item4) { create(:item, merchant_id: merchant.id) }
  let!(:item5) { create(:item, merchant_id: merchant.id) }
  let!(:item6) { create(:item, merchant_id: merchant.id) }
  let!(:item7) { create(:item, merchant_id: merchant.id) }
  let!(:item8) { create(:item, merchant_id: merchant.id) }
  let!(:item9) { create(:item, merchant_id: merchant.id) }
  let!(:item10) { create(:item, merchant_id: merchant.id) }
  
  let!(:customer1) { create(:customer) } 
  let!(:customer2) { create(:customer) } 
  let!(:customer3) { create(:customer) } 
  let!(:customer4) { create(:customer) } 
  let!(:customer5) { create(:customer) } 
  let!(:customer6) { create(:customer) } 
  
  let!(:invoice1) { create(:invoice, customer_id: customer1.id) }
  let!(:invoice2) { create(:invoice, customer_id: customer2.id) }
  let!(:invoice3) { create(:invoice, customer_id: customer3.id) }
  let!(:invoice4) { create(:invoice, customer_id: customer4.id) }
  let!(:invoice5) { create(:invoice, customer_id: customer5.id) }
  let!(:invoice6) { create(:invoice, customer_id: customer6.id) }
  let!(:invoice7) { create(:invoice, customer_id: customer1.id) }
  let!(:invoice8) { create(:invoice, customer_id: customer2.id) }
  let!(:invoice9) { create(:invoice, customer_id: customer3.id) }
  let!(:invoice10) { create(:invoice, customer_id: customer4.id) }
  let!(:invoice11) { create(:invoice, customer_id: customer5.id) }
  let!(:invoice12) { create(:invoice, customer_id: customer6.id) }

  let!(:transaction1) { 1.times do create(:transaction, invoice_id: invoice1.id, result: 1) end }
  let!(:transaction2) { 2.times do create(:transaction, invoice_id: invoice2.id, result: 1) end }
  let!(:transaction3) { 3.times do create(:transaction, invoice_id: invoice3.id, result: 1) end }
  let!(:transaction4) { 4.times do create(:transaction, invoice_id: invoice4.id, result: 1) end }
  let!(:transaction5) { 5.times do create(:transaction, invoice_id: invoice5.id, result: 1) end }
  let!(:transaction6) { 6.times do create(:transaction, invoice_id: invoice6.id, result: 1) end }

  let!(:invoice_item1) { create(:invoice_item, invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 1, status: 2) }
  let!(:invoice_item2) { create(:invoice_item, invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 1, status: 2) }
  let!(:invoice_item3) { create(:invoice_item,invoice_id: invoice3.id, item_id: item1.id, quantity: 3, unit_price: 1, status: 2) }
  let!(:invoice_item4) { create(:invoice_item,invoice_id: invoice4.id, item_id: item1.id, quantity: 4, unit_price: 1, status: 2) }
  let!(:invoice_item5) { create(:invoice_item,invoice_id: invoice5.id, item_id: item1.id, quantity: 5, unit_price: 1, status: 2) }
  let!(:invoice_item6) { create(:invoice_item,invoice_id: invoice6.id, item_id: item1.id, quantity: 6, unit_price: 1, status: 2) }
  let!(:invoice_item7) { create(:invoice_item, invoice_id: invoice7.id, item_id: item2.id, quantity: 1, unit_price: 1, status: 1) }
  let!(:invoice_item8) { create(:invoice_item, invoice_id: invoice8.id, item_id: item3.id, quantity: 3, unit_price: 1, status: 1) }
  let!(:invoice_item9) { create(:invoice_item, invoice_id: invoice9.id, item_id: item4.id, quantity: 5, unit_price: 1, status: 0) }
  let!(:invoice_item10) { create(:invoice_item, invoice_id: invoice10.id, item_id: item5.id, quantity: 6, unit_price: 1, status: 1) }
  let!(:invoice_item11) { create(:invoice_item, invoice_id: invoice11.id, item_id: item6.id, quantity: 4, unit_price: 1, status: 1) }
  let!(:invoice_item12) { create(:invoice_item, invoice_id: invoice12.id, item_id: item7.id, quantity: 3, unit_price: 1, status: 2) }

  before :each do
    visit "/merchants/#{merchant.id}/dashboard" 
  end

  describe 'As a merchant, when I visit my merchant dashboard' do
    it 'displays the merchant name' do #us1
      expect(page).to have_content(merchant.name)
    end

    it 'shows a link to my merchant items index' do #us2
      expect(page).to have_link("Merchant Items Index")
      expect(page).to have_link("Merchant Invoices Index")
    end

    it 'the I see the names of the top 5 customers who have conducted the largest number of transactions' do #us 5
      within ("#top_customers") do
        expect(page).to have_content("Top Customers:") 
        expect(page).to have_content(customer2.first_name) 
        expect(page).to have_content(customer2.last_name) 
        expect(page).to have_content(customer3.first_name) 
        expect(page).to have_content(customer3.last_name) 
        expect(page).to have_content(customer4.first_name) 
        expect(page).to have_content(customer4.last_name) 
        expect(page).to have_content(customer5.first_name) 
        expect(page).to have_content(customer5.last_name) 
        expect(page).to have_content(customer6.first_name) 
        expect(page).to have_content(customer6.last_name) 
        expect(page).to_not have_content(customer1.first_name) 
        expect(page).to_not have_content(customer1.last_name)   
      end
    end

    it "next to each customers name I see the number of successful transactions they have" do
      within ("#customer_id#{customer2.id}") do
        expect(page).to have_content(customer2.transactions.count)
      end
      within ("#customer_id#{customer3.id}") do
        expect(page).to have_content(customer3.transactions.count)
      end
      within ("#customer_id#{customer4.id}") do
        expect(page).to have_content(customer4.transactions.count)
      end
      within ("#customer_id#{customer5.id}") do
        expect(page).to have_content(customer5.transactions.count)
      end
      within ("#customer_id#{customer6.id}") do
        expect(page).to have_content(customer6.transactions.count)
      end
    end

    #us4
    it "has a section for 'Items Ready To Ship' with a list of names of all items" do
      within("#ready-to-ship") do
        expect(page).to have_content(item2.name)
      end
    end
  end
end

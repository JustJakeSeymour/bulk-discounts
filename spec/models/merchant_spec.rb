require 'rails_helper'

RSpec.describe Merchant, type: :model do
  before(:each) do
    @merchant = create(:merchant) 
    @item1, @item2, @item3, = create_list(:item, 3, merchant: @merchant) 
    @item4, @item5 = create_list(:item, 2, merchant: @merchant, status: "enabled") 
  end
  
  describe 'relationships' do
    it { should have_many :items } 
    it { should have_many(:invoice_items).through(:items) } 
    it { should have_many(:invoices).through(:invoice_items) } 
    it { should have_many(:transactions).through(:invoices) } 
  end

  describe 'validations' do
    it { should validate_presence_of :name } 
    it { should define_enum_for(:status) } 
  end

  describe 'methods' do
    let!(:merchant1) {create(:merchant)}
    let!(:merchant2) {create(:merchant)}
    let!(:merchant3) {create(:merchant)}
    let!(:merchant4) {create(:merchant)}
    let!(:merchant5) {create(:merchant)}
    let!(:merchant6) {create(:merchant)}

    let!(:customer) {create(:customer)}

    let!(:item1) {create(:item, merchant_id: merchant1.id)}
    let!(:item2) {create(:item, merchant_id: merchant2.id)}
    let!(:item3) {create(:item, merchant_id: merchant3.id)}
    let!(:item4) {create(:item, merchant_id: merchant4.id)}
    let!(:item5) {create(:item, merchant_id: merchant5.id)}
    let!(:item6) {create(:item, merchant_id: merchant6.id)}

    let!(:invoice1) {create(:invoice, customer_id: customer.id)}
    let!(:invoice2) {create(:invoice, customer_id: customer.id)}
    let!(:invoice3) {create(:invoice, customer_id: customer.id)}
    let!(:invoice4) {create(:invoice, customer_id: customer.id)}
    let!(:invoice5) {create(:invoice, customer_id: customer.id)}
    let!(:invoice6) {create(:invoice, customer_id: customer.id)}

    let!(:invoice_item1) {create(:invoice_item, invoice_id: invoice1.id, item_id:item1.id, quantity: 1, unit_price: 100)}
    let!(:invoice_item2) {create(:invoice_item, invoice_id: invoice2.id, item_id:item2.id, quantity: 1, unit_price: 200)}
    let!(:invoice_item3) {create(:invoice_item, invoice_id: invoice3.id, item_id:item3.id, quantity: 1, unit_price: 300)}
    let!(:invoice_item4) {create(:invoice_item, invoice_id: invoice4.id, item_id:item4.id, quantity: 1, unit_price: 400)}
    let!(:invoice_item5) {create(:invoice_item, invoice_id: invoice5.id, item_id:item5.id, quantity: 1, unit_price: 500)}
    let!(:invoice_item6) {create(:invoice_item, invoice_id: invoice6.id, item_id:item6.id, quantity: 1, unit_price: 600)}
    
    let!(:transaction1) {create(:transaction, invoice_id: invoice1.id, result: 1)}
    let!(:transaction2) {create(:transaction, invoice_id: invoice2.id, result: 1)}
    let!(:transaction3) {create(:transaction, invoice_id: invoice3.id, result: 1)}
    let!(:transaction4) {create(:transaction, invoice_id: invoice4.id, result: 1)}
    let!(:transaction5) {create(:transaction, invoice_id: invoice5.id, result: 1)}
    let!(:transaction6) {create(:transaction, invoice_id: invoice6.id, result: 1)}
    
    describe 'class methods' do
      it "top 5 merchants by revenue" do
        expect(Merchant.top_five_by_revenue.include?(merchant6)).to be true
        expect(Merchant.top_five_by_revenue.include?(merchant5)).to be true
        expect(Merchant.top_five_by_revenue.include?(merchant4)).to be true
        expect(Merchant.top_five_by_revenue.include?(merchant3)).to be true
        expect(Merchant.top_five_by_revenue.include?(merchant2)).to be true
        expect(Merchant.top_five_by_revenue.include?(merchant1)).to be false
      end
    end
    
    describe 'instance methods' do
      it "total_revenue" do
        expect(merchant6.total_revenue).to eq(600)
        
        # invoices need at least one "successful" transaction to be counted
        invoice_no_success = create(:invoice, customer_id: customer.id)
        invoice_item_no_success = create(:invoice_item, invoice_id: invoice_no_success.id, item_id: item6.id, quantity: 1, unit_price: 100)
        transaction_no_success = create(:transaction, invoice_id: invoice_no_success.id, result: 0)
        
        expect(merchant6.total_revenue).to eq(600)
        # UNSURE HOW TO TRULY GET A RECORD WITH A FAILED RESULT TO BE IGNORED< THEN INCLUDED ONCE THERE IS A PASSING TRANSACTION
        # transaction_success = create(:transaction, invoice_id: invoice_no_success.id, result: 1)
        # expect(merchant6.total_revenue).to eq(700)
      end
      
      it "best_day" do
        invoice7 = create(:invoice, customer_id: customer.id, created_at: "2022/02/02")
        invoice_item7 = create(:invoice_item, invoice_id: invoice7.id, item_id:item6.id, quantity: 5, unit_price: 600)
        transaction_good = create(:transaction, invoice_id: invoice7.id, result: 1)
        merchant6.reload
        expect(merchant6.best_day).to eq(invoice7.created_at)
      end
    end
  end

  describe 'instance methods' do
    describe '#top_five_items_ordered' do
      let!(:merchant1) { Merchant.create!(name: "Billy's Butters") }
      let!(:merchant2) { Merchant.create!(name: "Sandy's Sandwiches") }
      
      let!(:item1) { Item.create!(name: "Tissues", description: "Wipes Nose", unit_price: 1000, merchant: merchant1) }
      let!(:item2) { Item.create!(name: "Apples", description: "Delicious", unit_price: 1200, merchant: merchant1) }
      let!(:item3) { Item.create!(name: "Pizza", description: "Cheezy Delicious", unit_price: 1749, merchant: merchant1, status: "enabled") }
      let!(:item4) { Item.create!(name: "Penguins", description: "Exotic pet", unit_price: 100005, merchant: merchant1, status: "enabled") }
      let!(:item6) { Item.create!(name: "Briscuit", description: "Meat", unit_price: 1000, merchant: merchant1) }
      let!(:item7) { Item.create!(name: "Pickles", description: "Dill", unit_price: 1200, merchant: merchant1) }
      let!(:item8) { Item.create!(name: "Headphones", description: "Plays music", unit_price: 1749, merchant: merchant1, status: "enabled") }
      let!(:item9) { Item.create!(name: "Water Bottle", description: "Holds water", unit_price: 1000, merchant: merchant1, status: "enabled") }
      
      let!(:item5) { Item.create!(name: "Computer Mouse", description: "Moves Cursor", unit_price: 5000, merchant: merchant2) }
      let!(:item10) { Item.create!(name: "Laptop", description: "Writes code", unit_price: 5000, merchant: merchant2) }
      
      let!(:customer1) {Customer.create!(first_name: "Bob", last_name: "Bobbert")}
      let!(:customer2) {Customer.create!(first_name: "Chad", last_name: "Chaddert")}
      let!(:customer3) {Customer.create!(first_name: "Pete", last_name: "Peterton")}
      let!(:customer4) {Customer.create!(first_name: "Sarah", last_name: "Sarington")}
      let!(:customer5) {Customer.create!(first_name: "Logan", last_name: "Lofferson")}
      
      let!(:invoice1) {customer1.invoices.create!(status: 1)}
      let!(:invoice2) {customer2.invoices.create!(status: 1)}
      let!(:invoice3) {customer3.invoices.create!(status: 1)}
      let!(:invoice4) {customer4.invoices.create!(status: 1)}
      let!(:invoice5) {customer5.invoices.create!(status: 1)}
      
      let!(:invoice_item1) { InvoiceItem.create!(quantity: 1000, unit_price: 1000, item: item1, invoice: invoice1, status: 0) }
      let!(:invoice_item2) { InvoiceItem.create!(quantity: 500, unit_price: 1200, item: item2, invoice: invoice1, status: 1) }
      let!(:invoice_item3) { InvoiceItem.create!(quantity: 100, unit_price: 1749, item: item3, invoice: invoice2, status: 2) }
      let!(:invoice_item4) { InvoiceItem.create!(quantity: 1, unit_price: 100005, item: item4, invoice: invoice3, status: 1) }
      let!(:invoice_item5) { InvoiceItem.create!(quantity: 0, unit_price: 5000, item: item5, invoice: invoice1, status: 0) }
      let!(:invoice_item6) { InvoiceItem.create!(quantity: 30, unit_price: 1000, item: item6, invoice: invoice2, status: 1) }
      let!(:invoice_item7) { InvoiceItem.create!(quantity: 1, unit_price: 1200, item: item7, invoice: invoice3, status: 2) }
      let!(:invoice_item8) { InvoiceItem.create!(quantity: 1, unit_price: 1749, item: item8, invoice: invoice4, status: 1) }
      let!(:invoice_item9) { InvoiceItem.create!(quantity: 1, unit_price: 1000, item: item9, invoice: invoice5, status: 1) }
      let!(:invoice_item10) { InvoiceItem.create!(quantity: 0, unit_price: 1200, item: item2, invoice: invoice2, status: 1) }
      let!(:invoice_item11) { InvoiceItem.create!(quantity: 0, unit_price: 1749, item: item3, invoice: invoice3, status: 2) }
      let!(:invoice_item12) { InvoiceItem.create!(quantity: 0, unit_price: 100005, item: item4, invoice: invoice3, status: 1) }
      
      let!(:transaction1) { Transaction.create!(result: "success", credit_card_number: 4832483429348594, credit_card_expiration_date: "", invoice: invoice1 ) }
      let!(:transaction2) { Transaction.create!(result: "success", credit_card_number: 4832483429348594, credit_card_expiration_date: "", invoice: invoice2 ) }
      let!(:transaction3) { Transaction.create!(result: "success", credit_card_number: 4832483429348594, credit_card_expiration_date: "", invoice: invoice3 ) }
      let!(:transaction4) { Transaction.create!(result: "success", credit_card_number: 4832483429348594, credit_card_expiration_date: "", invoice: invoice4 ) }
      let!(:transaction5) { Transaction.create!(result: "success", credit_card_number: 4832483429348594, credit_card_expiration_date: "", invoice: invoice5 ) }

      it 'returns an array of the top five merchant items by revenue' do
        expect(merchant1.top_five_items_ordered).to eq([item1, item2, item3, item4, item6])
      end

      it 'top_customers' do
        expect(merchant1.top_customers).to eq([customer3, customer2, customer1, customer4, customer5])
      end

      it "ready_to_ship" do
        expect(merchant1.ready_to_ship).to eq([item2, item2, item4, item4, item6, item8, item9])
      end
    end
    
    describe "#items_ordered_by_most_recently_updated_at" do
      it 'returns an array of a merchants items ordered by their creation time' do
        merchant1 = Merchant.create!(name: "Harvey")
        merchant2 = Merchant.create!(name: "John")
        item3 = merchant1.items.create!(name: "Saw", description:"Cut things", unit_price: 2000)
        item1 = merchant1.items.create!(name: "Hammer", description:"Hit things", unit_price: 1200)
        item2 = merchant1.items.create!(name: "Nail", description:"Secure things", unit_price: 22)
        
        merchant2.items << item1
        merchant2.items << item2
        merchant2.items << item3

        expect(item3.created_at).to be < item1.created_at
        expect(item1.created_at).to be < item2.created_at

        expect(item3.updated_at).to be > item2.updated_at
        expect(item2.updated_at).to be > item1.updated_at

        expect(merchant2.items_ordered_by_most_recently_updated_at).to eq([item3, item2, item1])
      end
    end
  end
end

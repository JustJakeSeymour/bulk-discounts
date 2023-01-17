require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items}
    it { should have_many(:items).through(:invoice_items)}
    it { should have_many(:merchants).through(:items)}
  end
  
  describe 'validations' do
    it { should define_enum_for(:status) }
  end


  describe "methods" do
    let!(:customer) {Customer.create!(first_name: "Bob", last_name: "Bobbert")}
    let!(:invoice1) {customer.invoices.create!(status: 0)}
    let!(:invoice2) {customer.invoices.create!(created_at: DateTime.new(2022, 01, 01, 00, 00, 0), status: 0)}
    let!(:invoice3) {customer.invoices.create!(created_at: DateTime.new(1990, 01, 01, 00, 00, 0), status: 0)}

    let!(:merchant1) {Merchant.create!(name: "Hockey Stop and Shop")}
    let!(:item1) {merchant1.items.create!(name: "Socks", description: "They're good socks.", unit_price: 1200)}
    let!(:item2) {merchant1.items.create!(name: "Tape", description: "For taping.", unit_price: 600)}
    let!(:invoice_item1) {InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 1200, status: 2)}

    let!(:invoice_item2) {InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 1, unit_price: 600, status: 2)}
    let!(:invoice_item3) {InvoiceItem.create!(invoice_id: invoice2.id, item_id: item2.id, quantity: 1, unit_price: 0, status: 0)}
    let!(:invoice_item4) {InvoiceItem.create!(invoice_id: invoice3.id, item_id: item1.id, quantity: 1, unit_price: 0, status: 0)}
      
    describe 'instance methods' do
      it "total_revenue" do
        expect(invoice1.total_revenue).to eq(3000)
      end

      it "discounted_revenue" do
        invoice4 = create(:invoice, customer_id: customer.id)
        bulk_discount1 = create(:bulk_discount, merchant_id: merchant1.id, quantity_threshold: 5, percent_discount: 20)
        bulk_discount2 = create(:bulk_discount, merchant_id: merchant1.id, quantity_threshold: 10, percent_discount: 40)
        invoice_item_4_1 = create(:invoice_item, invoice_id: invoice4.id, item_id: item1.id, 
                                  quantity: 5,unit_price: 20)
        invoice_item_4_2 = create(:invoice_item, invoice_id: invoice4.id, item_id: item2.id, 
                                  quantity: 1, unit_price: 20)

        expect(invoice4.total_revenue).to eq(120)
        expect(invoice4.discounted_revenue).to eq(100)
      end
    end

    describe 'class methods' do
      it "self.invoice_items_not_shipped" do
        expect(Invoice.invoice_items_not_shipped.include?(invoice2)).to be true
        expect(Invoice.invoice_items_not_shipped.include?(invoice3)).to be true
        expect(Invoice.invoice_items_not_shipped.include?(invoice1)).to be false
        expect(Invoice.invoice_items_not_shipped.first).to eq(invoice3)
        expect(Invoice.invoice_items_not_shipped.last).to eq(invoice2)
      end
    end
  end
end

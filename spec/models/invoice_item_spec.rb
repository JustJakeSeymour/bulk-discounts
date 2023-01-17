require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
 
  end

  describe 'validations' do
    it { should define_enum_for(:status)}
  end

  describe "methods" do
    let!(:merchant) {create(:merchant)}
    let!(:customer) {create(:customer)}
    let!(:bulk_discount1) {create(:bulk_discount, merchant_id: merchant.id, quantity_threshold: 10, percent_discount: 40)}
    let!(:bulk_discount2) {create(:bulk_discount, merchant_id: merchant.id, quantity_threshold: 2, percent_discount: 10)}
    let!(:bulk_discount3) {create(:bulk_discount, merchant_id: merchant.id, quantity_threshold: 5, percent_discount: 20)}
    let!(:item) {create(:item, merchant_id: merchant.id)}
    let!(:invoice) {create(:invoice, customer_id: customer.id)}
    let!(:invoice_item) {create(:invoice_item,item_id: item.id, invoice_id: invoice.id, quantity: 5, unit_price: 20)}

    describe "instance methods" do
      it "qualified_discount" do
        expect(invoice_item.qualified_discount.first).to eq(bulk_discount3)
      end
      
      it "discounted_price" do
        expect(invoice_item.discounted_price).to eq(16.0)
      end
      
      it "total_item_discount" do
        expect(invoice_item.total_item_discount).to eq(80)
      end
    end
  end
  
end

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items}
    it { should have_many(:invoices).through(:invoice_items)}  
    it { should have_many(:customers).through(:invoices)}  
    it { should have_many(:transactions).through(:invoices)}
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price).only_integer }
    it { should define_enum_for(:status) }
  end

  describe 'methods' do
    let!(:item1) {create(:item)}
    let!(:customer1) {create(:customer)}
    let!(:invoice1) {create(:invoice, customer_id: customer1.id, created_at: "2022/06/26")}
    let!(:invoice2) {create(:invoice, customer_id: customer1.id, created_at: "2000/02/08")}
    let!(:invoice_item1) {create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, quantity: 20, unit_price: 1200)}
    let!(:invoice_item2) {create(:invoice_item, item_id: item1.id, invoice_id: invoice2.id, quantity: 1, unit_price: 20)}

    describe 'instance methods' do
      it "top_selling_day" do
        expect(item1.top_selling_day.strftime("%m/%d/%Y")).to eq("06/26/2022")
      end

      it "invoice_date" do
        expect(item1.invoice_date).to eq("Sunday, June 26, 2022")
      end
    end
  end
end

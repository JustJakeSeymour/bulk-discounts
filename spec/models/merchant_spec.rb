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
  end
end

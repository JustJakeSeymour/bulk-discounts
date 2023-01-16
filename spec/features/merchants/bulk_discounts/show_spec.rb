require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Show" do
  let!(:merchant) {create(:merchant)}
  let!(:bulk_discount1) {create(:bulk_discount, merchant_id: merchant.id)}

  describe "user story 4" do
    it "displays a bulk discount information belonging to merchant" do
      visit merchant_bulk_discount_path(merchant.id, bulk_discount1.id)

        expect(page).to have_content(bulk_discount1.quantity_threshold)
        expect(page).to have_content(bulk_discount1.discount)
    end
  end
end
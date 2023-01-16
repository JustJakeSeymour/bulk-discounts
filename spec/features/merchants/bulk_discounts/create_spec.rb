require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Create" do
  let!(:merchant) {create(:merchant)}

  describe "user story 2, continued" do
    it "form to add new bulk discount" do
      visit new_merchant_bulk_discount_path(merchant.id)

      expect(page).to have_content("Percent discount")

      fill_in("Percent discount", with: 20)
      fill_in("Quantity threshold", with: 5)
      click_button("Create Bulk discount")

      expect(current_path).to eq(merchant_bulk_discounts_path(merchant.id))

      
      expect(page).to have_content("20")
      expect(page).to have_content("5")
    end
  end
end
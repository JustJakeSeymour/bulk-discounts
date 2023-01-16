require 'rails_helper'

RSpec.describe "Merchant's bulk discount edit" do
  let!(:merchant) {create(:merchant)}
  let!(:bulk_discount1) {create(:bulk_discount, merchant_id: merchant.id, percent_discount: 20)}

  describe "user story 5 part 2" do
    it "edit form" do 
      visit edit_merchant_bulk_discount_path(merchant.id, bulk_discount1.id)
      
      # And I see that the discounts current attributes are pre-poluated in the form
      expect(page).to have_field("Percent discount", with: "20")
      expect(page).to have_field("Quantity threshold", with: "#{bulk_discount1.quantity_threshold}")
      
      # When I change any/all of the information and click submit
      fill_in("Percent discount", with: 30)
      click_button "Update Bulk discount"

      # Then I am redirected to the bulk discount's show page
      expect(current_path).to eq(merchant_bulk_discount_path(merchant.id, bulk_discount1.id))

      # And I see that the discount's attributes have been updated
      expect(page).to have_content("Percent discount: 30%")

    end
  end
end
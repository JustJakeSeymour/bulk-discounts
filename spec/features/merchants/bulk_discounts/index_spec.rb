require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Index" do
  describe "user story 1" do
    it "displays all bulk discounts (and info) belonging to merchant" do
      visit merchant_bulk_discounts_path(merchant.id)
      
      within "#bulk_discount_#{bulk_discount1.id}" do
        expect(page).to have_content(bulk_discount1.quantity_threshold)
        expect(page).to have_content(bulk_discount1.discount)
        expect(page).to have_link("Details")
        
        click_link("Details")
      end
      expect(current_path).to eq(merchant_bulk_discount_path(merchant.id, bulk_discount1.id))
    end
  end
  
  describe "user story 2" do
    it "bulk discount Create" do
      visit merchant_bulk_discounts_path(merchant.id)
      
      expect(page).to have_link("Create Discount")
      click_link("Create Discount")

      expect(current_path).to eq(new_merchant_bulk_discount_path(merchant.id))
    end
  end
end
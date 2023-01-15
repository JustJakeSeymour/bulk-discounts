require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Create" do
  describe "user story 2, continued" do
    xit "form to add new bulk discount" do
      visit new_merchant_bulk_discount_path(merchant.id)

      expect(page).to have_form("New")
    end
  end
end
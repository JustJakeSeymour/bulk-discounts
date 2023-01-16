require 'rails_helper'

RSpec.describe "Merchant's bulk discount edit" do
  let!(:merchant) {create(:merchant)}
  let!(:bulk_discount1) {create(:bulk_discount, merchant_id: merchant.id)}

  describe "user story 5 part 2" do
    it "edit form" do 

    end
  end
end
require 'rails_helper'

RSpec.describe HolidayService do
  describe 'class methods' do
    it "get_url" do
      search = HolidayService.get_url
      next_holiday = search.first

      expect(next_holiday[:name]).to be_a String
      expect(next_holiday[:date].to_date).to be_a Date
    end
  end
end
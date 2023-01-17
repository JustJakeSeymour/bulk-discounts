require 'rails_helper'

RSpec.describe HolidayFacade do
  describe 'class methods' do
    describe 'get_url' do
      it 'returns array of Holiday objects' do
        expect(HolidayFacade.holidays).to all be_a Holiday
      end
    end
  end
end
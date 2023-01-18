require 'rails_helper'

RSpec.describe Holiday do
  it 'exists with attributes' do
    data = {
      name: "big fun day",
      date: "2023-01-01"
    }
    
    holiday = Holiday.new(data)

    expect(holiday).to be_a Holiday
    expect(holiday.name).to eq "big fun day"
    expect(holiday.date).to eq "2023-01-01"
  end
end
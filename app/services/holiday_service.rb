class HolidayService
  def self.get_url
    response = HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/us")
    JSON.parse(response.body, symbolize_names: true)
  end
end
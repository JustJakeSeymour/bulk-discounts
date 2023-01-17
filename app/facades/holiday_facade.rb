class HolidayFacade
  def self.dates
    json = HolidayService.get_url
    require 'pry'; binding.pry
  end
end
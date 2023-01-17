class HolidayFacade
  def self.holidays
    json = HolidayService.get_url
    
    json.map do |data|
      Holiday.new(data)
    end
  end
end
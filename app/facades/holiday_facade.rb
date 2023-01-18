class HolidayFacade
  def self.holidays
    json = HolidayService.get_url
    
    json[0..2].map do |data|
      Holiday.new(data)
    end
  end
end
require 'net/http'
class Getratesdb   <  ActiveRecord::Base

  

    
  def self.get_rates_db(params)
   # super("User"=>"string","Password"=>"string","idHotel"=>"string","idSystem"=>"string","ForeignPropCode"=>"string",
   #     "IncludeRateLevels"=>"string","ExcludeRateLevels"=>"string","IncludeRoomTypes"=>"string","ExcludeRoomTypes"=>"string","RateType"=>"string",
   #     "StartDate"=>"string","EndDate"=>"string").to_hash
      
    
    
          uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetRates_DB')
  
    
  res = Net::HTTP.post_form(uri, "User"=>params[:User],"Password"=>params[:Password],"idHotel"=>params[:idHotel],"idSystem"=>params[:idSystem],"ForeignPropCode"=>params[:ForeignPropCode],"IncludeRateLevels"=>params[:IncludeRateLevels],
    "ExcludeRateLevels"=>params[:ExcludeRateLevels],"IncludeRoomTypes"=>params[:IncludeRoomTypes],"ExcludeRoomTypes"=>params[:ExcludeRoomTypes],"RateType"=>params[:RateType],
  "StartDate"=>params[:StartDate],"EndDate"=>params[:EndDate])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res  
    
    
    
    
  end
end

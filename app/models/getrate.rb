require 'net/http'
class Getrate  <  ActiveRecord::Base

   

  def self.get_rates(params)
   # super("User"=>"string","Password"=>"string","idHotel"=>1,"idSystem"=>1,"ForeignPropCode"=>"string","IncludeRateLevels"=>"string",
   # "ExcludeRateLevels"=>"string","IncludeRoomTypes"=>"string","ExcludeRoomTypes"=>"string","RateType"=>"string",
  #"StartDate"=>"string","EndDate"=>"string").to_hash

    
      uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetRates')
  
    
  res = Net::HTTP.post_form(uri, "User"=>params[:User],"Password"=>params[:Password],"idHotel"=>params[:idHotel],"idSystem"=>params[:idSystem],"ForeignPropCode"=>params[:ForeignPropCode],"IncludeRateLevels"=>params[:IncludeRateLevels],
    "ExcludeRateLevels"=>params[:ExcludeRateLevels],"IncludeRoomTypes"=>params[:IncludeRoomTypes],"ExcludeRoomTypes"=>params[:ExcludeRoomTypes],"RateType"=>params[:RateType],
  "StartDate"=>params[:StartDate],"EndDate"=>params[:EndDate])
    logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash
    logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    logger.info res.body
    res.to_hash
    res  
    
  end
end

 require 'net/http'
class Updateavail  <  ActiveRecord::Base
    
    
  def self.update_avail(params)
   # super("User"=>"string","Password"=>"string","idHotel"=>"string","idSystem"=>"string","ForeignPropCode"=>"string",
   #     "IncludeRateLevels"=>"string","ExcludeRateLevels"=>"string","IncludeRoomTypes"=>"string","ExcludeRoomTypes"=>"string","StartDate"=>"string",
   #     "Availability"=>"0.0").to_hash
     uri = URI('http://test.reconline.com/recoupdate/update.asmx/UpdateAvail')
  
    
  res = Net::HTTP.post_form(uri, "User"=>params[:User],"Password"=>params[:Password],"idHotel"=>params[:idHotel],"idSystem"=>params[:idSystem],"ForeignPropCode"=>params[:ForeignPropCode],
        "IncludeRateLevels"=>params[:IncludeRateLevels],"ExcludeRateLevels"=>params[:ExcludeRateLevels],"IncludeRoomTypes"=>params[:IncludeRoomTypes],"ExcludeRoomTypes"=>params[:ExcludeRoomTypes],"StartDate"=>params[:StartDate],
        "Availability"=>params[:Availability])
    logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash
    logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    logger.info res.body
    res.to_hash
    res  
  end
end

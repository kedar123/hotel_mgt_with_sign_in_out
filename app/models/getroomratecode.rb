 require 'net/http'
class Getroomratecode <  ActiveRecord::Base
 
  def self.get_room_rate_codes(params)
    #super("User"=>"string","Password"=>"string","idHotel"=>"string","idSystem"=>"string","ForeignPropCode"=>"string").to_hash
     uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetRoomRateCodes')
   res = Net::HTTP.post_form(uri, "User"=>params[:User],"Password"=>params[:Password],"idHotel"=>params[:idHotel],"idSystem"=>params[:idSystem],"ForeignPropCode"=>params[:ForeignPropCode])
    logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash
    logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    logger.info res.body
    res.to_hash
    res  
  
  end
  
end

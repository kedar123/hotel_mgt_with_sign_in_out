 require 'net/http'
class Getroomratecodefb <  ActiveRecord::Base

   

     

  def self.get_room_rate_codes_fb(params)
       
      #super("User"=>"string","Password"=>"string","idHotel"=>"string","idSystem"=>"string","ForeignPropCode"=>"string").to_hash

      uri = URI('http://www.reconline.com/recoupdate/update.asmx/GetRoomRateCodesFB')
  
    
  res = Net::HTTP.post_form(uri, "User"=>params[:User],"Password"=>params[:Password],"idHotel"=>params[:idHotel],"idSystem"=>params[:idSystem],"ForeignPropCode"=>params[:ForeignPropCode])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res  
  end
end

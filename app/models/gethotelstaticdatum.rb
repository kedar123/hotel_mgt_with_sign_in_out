require 'net/http'

class Gethotelstaticdatum  <  ActiveRecord::Base
 

 # document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  

 #    actions :get_hotel_static_data

  def self.get_hotel_static_data(params)
    #super("User"=>"string","Password"=>"string","idHotel"=>"string").to_hash
    
      uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetHotelStaticData')
  
    
  res = Net::HTTP.post_form(uri, 'User'=>params[:User],'Password'=>params[:Password],'idHotel'=>params[:idHotel])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res  
  end
end

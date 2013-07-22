require 'net/http'
class Gethotelstaticdatagd  <  ActiveRecord::Base
     
   

  
      

  def self.get_hotel_static_data_gds(params)
    #super("User"=>"string","Password"=>"string","idGDS"=>"string","PropertyCode"=>"string").to_hash
    
    
      uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetHotelStaticDataGDS')
  
    
  res = Net::HTTP.post_form(uri, "Username"=>params[:Username],"Password"=>params[:Password],"idGDS"=>params[:idGDS],"PropertyCode"=>params[:PropertyCode])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res 
    
  end
end

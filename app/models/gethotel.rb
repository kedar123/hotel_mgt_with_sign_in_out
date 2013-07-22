require 'net/http'
class Gethotel  <  ActiveRecord::Base
    
   

     
  def self.get_hotels(params)
    #super("User"=>"string","Password"=>"string").to_hash
    uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetHotels')
  
  
    
  res = Net::HTTP.post_form(uri, 'User'=>params[:User],'Password'=>params[:Password])
    logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash
    logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    logger.info res.body
    res.to_hash
    res  
  end
  
end

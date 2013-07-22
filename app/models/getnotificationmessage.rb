require 'net/http'
class Getnotificationmessage   <  ActiveRecord::Base
     

  #document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  

  #   actions :get_notification_messages

  def self.get_notification_messages(params)
    #super("User"=>"string","Password"=>"string","idHotelList"=>"string").to_hash
    
    
      uri = URI('http://www.reconline.com/recoupdate/update.asmx/GetNotificationMessages')
  
    
  res = Net::HTTP.post_form(uri, 'User'=>params[:User],'Password'=>params[:Password],'idHotelList'=>params[:idHotelList])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res  
    
  end
  
end

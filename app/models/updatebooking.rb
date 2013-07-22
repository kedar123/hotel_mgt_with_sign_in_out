 require 'net/http'
class Updatebooking  <  ActiveRecord::Base
     

  #document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  

   #  actions :update_booking

  def self.update_booking(params)
   # super("User"=>"string","Password"=>"string","idRSV"=>"string","CorrCheckin"=>"string",
   #     "CorrCheckout"=>"string","CorrRate"=>"string","CorrComm"=>"string","CorrRoomType"=>"string","CorrRoomNumber"=>"string",
   #     "CorrRemark"=>"0.0","ReasonCode"=>2,"CommCode"=>1,"CorrRateCode"=>1,"CorrAdults"=>1,"CorrChildren"=>1,"CorrCrib"=>"string").to_hash
    uri = URI('http://www.reconline.com/recoupdate/update.asmx/UpdateBooking')
  
    
  res = Net::HTTP.post_form(uri, "User"=> params[:User],"Password"=>params[:Password],"idRSV"=>params[:idRSV],"CorrCheckin"=>params[:CorrCheckin],
        "CorrCheckout"=>params[:CorrCheckout],"CorrRate"=>params[:CorrRate],"CorrComm"=>params[:CorrComm],"CorrRoomType"=>params[:CorrRoomType],"CorrRoomNumber"=>params[:CorrRoomNumber],
        "CorrRemark"=>params[:CorrRemark],"ReasonCode"=> params[:ReasonCode] ,"CommCode"=>params[:CommCode],"CorrRateCode"=>params[:CorrRateCode],"CorrAdults"=>params[:CorrAdults],"CorrChildren"=>params[:CorrChildren],"CorrCrib"=>params[:CorrCrib])
    logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash
    logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    logger.info res.body
    logger.info res.body.inspect
    
    res.to_hash
    res  
   
  end
end

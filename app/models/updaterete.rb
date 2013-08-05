require 'net/http'
require 'xmlsimple'
class Updaterete <  ActiveRecord::Base
   
   
  
  
  def self.get_rates()
     uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetRates')
     
   
    
  res = Net::HTTP.post_form(uri,'User'=>'kedar', 'Password'=>'ked2012','idHotel'=>'38534','idSystem'=>'0','ForeignPropCode'=>'blank','IncludeRateLevels'=>'BAR','ExcludeRateLevels'=>'','IncludeRoomTypes'=>'DBL','ExcludeRoomTypes'=>'','RateType'=>'1','StartDate'=>'05.08.2013','EndDate'=> '01.09.2014')
    
    
    
    logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash
    logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    logger.info res.body
    logger.info res.to_hash
    res = XmlSimple.xml_in(res.body)
    logger.info res
    logger.info "ressssssssssssssssssss"
    res 
    
  end

  
  def self.update_rates(params)
     uri = URI('http://test.reconline.com/recoupdate/update.asmx/UpdateRates')
   res = Net::HTTP.post_form(uri, 'User'=>params[:User],'Password'=>params[:Password],
  "idHotel"=> params[:idHotel] ,"idSystem"=>params[:idSystem],"ForeignPropCode"=>params[:ForeignPropCode],
        "IncludeRateLevels"=>params[:IncludeRateLevels],"ExcludeRateLevels"=> params[:ExcludeRateLevels],
        "IncludeRoomTypes"=>params[:IncludeRoomTypes],"ExcludeRoomTypes"=>params[:ExcludeRoomTypes],"RateType"=>
          params[:RateType],
        "StartDate"=> params[:StartDate],"EndDate"=>params[:EndDate],"SingleOcc"=>params[:SingleOcc],"DoubleOcc"=>params[:DoubleOcc],
        "TripleOcc"=>params[:TripleOcc],"DoublePlusChild"=>params[:DoublePlusChild],
        "RollawayAdult"=>params[:RollawayAdult],"RollawayChild"=>params[:RollawayChild],"Crib"=>params[:Crib],"Meals"=>params[:Meals],
        "Advance"=> params[:Advance],"MinStay"=> params[:MinStay],
        "BlockStay"=> params[:BlockStay],"Guarantee"=>params[:Guarantee],"Cancel"=>params[:Cancel],"CTAMonday"=>params[:CTAMonday],
        "CTATuesday"=>params[:CTATuesday] ,
        "CTAWednesday"=>params[:CTAWednesday],"CTAThursday"=>params[:CTAThursday],"CTAFriday"=>params[:CTAFriday],"CTASaturday"=>params[:CTASaturday],
        "CTASunday"=>params[:CTASunday],
        "InvalidMonday"=>params[:InvalidMonday],"InvalidTuesday"=>params[:InvalidTuesday],"InvalidWednesday"=>params[:InvalidWednesday],"InvalidThursday"=>params[:InvalidThursday],"InvalidFriday"=>params[:InvalidFriday],
        "InvalidSaturday"=>params[:InvalidSaturday],"InvalidSunday"=>params[:InvalidSunday])
    logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash
    logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    logger.info res.body
    logger.info res.to_hash
    res 
  end
  
  
end

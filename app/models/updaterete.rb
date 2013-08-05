require 'net/http'
require 'xmlsimple'
class Updaterete <  ActiveRecord::Base
   
   
  
  def self.update_single_rate(params)
    
   
       uri = URI('http://test.reconline.com/recoupdate/update.asmx/UpdateRates')
   res = Net::HTTP.post_form(uri, 'User'=> 'kedar' ,'Password'=> 'ked2012' ,
  "idHotel"=> '38534'  ,"idSystem"=>'0' ,"ForeignPropCode"=> 'blank' ,
        "IncludeRateLevels"=>'BAR' ,"ExcludeRateLevels"=> '',
        "IncludeRoomTypes"=>params[:room_type],"ExcludeRoomTypes"=>'',"RateType"=>
           '1',
        "StartDate"=> params[:begin_period],"EndDate"=>params[:end_period],"SingleOcc"=>params[:SINGLEOCCUPANCY],"DoubleOcc"=>params[:DOUBLEOCCUPANCY],
        "TripleOcc"=>params[:TRIPLEOCCUPANCY],"DoublePlusChild"=>params[:QUADRUPLEOCCUPANCY],
        "RollawayAdult"=>params[:ROLLAWAYADULT] ,"RollawayChild"=>params[:ROLLAWAYCHILD] ,"Crib"=>'0',"Meals"=>'0',
        "Advance"=> '0',"MinStay"=> '0',
        "BlockStay"=> '0',"Guarantee"=>'0',"Cancel"=>'0',"CTAMonday"=>params[:CTAMO],
        "CTATuesday"=>params[:CTATU] ,
        "CTAWednesday"=>params[:CTAWE] ,"CTAThursday"=>params[:CTATH],"CTAFriday"=>params[:CTAFR],"CTASaturday"=>params[:CTASA],
        "CTASunday"=>params[:CTASU],
        "InvalidMonday"=>'0',"InvalidTuesday"=>'0',"InvalidWednesday"=>'0',"InvalidThursday"=>'0',"InvalidFriday"=>'0',
        "InvalidSaturday"=>'0',"InvalidSunday"=>'0')
    logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash

  end
  
  
  def self.get_rates(params)
     uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetRates')
     
   
  
  res = Net::HTTP.post_form(uri,'User'=>'kedar', 'Password'=>'ked2012','idHotel'=>'38534','idSystem'=>'0','ForeignPropCode'=>'blank','IncludeRateLevels'=>'BAR','ExcludeRateLevels'=>'','IncludeRoomTypes'=>params[:room_type]  ,'ExcludeRoomTypes'=>'','RateType'=>'1','StartDate'=>params[:start_date] ,'EndDate'=> params[:end_date] )
    
    
    
    logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash
    logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    logger.info res.body
    logger.info res.to_hash
    if !params[:room_type].blank?
       res = XmlSimple.xml_in(res.body)
    end
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

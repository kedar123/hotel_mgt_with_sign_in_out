 require 'net/http'
class Getcommissionstatus   <  ActiveRecord::Base
  

  #document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  

     #actions :get_commission_status

  def self.get_commission_status(params)
    #super("User"=>"string","Password"=>"string","idRSV"=>"string").to_hash
    
     uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetCommissionStatus')
  
    
  res = Net::HTTP.post_form(uri, 'User'=>params[:User],'Password'=>params[:Password],'Create'=>'params[:Create]','idRSV'=>params[:idRSV])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res  
    
    
    
  end
end

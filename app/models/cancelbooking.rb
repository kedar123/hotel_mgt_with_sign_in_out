require "savon_model"

require 'net/http'
class Cancelbooking <  ActiveRecord::Base
   
 #actions :cancel
 # document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  

  #   actions :cancel 

  def self.cancel(params)
    uri = URI('http://test.reconline.com/recoupdate/update.asmx/Cancel')
  
    
  res = Net::HTTP.post_form(uri, 'User'=>params[:User],'Password'=>params[:Password],'idRSV'=>params[:idRSV])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res
    
     
  end


end

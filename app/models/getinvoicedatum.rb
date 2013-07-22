 
 require 'net/http'
 
class Getinvoicedatum   <  ActiveRecord::Base
   

  #document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  

   #  actions :get_invoice_data

  def self.get_invoice_data(params)
    #super("User"=>"string","Password"=>"string","StartDate"=>"string","EndDate"=>"string").to_hash
    
     uri = URI('http://www.reconline.com/recoupdate/update.asmx/GetInvoiceData')
  
    
  res = Net::HTTP.post_form(uri, "User"=>params[:User],"Password"=>params[:Password],"StartDate"=>params[:StartDate],"EndDate"=>params[:EndDate])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res  
  end
end

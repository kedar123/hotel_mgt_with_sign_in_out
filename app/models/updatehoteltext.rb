require "savon_model"
class Updatehoteltext  
  
   include Savon::Model

  document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  

     actions :booking

  def booking()
    super("User"=>"string","Password"=>"string","idHotel"=>"string","idSystem"=>"string","ForeignPropCode"=>"string",
        "idType"=>"string","idlanguage"=>"string","Text"=>"string").to_hash
  end
  
end

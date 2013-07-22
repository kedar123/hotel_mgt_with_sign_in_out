require "savon_model"
class Setd  
   include Savon::Model

  document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  

     actions :set_ds

  def set_ds()
    super("User"=>"string","Password"=>"string","ds"=>"string").to_hash
  end
end

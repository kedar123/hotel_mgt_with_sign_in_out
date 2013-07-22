 require 'net/http'
class Setmarkassent   <  ActiveRecord::Base
    

  

  def self.set_mark_as_sent(params)
    #super("User"=>"string","Password"=>"string","idMessageList"=>"string").to_hash
     uri = URI('http://www.reconline.com/recoupdate/update.asmx/SetMarkAsSent')
  
    
  res = Net::HTTP.post_form(uri, "User"=>params[:User],"Password"=>params[:Password],"idMessageList"=>params[:idMessageList])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res  
  end
end

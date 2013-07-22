 
require 'net/http'

class Booking  <  ActiveRecord::Base
      # include Savon::Model

  #document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  

   #  actions :booking

  def self.booking(params)
    
    
  uri = URI('http://test.reconline.com/recoupdate/update.asmx/Booking')
  
    
  res = Net::HTTP.post_form(uri, 'User'=>params[:User],'Password'=>params[:Password],'Create'=>params[:Create],'idRSV'=>params[:idRSV],'PropCode'=>params[:PropCode],'RoomCode'=>params[:RoomCode],'RateLevel'=>params[:RateLevel],'RateCode'=>params[:RateCode],'Checkin'=>params[:Checkin],'Checkout'=>params[:Checkout],'Rate'=>params[:Rate],'MealsInc'=>params[:MealsInc],'NumRooms'=>params[:NumRooms],'Adults'=>params[:Adults],'Children'=>params[:Children],'Crib'=>params[:Crib],'Remark'=>params[:Remark],'Text'=>params[:Text],'Reference'=>params[:Reference],'CuName'=>params[:CuName],'CuFirstname'=>params[:CuFirstname],'CuTitle'=>params[:CuTitle],'CuAddress1'=>params[:CuAddress1],'CuAddress2'=>params[:CuAddress2],'CuAddress3'=>params[:CuAddress3],'CuZIP'=>params[:CuZIP],'CuCity'=>params[:CuCity],'CuState'=>params[:CuState],'CuCountry'=>params[:CuCountry],'CuTelephone1'=>params[:CuTelephone1],'CuTelephone2'=>params[:CuTelephone2],'CuTelefax'=>params[:CuTelefax],'CuEmail'=>params[:CuEmail],'CuCompany'=>params[:CuCompany],'CuMobile'=>params[:CuMobile],'CuNationality'=>params[:CuNationality],'CuPassport'=>params[:CuPassport],'CuBirthDate'=>params[:CuBirthDate],'CCIDCardorganisation'=>params[:CCIDCardorganisation],'CCNumber'=>params[:CCNumber],'CCExpirydate'=>params[:CCExpirydate],'CCHolder'=>params[:CCHolder],'CCCVC'=>params[:CCCVC],'CCZIP'=>params[:CCZIP],'Info'=>params[:Info],'CustomerNumber'=>params[:CustomerNumber],'FreqTravNum'=>params[:FreqTravNum],'FreqGuestNum'=>params[:FreqGuestNum],'GDSRoomCode'=>params[:GDSRoomCode],'ATC'=>params[:ATC],'BSAGENT'=>params[:BSAGENT],'AgentName'=>params[:AgentName],'CorpAcc'=>params[:CorpAcc],'ArrivalTime'=>params[:ArrivalTime],'PCC'=>params[:PCC],'Voucher'=>params[:Voucher],'RateAgreement'=>params[:RateAgreement],'WrittenConf'=>params[:WrittenConf],'GDSCurrency'=>params[:GDSCurrency],'CurrencyCode'=>params[:CurrencyCode],'IDBookingSource'=>params[:IDBookingSource],'MarketCode'=>params[:MarketCode])
    p "the paaramsmsmsms"
    p res.inspect
    p res.to_hash
    p res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    p res.body
    res.to_hash
    res  
    
 #   super("User"=>"string","Password"=>"string","Create"=>"string","idRSV"=>"string","PropCode"=>"string",
 #       "RoomCode"=>"string","RateLevel"=>"string","RateCode"=>"string","Checkin"=>"string","Checkout"=>"string",
 #       "Rate"=>"0.0","MealsInc"=>2,"NumRooms"=>1,"Adults"=>1,"Children"=>1,"Crib"=>1,"Remark"=>"string","Text"=>"string","Reference"=>"string","CuName"=>"string","CuFirstname"=>"string","CuTitle"=>"string",
 #       "CuAddress1"=>"string","CuAddress2"=>"string","CuAddress3"=>"string","CuZIP"=>"string","CuCity"=>"string",
 #       "CuState"=>"string","CuCountry"=>"string","CuTelephone1"=>"string","CuTelephone2"=>"string","CuTelefax"=>"string",
 #       "CuEmail"=>"string","CuCompany"=>"string","CuMobile"=>"string","CuNationality"=>"string","CuPassport"=>"string",
 #       "CuBirthDate"=>"string","CCIDCardorganisation"=>1,"CCNumber"=>"string","CCExpirydate"=>"string","CCHolder"=>"string","CCCVC"=>"string","CCZIP"=>"string","Info"=>"string","CustomerNumber"=>"string","FreqTravNum"=>"string",
 #        "FreqGuestNum"=>"string","GDSRoomCode"=>"string","ATC"=>"string","BSAGENT"=>"string","AgentName"=>"string",
 #        "CorpAcc"=>"string","ArrivalTime"=>"string","PCC"=>"string","Voucher"=>"string","RateAgreement"=>"string",
 #        "WrittenConf"=>"string","GDSCurrency"=>"string","CurrencyCode"=>"string","IDBookingSource"=>1,
 #        "MarketCode"=>"string").to_hash
 
  end
 
=begin  
{"User"=>"user",
 "Password"=>"[FILTERED]",
 "Create"=>"",
 "idRSV"=>"",
 "PropCode"=>"",
 "RoomCode"=>"",
 "RateLevel"=>"",
 "RateCode"=>"",
 "Checkin"=>"",
 "Checkout"=>"",
 "Rate"=>"",
 "MealsInc"=>"",
 "NumRooms"=>"",
 "Adults"=>"",
 "Children"=>"",
 "Crib"=>"",
 "Remark"=>"",
 "Text"=>"",
 "Reference"=>"",
 "CuName"=>"",
 "CuFirstname"=>"",
 "CuTitle"=>"",
 "CuAddress1"=>"",
 "CuAddress2"=>"",
 "CuAddress3"=>"",
 "CuZIP"=>"",
 "CuCity"=>"",
 "CuState"=>"",
 "CuCountry"=>"",
 "CuTelephone1"=>"",
 "CuTelephone2"=>"",
 "CuTelefax"=>"",
 "CuEmail"=>"",
 "CuCompany"=>"",
 "CuMobile"=>"",
 "CuNationality"=>"",
 "CuPassport"=>"",
 "CuBirthDate"=>"",
 "CCIDCardorganisation"=>"",
 "CCNumber"=>"",
 "CCExpirydate"=>"",
 "CCHolder"=>"",
 "CCCVC"=>"",
 "CCZIP"=>"",
 "Info"=>"",
 "CustomerNumber"=>"",
 "FreqTravNum"=>"",
 "FreqGuestNum"=>"",
 "GDSRoomCode"=>"",
 "ATC"=>"",
 "BSAGENT"=>"",
 "AgentName"=>"",
 "CorpAcc"=>"",
 "ArrivalTime"=>"",
 "PCC"=>"",
 "Voucher"=>"",
 "RateAgreement"=>"",
 "WrittenConf"=>"",
 "GDSCurrency"=>"",
 "CurrencyCode"=>"",
 "IDBookingSource"=>"",
 "MarketCode"=>""}


   def self.create_booking()
     
    response = client.request("Booking") do
       client.http.headers["SOAPAction"] = "Booking"

      soap.body = {     "User"=>"string","Password"=>"string","Create"=>"string","idRSV"=>"string","PropCode"=>"string",
        "RoomCode"=>"string","RateLevel"=>"string","RateCode"=>"string","Checkin"=>"string","Checkout"=>"string",
        "Rate"=>"0.0","MealsInc"=>2,"NumRooms"=>1,"Adults"=>1,"Children"=>1,"Crib"=>1,"Remark"=>"string","Text"=>"string","Reference"=>"string","CuName"=>"string","CuFirstname"=>"string","CuTitle"=>"string",
        "CuAddress1"=>"string","CuAddress2"=>"string","CuAddress3"=>"string","CuZIP"=>"string","CuCity"=>"string",
        "CuState"=>"string","CuCountry"=>"string","CuTelephone1"=>"string","CuTelephone2"=>"string","CuTelefax"=>"string",
        "CuEmail"=>"string","CuCompany"=>"string","CuMobile"=>"string","CuNationality"=>"string","CuPassport"=>"string",
        "CuBirthDate"=>"string","CCIDCardorganisation"=>1,"CCNumber"=>"string","CCExpirydate"=>"string","CCHolder"=>"string","CCCVC"=>"string","CCZIP"=>"string","Info"=>"string","CustomerNumber"=>"string","FreqTravNum"=>"string",
         "FreqGuestNum"=>"string","GDSRoomCode"=>"string","ATC"=>"string","BSAGENT"=>"string","AgentName"=>"string",
         "CorpAcc"=>"string","ArrivalTime"=>"string","PCC"=>"string","Voucher"=>"string","RateAgreement"=>"string",
         "WrittenConf"=>"string","GDSCurrency"=>"string","CurrencyCode"=>"string","IDBookingSource"=>1,
         "MarketCode"=>"string"}
     #soap.body =  
    "<Booking xmlns='http://www.reconline.com/'>
      <User>string</User>
      <Password>string</Password>
      <Create>string</Create>
      <idRSV>string</idRSV>
      <PropCode>string</PropCode>
      <RoomCode>string</RoomCode>
      <RateLevel>string</RateLevel>
      <RateCode>string</RateCode>
      <Checkin>string</Checkin>
      <Checkout>string</Checkout>
      <Rate>float</Rate>
      <MealsInc>int</MealsInc>
      <NumRooms>int</NumRooms>
      <Adults>int</Adults>
      <Children>int</Children>
      <Crib>int</Crib>
      <Remark>string</Remark>
      <Text>string</Text>
      <Reference>string</Reference>
      <CuName>string</CuName>
      <CuFirstname>string</CuFirstname>
      <CuTitle>string</CuTitle>
      <CuAddress1>string</CuAddress1>
      <CuAddress2>string</CuAddress2>
      <CuAddress3>string</CuAddress3>
      <CuZIP>string</CuZIP>
      <CuCity>string</CuCity>
      <CuState>string</CuState>
      <CuCountry>string</CuCountry>
      <CuTelephone1>string</CuTelephone1>
      <CuTelephone2>string</CuTelephone2>
      <CuTelefax>string</CuTelefax>
      <CuEmail>string</CuEmail>
      <CuCompany>string</CuCompany>
      <CuMobile>string</CuMobile>
      <CuNationality>string</CuNationality>
      <CuPassport>string</CuPassport>
      <CuBirthDate>string</CuBirthDate>
      <CCIDCardorganisation>int</CCIDCardorganisation>
      <CCNumber>string</CCNumber>
      <CCExpirydate>string</CCExpirydate>
      <CCHolder>string</CCHolder>
      <CCCVC>string</CCCVC>
      <CCZIP>string</CCZIP>
      <Info>string</Info>
      <CustomerNumber>string</CustomerNumber>
      <FreqTravNum>string</FreqTravNum>
      <FreqGuestNum>string</FreqGuestNum>
      <GDSRoomCode>string</GDSRoomCode>
      <ATC>string</ATC>
      <BSAGENT>string</BSAGENT>
      <AgentName>string</AgentName>
      <CorpAcc>string</CorpAcc>
      <ArrivalTime>string</ArrivalTime>
      <PCC>string</PCC>
      <Voucher>string</Voucher>
      <RateAgreement>string</RateAgreement>
      <WrittenConf>string</WrittenConf>
      <GDSCurrency>string</GDSCurrency>
      <CurrencyCode>string</CurrencyCode>
      <IDBookingSource>int</IDBookingSource>
      <MarketCode>string</MarketCode>
    </Booking>
  </soap12:Body>"

    end

    response 
    
     
  end
=end  
end

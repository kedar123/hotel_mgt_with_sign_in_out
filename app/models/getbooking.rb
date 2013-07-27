require 'net/http'
require 'xmlsimple'
class Getbooking   <  ActiveRecord::Base
  # attr_accessible :title, :body
  # include Savon::Model
  
  # actions :get_bookings
  
      

  #document "http://www.reconline.com/recoupdate/update.asmx?wsdl"
  
  ############
  # i am just copied the method from the hotel plus with payment which i need to modify so that it will return an 
  # name array for available in that particular dates. which are parsed from xml of savontest
  
  # here some logic i need to change and that is as follows
  #  so for all the things what i need to do is .
  #  first i need to find all the records about that particular category
  #  first need to fetch all the records from hotel reservation through gds line  with a specified category
  #  because here there is no start and end date so again in loop of each hotel reservation through configuration fetch all the records.
  #  where there is start and end date if my start and end date is valid in it then somehow find a room number.

  #and then rest of the logic is same that is if room number is available then book that room
  #the first logic will be for finding a datewise rooms available and the second logic is for finding an actual rooms available
  #or not
    def self.check_book_room_search(checkindate,checkoutdate,roomcode)
    data = []
    booked_room = [] 
    room_name_array = []
      
    paramscheckin = Date.civil(checkindate.split("-")[0].to_i,checkindate.split("-")[1].to_i,checkindate.split("-")[2].to_i)
    paramschekout = Date.civil(checkoutdate.split("-")[0].to_i,checkoutdate.split("-")[1].to_i,checkoutdate.split("-")[2].to_i)
      
    pcid = GDS::ProductCategory.search([['name','=',roomcode]])[0]
    logger.info "44444444444444444444444444444"
    logger.info GDS::HotelReservationThroughGdsLine.find(:all,:domain=>[['categ_id','=',pcid]]).inspect
    GDS::HotelReservationThroughGdsLine.find(:all,:domain=>[['categ_id','=',pcid]]).each do |hrtgdl|  
      #here i will get an category wise rooms.
      #now through its configuration data i need to find out the comparison for dates
      #i am adding one more condition here for the purpose of if the hrtgdl is blank. this can be happen that if someone
      #deleted the hotelgdsconfiguration then the gds line name will be blank which gives an error
      if hrtgdl.name
       
        
       if paramscheckin >= hrtgdl.name.name  and paramschekout <= hrtgdl.name.to_date
          logger.info "I am her88e4"
          booked_room << hrtgdl.name
        elsif paramscheckin >= hrtgdl.name.name  and paramschekout >= hrtgdl.name.to_date  and paramscheckin <= hrtgdl.name.to_date  and hrtgdl.name.to_date >  paramschekout
       
          logger.info "I am here744"
          booked_room << hrtgdl.name
        elsif  paramscheckin <= hrtgdl.name.name  and paramschekout <= hrtgdl.name.to_date  and paramschekout >= hrtgdl.name.name    
        
          booked_room << hrtgdl.name
          logger.info "I am here4"
        elsif  paramscheckin <= hrtgdl.name.name  and paramschekout >= hrtgdl.name.to_date   
          booked_room << hrtgdl.name
          logger.info "I am here4"
          logger.info paramscheckin
        elsif  hrtgdl.name.name <= paramscheckin and hrtgdl.name.to_date <= paramschekout  and paramscheckin <= hrtgdl.name.to_date
       
          booked_room << hrtgdl.name
          logger.info "I am here5"
           logger.info paramscheckin
       end  
      end  
     end
    #so ultimetly i am getting here all the rooms which are available in this particular period. now i need to do a double check
    #in the history table that is weather this room is booked or not in this particular period.
    #now its a configuration object from which i need to findout its name and from that name the below logic can be copied 
    #as it is. so its not hotelroom but its a hotel configuration object 
    logger.info "this is gds configuration object"
    logger.info booked_room.inspect
     booked_room.each do |hotrco|
       logger.info hotrco
       logger.info "the iddddddddddd"
       logger.info hotrco.id
       logger.info hotrco.class
       logger.info "585421230.3658947"
       logger.info hotrco.line_ids.inspect
            hotrco.line_ids.each do |eliid|
              logger.info "4444444455555555556666666666"
              logger.info eliid.class
              
             #eliid.each do |room_n|
             #  logger.info "77777777888888888899999999999999999"
             #  room_n.each do |ern|
             #    logger.info "87452111111111111111111"
             #    logger.info ern.name
             #    hrbh = HotelRoomBookingHistory.search([["name","=","#{ ern.name}"]])
             #   room_name_array << ern.name
             #  if !hrbh.blank?
             #     data << hrbh
             #   end     
             #  end
             #end
             #the above loop i am changing
             logger.info eliid.name
             logger.info "sdsdsdsdsdsdsdsdsdsdsdsddsd"
                 logger.info eliid.name
                 eliid.room_number.each do |ern|
                       hrbh = GDS::HotelRoomBookingHistory.search([["name","=","#{ ern.name}"]])
                          if ern.categ_id.name == roomcode
                             room_name_array << ern.name
                          end
                      if !hrbh.blank?
                        data << hrbh
                      end     
                 end
            end            
     end
     
     
    data.flatten!  if !data.blank?
    logger.info data
    logger.info "this is dataaaaaaaaaaaaaaaaaaaaaaaaaaa"
    data = GDS::HotelRoomBookingHistory.find(data)
    #hotel room booking history data is actually filtered by all available  rooms for gds types
    data.each do |dd|
      ####2012-09-04   2012-09-13   from params
      ### 2012-09-01   2012-09-15
      ###4   params
      ####1
      if !checkindate.blank? 
        paramscheckin = Date.civil(checkindate.split("-")[0].to_i,checkindate.split("-")[1].to_i,checkindate.split("-")[2].to_i)
        paramschekout = Date.civil(checkoutdate.split("-")[0].to_i,checkoutdate.split("-")[1].to_i,checkoutdate.split("-")[2].to_i)
        logger.info "Date validationnnnnnnnnnnnnnnnnnnnn"
        logger.info paramscheckin.inspect
        logger.info paramschekout.inspect
        logger.info dd.check_in_date.inspect
        logger.info dd.check_out_date.inspect
        if paramscheckin >= dd.check_in_date  and paramschekout <= dd.check_out_date
          logger.info "I am her88e4"
          booked_room << dd
        elsif paramscheckin >= dd.check_in_date  and paramschekout >= dd.check_out_date  and paramscheckin <= dd.check_out_date  and dd.check_in_date >  paramschekout
          logger.info "I am here744"
          booked_room << dd
        elsif  paramscheckin <= dd.check_in_date  and paramschekout <= dd.check_out_date  and paramschekout >= dd.check_in_date    
          booked_room << dd
          logger.info "I am here4"
        elsif  paramscheckin <= dd.check_in_date  and paramschekout >= dd.check_out_date   
          booked_room << dd
          logger.info "I am here4"
           logger.info paramscheckin
        elsif  dd.check_in_date <= paramscheckin and dd.check_out_date <= paramschekout  and paramscheckin <= dd.check_out_date
          booked_room << dd
          logger.info "I am here5"
           logger.info paramscheckin
        end
      end
     end
    name_array = []
    #this is the room array which i need to check for category 
    booked_room.each do |rn|
      
      name_array << rn.name
      
    end
    
    logger.info "returning the array"
    logger.info "so ultimetly its returning an array of names which means that room is booked so i need to find out which room is"
    logger.info name_array    
    logger.info room_name_array
    logger.info "the roommmmmmmmmmmmarrayyyyyyyyyyyyyyyyyyy"
    available_room_name_array = room_name_array - name_array
    logger.info available_room_name_array
    #instead of returning an array find all the rooms array and send back an room object
    #so these are the available room name array. because its available from gds and from also history also
    available_room_name_array
  end

  ############
  
  
  def self.create_hotel_reservation(getbooking,shop_id,company_id)
    retval = ""
    config = XmlSimple.xml_in(getbooking.body)
    logger.info "is this get parseddddddd as xmlllllllllllll"
    logger.info config
    logger.info "i need to get bookings array lets see"
    logger.info "let see first step"
    # here i need to add one more column as gds and need to check weather this record is already added or not.if already fetched then
    # skip 
    #logger.info config["diffgram"][0]["NewDataSet"][0]["Bookings"]
    #here the actual loop get starts but for testing i am using one 
    logger.info config["diffgram"][0]["NewDataSet"][0]["Bookings"][0]["MOBILE"]
    config["diffgram"][0]["NewDataSet"][0]["Bookings"].each do |eachbkg|
      logger.info "this is email i got"
      logger.info eachbkg["EMAIL"]
        oldrec = GDS::HotelReservation.search([['gds_id','=', eachbkg["IDRSV"][0].to_s ]])[0]
        logger.info "there are some blank records"
        logger.info oldrec
        
        if oldrec.blank?
        #i am putting all the conditions here because sometimes the email is blank while creating a record  
        respart = ""
        if  eachbkg["EMAIL"].blank?
          respart = GDS::ResPartner.search([["email","=",  "gds@gmail.com"  ]])[0] 
        else
          respart = GDS::ResPartner.search([["email","=", eachbkg["EMAIL"][0].to_s ]])[0] 
        end
        newres = GDS::HotelReservation.new
        newres.partner_id = respart
        newres.partner_order_id = respart
        newres.shop_id = shop_id
        newres.source = 'through_gds'
        newres.adults = eachbkg["ADULTS"][0].to_s
        newres.childs = eachbkg["CHILDREN"][0].to_s
        
        newres.gds_id = eachbkg["IDRSV"][0].to_s
        newres.partner_invoice_id = respart
        newres.partner_shipping_id = respart
        newres.date_order = Date.today
        newres.pricelist_id = 1
        newres.printout_group_id = 1
        logger.info "this is partially done of hotel reservation" 
        logger.info "debuggging of date this is checkin"
        logger.info eachbkg['CHECKIN'].to_s
        logger.info eachbkg['CHECKIN'].to_s.split('+')
        logger.info eachbkg['CHECKIN'].to_s.split('+')[0]
        checkin = eachbkg['CHECKIN'][0].to_s.split('+')[0]
        checkin = checkin.to_s.gsub(/T/,' ')
        logger.info checkin.to_s.gsub(/T/,' ')
        newres.checkin = checkin
        #this checkout and checkin i will write more comment on it
        logger.info "this is now checkout date debug"
        logger.info eachbkg['CHECKOUT'].to_s
        logger.info eachbkg['CHECKOUT'].to_s
        logger.info eachbkg['CHECKOUT'].to_s.split('+')
        logger.info eachbkg['CHECKOUT'].to_s.split('+')[0]
        logger.info "let see up to this"
        checkout = eachbkg['CHECKOUT'][0].to_s.split('+')[0]
        checkout = checkout.to_s.gsub(/T/,' ')
        dcin = checkin.split(' ')
        newres.dummy = checkout
        doc_date = DateTime.new(dcin[0].split('-')[0].to_i,dcin[0].split('-')[1].to_i,dcin[0].split('-')[2].to_i ).ago  14.days 
        doc_date = Date.today if doc_date < Date.today
        newres.doc_date = doc_date
        newres.checkout = checkout
        newres.state = 'done'
        newres.percentage = "10"
        newres.deposit_policy = "percentage"
        newres.deposit_cost1 = "0.00"
        newres.untaxed_amt = "0.00"
        newres.save      
      logger.info "this is fully done of hotel reservation" 
      logger.info "now the hotel reservation line gets created"
      resline = GDS::HotelReservationLine.new
      resline.line_id = newres.id 
      #here i am always searching the first room because i dont want to touch openerp room creation part currently.
      #actually it should be such that whenever  we are creating an hotel in reconline at that time the same room
      #should be available in openerp
      #here a new logic is need to be implimented as discussed with parikshit.like i need to check in xml for a field
      #named weather its a king room or dbl room.according to that i first need to fetch all the records from hotel 
      #room booking history.there i will get all the booking history records with names of rooms . then what i need
      #first i need to fetch all the rooms with that particular type.
      #then take each room check if that room is booked in that particular date or not if not then 
      #book that particular room.
      #and it should not happen that the room is not available because when creating a room in openerp i will count the rooms
      #and that much i can show available in the test.reconline.com. so now the logic for booked room is i just copied
      #one method which will do this work for me.
      #first step is parse the xml send check in and checkout date to 
      
      availableroom = self.check_book_room_search(checkin,checkout,eachbkg['ROOMCODE'][0].to_s)
      #so from available rooms array i first need to fetch that product id and then need to fetch a hotel room with that particular id
      logger.info availableroom
      logger.info "availllllllllllllllllllllllllllll"
      
      #here if the availableroom is blank then i need not require to create reservation object and destroy the reservation object
      
      if availableroom.blank?
        newres.destroy
        #from here the message should get displayed that is some rooms are already booked
        retval = "Some Rooms Are Already Booked"
      else 
        logger.info availableroom
        logger.info "avaiiiiiiiiiiiiiiiiiiiiiiiii"
       prid = GDS::ProductProduct.search([['name_template','=',availableroom.first]])[0]
       logger.info prid
       logger.info "444444444444444444444"
       hrm = GDS::HotelRoom.find(:all,:domain=>[['product_id','=',prid]])[0]
       logger.info "8888888888888888888888888888888"
       logger.info hrm
       logger.info "some hrmmmmmmmmmmmmmmmmmmmm"
      resline.categ_id = GDS::HotelRoom.find(hrm.id).product_id.product_tmpl_id.categ_id.id
      resline.checkin_date_new = checkin
      #this if condition is need to be tested
       if checkin == checkout
         checkout = checkout.split(' ')[0]
        resline.checkout_date_new = checkout.to_s + " 01:00:00"
       else
        resline.checkout_date_new = checkout
       end
        checkindate = Date.civil(checkin.split("-")[0].to_i,checkin.split("-")[1].to_i,checkin.split("-")[2].to_i) 
        checkoutdate = Date.civil(checkout.split("-")[0].to_i,checkout.split("-")[1].to_i,checkout.split("-")[2].to_i)
        resline.room_number = hrm.product_id.id
        resline.price =   hrm.list_price
        logger.info "after call to hotlreservationline.wkf_action('confirm')"
        logger.info "before save of hotel reservation line method"
        resline.reservation_id = newres.id 
        resline.discount =  0
        resline.save
   logger.info "here the hotel reservation line creation is done" 
   logger.info "now here i need to do a payment related "
   logger.info "now here i am copying the code about a payment so i am copying the code about a paypal payment"
   newres = GDS::HotelReservation.find(newres.id)
   logger.info newres
   #newres.call("confirmed_reservation",[newres.id])
   newres.call("confirmed_reservation",[newres.id])
   newres.call("create_folio",[newres.id])
   
     logger.info "oneeeeeeeee+++++++++++++" 
  #   newres.call("create_folio",[newres.id])
     hf =  GDS::HotelFolio.search([["reservation_id","=",newres.id]])[0]
     hf =  GDS::HotelFolio.find(hf)
     hf.wkf_action("order_confirm")
     hf.wkf_action("manual_invoice")
     hf.invoice_ids.each do |inv|
       inv.wkf_action("invoice_open")
       inv.call("invoice_pay_customer",[inv.id])
     end
 
   newres = GDS::HotelReservation.find(newres.id)
     
      
   logger.info "here now the process get starts for creating an voucher"
   logger.info "calling account voucher"
     acv =  GDS::AccountVoucher.new
     acv.partner_id = newres.partner_id.id
     acv.pay_now = "pay_later"
     acv.state = "draft"
     acv.type = "receipt"
     acv.pre_line = true
     acv.payment_option = "without_writeoff"
     acv.comment = "Write-Off"
     acv.payment_rate = "1.000000"
     acv.payment_rate_currency_id = 1
     acv.is_multi_currency = true
     acv.account_id = 7
     acv.period_id = 10
     acv.journal_id = 8
     acv.company_id = company_id
     acv.amount =  newres.total_cost1
     acv.date = Date.today
     acv.save
     #acv.wkf_action("proforma_voucher")
     acvln = GDS::AccountVoucherLine.new
     acvln.reconcile = true
     acvln.voucher_id = acv.id
     acvln.amount_unreconciled =  newres.total_cost1
     acvln.account_id = 8
     acvln.amount = newres.total_cost1
     acvln.amount_original =  newres.total_cost1.to_f
     acvln.type =  "cr"
     if !hf.invoice_ids.blank?
        if !hf.invoice_ids.first.move_id.blank?
            if !hf.invoice_ids.first.move_id.line_id.blank?
            acvln.move_line_id = hf.invoice_ids.first.move_id.line_id.first.id 
           end
        end
     end
     acvln.name = hf.invoice_ids.first.number if !hf.invoice_ids.blank?
     acvln.save
      #acv.on_change('onchange_journal_voucher', :line_ids, tax_id, amount, partner_id, journal_id, type)
     acv.on_change('onchange_journal_voucher',[acv.id],newres.total_cost1) 
     acv.wkf_action("proforma_voucher")

      end
        else
          logger.info "this reservation is already exist"
        end
   end
   # the above is the do end
   logger.info "here all the process ends"
    
    
    retval      
   end
  
  
    
  # so ultimetly here all the partners are get created.
  def self.create_partner_if_not_created(getbooking)
    config = XmlSimple.xml_in(getbooking.body)
    
    logger.info "is this get parseddddddd as xmlllllllllllll"
    logger.info config
    logger.info "i need to get bookings array lets see"
    logger.info "let see first step"
     
    #logger.info config["diffgram"][0]["NewDataSet"][0]["Bookings"]
    #here the actual loop get starts but for testing i am using one 
    logger.info config["diffgram"][0]["NewDataSet"][0]["Bookings"][0]["MOBILE"]
    config["diffgram"][0]["NewDataSet"][0]["Bookings"].each do |eachbkg|
      
    logger.info "i need to check"
    logger.info eachbkg.inspect
    logger.info  eachbkg["CCNUMBER"]
    logger.info  eachbkg["CCEXPIRYDATE"]
    logger.info  eachbkg["CCHOLDER"]
    logger.info  eachbkg["NAME"]
    logger.info  eachbkg["FIRSTNAME"]
    logger.info  eachbkg["TITLE"]
    logger.info  eachbkg["ADDRESS1"]
    logger.info  eachbkg["ZIP"]
    logger.info  eachbkg["CITY"]
    logger.info  eachbkg["COUNTRY"]
    logger.info  eachbkg["TELEPHONE1"]
    logger.info  eachbkg["MOBILE"]
    logger.info  eachbkg["EMAIL"]
    logger.info "888888888888888888888444444444444"  
    #this is something i got new today. means a reservation is done by other people might not given a card holders name
    #that is why some times the email is also not available   and some other fields also may not available
    #that is why i am changing a little code herwe
    res = "" 
    if eachbkg["EMAIL"].blank?
      res = GDS::ResPartner.search([["email","=", "gds@gmail.com"  ]])#i am putting a default value 
    else
      res = GDS::ResPartner.search([["email","=", eachbkg["EMAIL"][0].to_s ]]) 
    end
    
    
    if res.blank?
       @respart =  GDS::ResPartner.new 
       
       #i am assigning here a name by three ways if ccholder is blank then try by name 
       name = ""
       
       #as here the  customer will be global so the company id is blank 
       res.company_id = ''  
         
       if  !eachbkg["CCHOLDER"].blank?
         name = eachbkg["CCHOLDER"][0].to_s
       end
        
       if name.blank? 
       if !eachbkg["FIRSTNAME"].blank?
           name = eachbkg["FIRSTNAME"][0].to_s
       end
       end
       if name.blank? 
       if !eachbkg["NAME"].blank?
           name = eachbkg["NAME"][0].to_s
       end
       end
        
       if name.blank?
       if name.blank?
          name = "gds"
       end 
       end
       
         
         @respart.name =  name
        
       
       
       @respart.type = 'invoice'
        if eachbkg["EMAIL"].blank?
          @respart.email =  "gds@gmail.com"
        else
          @respart.email = eachbkg["EMAIL"][0].to_s
        end
        
        if !eachbkg["TELEPHONE1"].blank?
               @respart.phone = eachbkg["TELEPHONE1"][0].to_s
        end
        if !eachbkg["ADDRESS1"].blank?
          @respart.street = eachbkg["ADDRESS1"][0].to_s
        end
       if !eachbkg["CITY"].blank?
         @respart.city = eachbkg["CITY"][0].to_s
       end
       
       if !eachbkg["ZIP"].blank?
         @respart.zip = eachbkg["ZIP"][0].to_s
       end
       
       @respart.save   
     
    end  
      
      
      
    end
    
       
    
 
  end
  
      
  def self.get_bookings(params)
    # super("User"=>"string","Password"=>"string","idHotel"=>"string","idSystem"=>"string","ForeignPropCode"=>"string",
    #     "idRSV"=>"string","StartDate"=>"string", "EndDate"=>"string","StartCreationDate"=>"string","EndCreationDate"=>"string").to_hash  end
     uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetBookings')
     res = Net::HTTP.post_form(uri, "User"=>params[:User],"Password"=>params[:Password],"idHotel"=>params[:idHotel],
      "idSystem"=>params[:idSystem],"ForeignPropCode"=>params[:ForeignPropCode],
      "idRSV"=>params[:idRSV],"StartDate"=>params[:StartDate], "EndDate"=>params[:EndDate],
      "StartCreationDate"=>params[:StartCreationDate],"EndCreationDate"=>params[:EndCreationDate])
     logger.info "the paaramsmsmsms"
    logger.info res.inspect
    logger.info res.to_hash
     logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
    logger.info res.body
    res.to_hash
    res  
  end
  
  
  
  
  
end

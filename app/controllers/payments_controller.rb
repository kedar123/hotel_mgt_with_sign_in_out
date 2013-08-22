class PaymentsController < ApplicationController
   include ActiveMerchant::Billing
   require 'net/http'
   layout 'web_layout'
    before_filter :check_connection
  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
  end

  def convert_currency(from_curr = "INR", to_curr = "USD", amount = 1000)
    host = "www.google.com"
    http = Net::HTTP.new(host, 80)
    url = "/finance/converter?a=#{amount}&from=#{from_curr}&to=#{to_curr}"
    response = http.get(url)
    # puts response.body
    result = response.body
    regexp = Regexp.new("(\\d+\\.{0,1}\\d*)\\s+#{to_curr}")
    regexp.match result
    return $1.to_f
 end
 

  
  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render json: @payment, status: :created, location: @payment }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end
  
  #this page is same as 4000 page of paypal. so here i am putting all the code which is same as in my last controller
  #room type. now here i need to cp[y the code just for the purpose of creating an amount.so just check line by line.
  #here in preview what i need to show is user name and checkin and checkout and price and room names
  
  def preview_payment
    #just check an dates
    #check dummy
        @roombarname = []
        @respartner = ResPartner.find(session[:user_id_avail])
        @resname = @respartner.name
        session[:amount] = nil
        @newres = HotelReservation.new
        @newres.partner_id = session[:user_id_avail]
        @newres.partner_order_id = session[:user_id_avail]
        @newres.shop_id = 1
        @newres.partner_invoice_id = session[:user_id_avail]
        @newres.partner_shipping_id = session[:user_id_avail]
        @newres.date_order = Date.today
        @newres.pricelist_id = 1
        @newres.printout_group_id = 1
        @newres.source = 'through_web'
        checkindate = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split(':')[1].to_i )
        checkoutdate = DateTime.new(session[:checkout].split(' ')[0].to_s.split('/')[2].to_i,session[:checkout].split(' ')[0].to_s.split('/')[0].to_i,session[:checkout].split(' ')[0].to_s.split('/')[1].to_i,session[:checkout].split(' ')[1].to_s.split(':')[0].to_i,session[:checkout].split(' ')[1].to_s.split(':')[1].to_i )
        zone = ActiveSupport::TimeZone.new("Asia/Kolkata")
        tmzci=Time.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split(':')[1].to_i)
        tmzco=Time.new(session[:checkout].split(' ')[0].to_s.split('/')[2].to_i,session[:checkout].split(' ')[0].to_s.split('/')[0].to_i,session[:checkout].split(' ')[0].to_s.split('/')[1].to_i,session[:checkout].split(' ')[1].to_s.split(':')[0].to_i,session[:checkout].split(' ')[1].to_s.split(':')[1].to_i)
        tmzutcin= tmzci.in_time_zone("UTC")
        tmzutcout= tmzco.in_time_zone("UTC")
        @newres.checkin =  tmzutcin
        @newres.checkout = tmzutcout
        @newres.dummy = session[:checkout]
        DateTime.new#ymdh
        if session[:checkin].blank?
          redirect_to root_url ,:notice=>'Your Session Is Expired Please Select Room Again' and return;
        end
        logger.info "checkinnnnnnnnnnnnnnnnnnnnnnnnnnn"
        logger.info session[:checkin]
        logger.info session[:checkout]
        doc_date = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split('/')[1].to_i ).ago  14.days 
        doc_date = Date.today if doc_date < Date.today
        @newres.doc_date = doc_date
        @newres.save   
        #when i copied this code i think i forget to copy a session[:newlysavedreservationid] variable which is required
        #after paypal payments complete a payment
        #session[:newlysavedreservationid] = @newres.id
        logger.info session["selectedroom"]
        logger.info "sessionnnnnnnnnnnnnnnnnn"
        if session["selectedroom"]
           session["selectedroom"].each do |roomid|
           resline = HotelReservationLine.new
           resline.line_id = @newres.id 
           hrm = HotelRoom.search([["product_id","=",roomid[0].to_i]])[0]
           resline.categ_id = HotelRoom.find(hrm).product_id.product_tmpl_id.categ_id.id
           @roombarname << HotelRoom.find(hrm).product_id.name
           resline.room_number = roomid[0].to_i
           resline.price =  ProductProduct.find(roomid[0].to_i).product_tmpl_id.list_price.to_f
           resline.reservation_id = @newres.id 
           logger.info resline.save
           session["#{resline.room_number.name}"] = 0
           logger.info "an reservation lineeeeeeeeeeeeeeeeeeeee"
           logger.info checkoutdate
           logger.info checkindate
           logger.info (checkoutdate - checkindate).to_i
           #here need to check an checkout policy for this particular shop. there are 2 possibilities one 
           #is 24 hr e.g room price is 1000
           #so oif the checkin date is 1-1-2013 8 am and checkout is at 3-1-2013 at 7pm clock so the price will be
           #1-1-2013  8am to 2-1-2013 8am = 1000
           #2-1-2013  8am to 3-1-2013 8am = 1000
           #3-1-2013  8am to 3-1-2013 7pm = 1000
           #so the total is  3000
           #here i need to first find out which shop is this i can find that by the company available
           #here in an session i need to find out which co is there and take the first 
            cknp = CheckoutConfiguration.find(:all,:domain=>[['shop_id','=',1]]).first.name
           if cknp == "24hour"
             #here i am copying checkin and checkout variables so that it will not make any conflict in its current flow
             checkindfortd = checkindate
             checkoutdfortd = checkoutdate
              #dtd = Time.diff(checkindfortd,checkoutdfortd)
              #here i need to do a calculation as follows.
             #if its a month then get that much days in month and multiply by that much with price
             #here i need to take current date and find out the days remaining in that particular month
             #ultimetly what i need to do is get every day and month in houres so i use the logic that each day is of 24 hrs
             #therefore if the day difference is 0 then whatever may be the oures i should charge an 1 day cost.
             #then if there is day difference then get the month then get the start date of month 
             ###################################################################################
             #just changing the logic in mind here instead of getting and month and calculating an days.
             #lets go next day untile its equivalent to checkout date.and each day add one price. and lastly check an hour
             #another simple logic is i should go on increasing the days untile i get that checkindate is greater than
             #checkout dateand each day i should increase an amount
                    #if the difference between months start and end date is 0 then consider it as 1 day price
            while checkindfortd < checkoutdfortd
                 session[:amount] = session[:amount].to_i + resline.price.to_i 
                 session["#{resline.room_number.name}"] = session["#{resline.room_number.name}"].to_i + resline.price.to_i
                 checkindfortd = checkindfortd.next_day
            end  
            else
             if ((checkoutdate - checkindate).to_i == 0) 
                 logger.info "some errporrrrrrrrrrrrrrrr as value is zero"
                  session[:amount] = session[:amount].to_i +   resline.price.to_i    
                  session["#{resline.room_number.name}"] = session["#{resline.room_number.name}"].to_i + resline.price.to_i
                   logger.info session[:amount]
             else
                session[:amount] = session[:amount].to_i +  (resline.price.to_i * (checkoutdate - checkindate).to_i )
                session["#{resline.room_number.name}"] = session["#{resline.room_number.name}"].to_i + (resline.price.to_i * (checkoutdate - checkindate).to_i )
                logger.info session[:amount].to_i
                logger.info "sssssssssss"
                logger.info resline.price.to_i
                logger.info "prrrrrrrrrrrrrrrrrr"
                logger.info (checkoutdate - checkindate).to_i
                logger.info "checkout date is longer"
                logger.info session[:amount]
             end
             end
            end
        end
       #here i am just putting an note that is in previous code what i have done is calculated a price i think instead of that
       #after a reservation i can directly get an price. 
       #yes but i am wrong here means what i feel is without calling an function on reservation or reservation line. the price 
       #is even not get calculated 
        @newres.reload
        @newres.reload
        #i seen a problem here that is the reservation line is always blank in view
        #so i will create a 
        logger.info @newres
        logger.info "newressssssssssssss"
        #now here i need to add a code for currency converter. so here first i need to check with paypal if that 
        #currency code matches if yes then there is no need to change.otherwise change it to usd.
        @currencyname = "USD"
        if ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
          @currencyname = ResCurrency.find(:all,:domain=>[['base','=',true]])[0].name     
        end
        #here also i need to add one more conditions.if the conversion takes place then show it in view
        available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
        #if the currency is not included in this array and its also not as usd then show the usd conversion rate
        if available_paypal_array.include?(@currencyname)
        elsif @currencyname == "USD"
        else
          #here is a transferred rate
          usdr = ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
          @convert_amount = session[:amount].to_i * usdr.rate
        end
      #i am deleting here the newly created reservation id as here there is an unnecessary record is get created
      #suppose an user dosent paid the amount then its unnecessary record is get created
      @newres.destroy 
   end
   
   
  
    def call_create_hotel_reservation_with_reservation_line()
    #need to find values from database and need to create hotel reservation and reservation lines
    logger.info "inserting the record in Hotel reservation"
    logger.info "i am nillll"
    logger.info session[:newlysavedreservationid].inspect
    logger.info "i am nillll123"
    #@ooor = Ooor.new(:url => 'http://144.76.6.143:8069/xmlrpc', :database => session[:database_name], :username =>'admin', :password   => 'praghotel',:scope_prefix => session[:database_name].to_s.upcase.to_s)      #p "Connected to opererp database"
     logger.info "this is wrong constant nameeeee"
     logger.info session[:database_name]
     logger.info "this is infooooooooooooooooooooo"
      @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => session[:database_name], :username =>'admin', :password   => 'admin',:scope_prefix => session[:database_name].to_s.upcase.to_s)      #p "Connected to opererp database"
 
    #resv = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(session[:newlysavedreservationid])
    #i am wrong here somewhere in my last coding as i think here there is no need to create another object of hotel reservation
    #if its already done in previous method or flow.
    #@hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.new
    #@hotel.partner_id = resv.partner_id.id
    #@hotel.partner_order_id = resv.partner_invoice_id.id
    logger.info "inserting the record in Hotel reservation5855"
    #@hotel.shop_id = 1
    #@hotel.partner_invoice_id = resv.partner_invoice_id.id
    #@hotel.partner_shipping_id = resv.partner_shipping_id.id
    #@hotel.date_order = Date.today
    logger.info "inserting the record in Hotel reserva7844tion"
    #@hotel.pricelist_id = 1
    #@hotel.printout_group_id = 1
    
    #@hotel.checkin = resv.checkin
    #@hotel.checkout = resv.checkout
    #@hotel.source = 'through_web'
   
    
    logger.info "this is checkout date"
    
    logger.info "inserting the record in Hotel reserva78542tion"
    #@hotel.dummy = resv.dummy
     
    #@hotel.note = resv.note
    #@hotel.state = 'done'
    logger.info "inserting the record in Hotel reservati87452on"
    #@hotel.percentage = "10"
    #@hotel.deposit_policy = "percentage"
    #@hotel.deposit_cost1 = "0.00"
    #@hotel.total_service_amount = "0.00"
    #@hotel.untaxed_amt = "0.00"
    
    #@hotel.doc_date = resv.doc_date
            
    logger.info "Before hotel reservation save data"
    #logger.info @hotel.save 
    logger.info "after save check the @hotel"
    
    
    #session[:newlysavedreservationid] = nil
    #the hotel reservation is get created and then the reservation line is i am creating
    #also i am commenting here because these code is also i think is unnecessary.because its already done.
  #  resv.reservation_line.each do |resline|
       logger.info "ddddddddddd"
 #     hotlreservationline = eval(session[:database_name].to_s.upcase.to_s)::HotelReservationLine.new
      logger.info "6854646as"
       
     
 #     hotlreservationline.line_id = @hotel.id 
      logger.info "685dddadas4646as"
 #     hrm = eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.search([["product_id","=",resline.room_number.id]])[0]
       
      
#      hotlreservationline.categ_id = eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.find(hrm).product_id.product_tmpl_id.categ_id.id
      logger.info "56s46sa4d654d65"
#      hotlreservationline.checkin = resline.checkin
  
#       hotlreservationline.checkout = resline.checkout
   
      
   
#      hotlreservationline.room_number = resline.room_number.id
      
#      hotlreservationline.price =  resline.price
 #     hotlreservationline.discount =  0
     
      
      logger.info "after call to hotlreservationline.wkf_action('confirm')"
      logger.info "before save of hotel reservation line method"
 #     logger.info hotlreservationline.save
      #hotel = HotelReservation.find(hotel)
      #hotel.wkf_action('confirm')
     
      logger.info "after call to hotel.wkf_action('confirm')"
      #here need to get the total amount for payment
       
      
      logger.info "after reservation line saved"
 #   end
              
              
    logger.info "After successful hotel reservation data saved"

  end
  
  def checkout
    begin
   logger.info "amoint"
   logger.info params[:amount].to_i * 100
   logger.info request.remote_ip
   logger.info url_for(:action => 'confirm', :only_path => false)
   logger.info url_for(:action => 'index', :only_path => false)
   #here i need to show a dynamic currency . following are the available currency type available in paypal so if the
   #openerp currency is matched with this array then assign it else convert it in usd and send it as usd.
   available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
   paypal_currency = "USD"
   base_currency = ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
   #if its come to else then i need to convert the amount to usd as its default
   #when it goes to paypal i am multiplying it by 100 . 
   paypal_amount = params[:amount].to_i
   @multiplybyusrates = false
   if base_currency &&  available_paypal_array.include?(base_currency.name)
       paypal_currency = base_currency.name
       paypal_amount = params[:amount].to_i * 100
       #when its different currency then no need to translate it to * by 100
   else
     #i assume that if its not included in paypal array and if the currency is not usd then convert it to usd
     if base_currency && base_currency.name == "USD"
       paypal_amount = paypal_amount  * 100#usd 
     else
       logger.info "paypal amount5555555544444444"
       logger.info "base currency is not defined"
       logger.info ResCurrency.find(:all,:domain=>[['name','=', 'USD']])[0].rate
       logger.info paypal_amount
       #here it will come in 2 situations.1)when there is no base currency is defined.and 2)
       #when e.g. there is inr currency
       if base_currency
         @multiplybyusrates = true
         paypal_amount = (paypal_amount  * ResCurrency.find(:all,:domain=>[['name','=', 'USD']])[0].rate)*100
       else
         paypal_amount = paypal_amount  * 100
       end 
     end
   end
   logger.info "the paypal currency defined"
   logger.info paypal_currency
   logger.info "the paypal currency defined12333333333333333333333"
   #hores  =  HotelReservation.find(params[:newlysavedreservationid])
   logger.info "this is from start checkout"
   room_name = []
   @item_hash_array = []
   checkout_hotel_reservation
   logger.info "here at last the the from checkout is from checkout"
   
   logger.info "there is no reservation line is definedddddddd"
   logger.info @hotelc 
   logger.info @hotelc.id 
   
   
   logger.info @hotelc.reservation_line
   logger.info "the count array"
   logger.info @hotelc.reservation_line.count
    
   logger.info @item_hash_array
   @hotelc.destroy
   
   logger.info "itemmmmmmmmmmmmmmmmmmm111111111111111111111111"
   
   logger.info paypal_amount
   logger.info "paypal amounttttttttttt"
   logger.info @multiplybyusrates
   logger.info "multiplybyusrates"
   setup_response = gateway.setup_purchase(paypal_amount,
    :items => @item_hash_array, 
    :ip                => request.remote_ip,
    :return_url        => url_for(:action => 'confirm', :only_path => false),
    :cancel_return_url => url_for(:action => 'cancel', :only_path => false),
    :currency => paypal_currency
    )
 logger.info "this is set up responseaaa"
 logger.info setup_response.inspect
  session[:amount] = params[:amount]
  #session[:newlysavedreservationid] =  params[:newlysavedreservationid]
  session[:database_name] = session[:database_name]
  
  #its because the session is not working here so i am assiging a token to a database and inserting a token with database name
  #in the complete i will find its values from database and then assiging a session value because its complete code is written in
  #session variable onlyyyyyyyy
  #session[:room_no] = params[:room_no]
  #session[:res_part] = params[:res_part]
  #session[:res_part_add] = params[:res_part_add]
  p "is the session is available"
  p session[:database_name]
  #here ip addtess means a uniq token return by paypal for each transactions.
  #as there is some problem in keeping the track of session[:database_name]. and also in this current situation the database_name
  # is fixed so i am just removing an session[:database_name] and keeping static name
  Ipbasesdb.create(:dbname=>"hotel_kedar_1" ,:ipaddress=>setup_response.token) 
   logger.info "redirecting to checkout "
  # @hotelc.destroy
  redirect_to gateway.redirect_url_for(setup_response.token)
    rescue =>e
       @my_logger ||= Logger.new("#{Rails.root}/log/onlygdsandweb.log")
    
        logger.info "there is problem in connection"
       logger.info e
       logger.info e.message
       logger.info e.inspect
       @my_logger.info "this is new error"
       @my_logger.info Time.now
       
       @my_logger.info e.message
       @my_logger.info e.inspect
       redirect_to root_url ,:notice=>"Error in network connection"
    end
  end   
    
    
    
    #this code i am keeping as it is because there is no need to hide anything
     def call_create_saleorder_and_invoice(hotelres)
      hotelres.call("confirmed_reservation",[hotelres.id])
      acm = eval(session[:database_name].to_s.upcase.to_s)::AccountMove.new
      acm.journal_id = eval(session[:database_name].to_s.upcase.to_s)::AccountJournal.search([['type','=','bank']])[0]
      acm.company_id = hotelres.company_id.id
      acm.ref = hotelres.reservation_no
      acm.save
      acm.reload
      acml = eval(session[:database_name].to_s.upcase.to_s)::AccountMoveLine.new
      acml.move_id = acm.id
      acml.name = hotelres.reservation_no
      acml.partner_id = hotelres.partner_id.id
      acml.account_id = hotelres.partner_id.property_account_receivable.id
      acml.credit = hotelres.total_cost1
      acml.debit = 0
      acml.status = 'draft'
      base_currency = ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
      available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
      if base_currency
         acml.currency_id = base_currency.id
         if  available_paypal_array.include?(base_currency.name)
             acml.amount_currency = "-"+(hotelres.total_cost1).to_s
        elsif base_currency.name == "USD"
             acml.amount_currency = "-"+(hotelres.total_cost1).to_s
        else
                 convertrateusd = ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
                 acml.currency_id = convertrateusd.id
                 acml.amount_currency = "-"+(hotelres.total_cost1 * convertrateusd.rate).to_s
        end
     else
      convertrateusd = ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
      acml.currency_id = convertrateusd.id
      acml.amount_currency = "-"+(hotelres.total_cost1 ).to_s
     end
     acml.save
     acml = eval(session[:database_name].to_s.upcase.to_s)::AccountMoveLine.new
     acml.move_id = acm.id
     acml.name = hotelres.reservation_no
     acml.partner_id = hotelres.partner_id.id
     acml.account_id =  eval(session[:database_name].to_s.upcase.to_s)::AccountJournal.find(eval(session[:database_name].to_s.upcase.to_s)::AccountJournal.search([['type','=','bank']])[0]).default_debit_account_id.id
     acml.debit = hotelres.total_cost1
     acml.credit = 0
      if base_currency
         acml.currency_id = base_currency.id
          if available_paypal_array.include?(base_currency.name)
             acml.amount_currency = hotelres.total_cost1
        elsif base_currency.name == "USD"
             acml.amount_currency = hotelres.total_cost1
        else
                convertrateusd = ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
                acml.currency_id = convertrateusd.id
                acml.amount_currency = hotelres.total_cost1 * convertrateusd.rate
         end
      else
       default_cur =  ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
       acml.currency_id = default_cur.id
        acml.amount_currency = hotelres.total_cost1 
     end
      acml.status = 'draft'
      acml.save
   end
  
     #here an timeout error can occure if internet is slow then i will redirect it to root_url and note this error in log
     #and a special log file
  def confirm
     begin
         
        redirect_to :action => 'index' unless params[:token]
        session[:database_name] = Ipbasesdb.find_by_ipaddress(params[:token]).dbname 
        logger.info "i just seen one error where the constant is uninitialize for session[:database_name] that is why makking "
        logger.info "an connection again"
     @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => session[:database_name], :username =>'admin', :password   => 'admin',:scope_prefix => session[:database_name].to_s.upcase.to_s)      #p "Connected to opererp database"
     logger.info "created a record in confirm state again need to destroy it"
     create_hotel_reservation
     #@hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(session[:newlysavedreservationid])
     #i am taking this into another variables because sometimes in view this ooor @hotel object is not availabel
     @checkin = @hotel.checkin
     @checkout = @hotel.checkout
    
     @resname = @hotel.partner_id.name
   
     details_response = gateway.details_for(params[:token])
     if !details_response.success?
        @message = details_response.message
        render :action => 'error'
        return
     end
     @address = details_response.address
       @currencyname = "USD"
        if ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
          @currencyname = ResCurrency.find(:all,:domain=>[['base','=',true]])[0].name     
        end
        #here also i need to add one more conditions.if the conversion takes place then show it in view
        available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
        #if the currency is not included in this array and its also not as usd then show the usd conversion rate
        if available_paypal_array.include?(@currencyname)
        elsif @currencyname == "USD"
        else
          #here is a transferred rate
          usdr = ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
          @convert_amount = session[:amount].to_i * usdr.rate
        end
        @hotel.destroy 
     rescue => e
         @my_logger ||= Logger.new("#{Rails.root}/log/onlygdsandweb.log")
    
        logger.info "there is problem in connection"
       logger.info e
       logger.info e.message
       logger.info e.inspect
       @my_logger.info "this is new error"
       @my_logger.info Time.now
       
       @my_logger.info e.message
       @my_logger.info e.inspect
       redirect_to root_url ,:notice=>"Error In Network Connection"
      end
  end
  
  
  def cancel
       render :layout=>false
  end
   
  
  def get_transaction_details
    if params[:transaction_id]
      @transactiodetails = gateway.transaction_details(params[:transaction_id]).inspect
       
    end
     
  end
  
  
   def complete
     
      base_currency = eval(session[:database_name].to_s.upcase.to_s)::ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
      available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
 
     if base_currency
       #here one condition is need to be added and that is if the currency is not available in paypal array.
       #then i am sending it as usd so the currency name is usd
       if available_paypal_array.include?(base_currency.name)
           base_currency = base_currency.name
       else
          base_currency = "USD"
       end
     end
        logger.info "this amt"
        logger.info session[:amount].to_i
        logger.info base_currency
        logger.info "sssssssssssssssssss"
     paypal_amount =    session[:amount].to_i  
     
     ##################eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
   #
        base_currencyc = eval(session[:database_name].to_s.upcase.to_s)::ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
 
 if base_currencyc &&  available_paypal_array.include?(base_currencyc.name)
      
       paypal_amount = session[:amount].to_i * 100
       #when its different currency then no need to translate it to * by 100
   else
     #i assume that if its not included in paypal array and if the currency is not usd then convert it to usd
     if base_currencyc && base_currencyc.name == "USD"
       paypal_amount = paypal_amount  * 100#usd 
     else
       logger.info "paypal amount5555555544444444"
       logger.info "base currency is not defined"
       logger.info ResCurrency.find(:all,:domain=>[['name','=', 'USD']])[0].rate
       logger.info paypal_amount
       #here it will come in 2 situations.1)when there is no base currency is defined.and 2)
       #when e.g. there is inr currency
       if base_currencyc
        
         paypal_amount = (paypal_amount  * ResCurrency.find(:all,:domain=>[['name','=', 'USD']])[0].rate)*100
       else
         paypal_amount = paypal_amount  * 100
       end 
     end
   end    ##################3333eeeeeeeee
     
    purchase = gateway.purchase(paypal_amount,
    :ip       => request.remote_ip,
    :payer_id => params[:payer_id],
    :token    => params[:token],
    :currency => base_currency
  )
  logger.info "purchasing amount"
  logger.info session[:amount]
  logger.info session[:amount]
  
   
  
   
  logger.info purchase.inspect
  logger.info "transaction idddddd54215845"
  logger.info "purchaseeeeeeee"
  if !purchase.success?
    logger.info "purchaseeeeeeeeeeee"
    logger.info purchase
   logger.info @message = purchase.message
    render :action => 'error'
    logger.info purchase.inspect
    logger.info purchase.message
    logger.info "i need to render errorororro"
    return
  else
    
      begin
      session[:database_name] = Ipbasesdb.find_by_ipaddress(params[:token]).dbname  
       #@h=HotelReservation.search([["reservation_no","=",session[:room_no]]])[0]
       #@h=HotelReservation.find(@h)
       #@h.state = 'done'
       #@h.save
        # call_create_saleorder_and_invoice(@h)
        logger.info "12344444444444444444444"
       call_create_hotel_reservation_with_reservation_line()
       #begin
       logger.info "after all the hotel get savedddd"
       
       logger.info "after all the hotel get savedddd"
       logger.info session[:newlysavedreservationid]
       #@hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(session[:newlysavedreservationid])
       #here some method is get called which will create an @hotel variable
       create_hotel_reservation()
       #@hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(@hotel.id)
       @resname = @hotel.partner_id.name
         logger.info @hotel.inspect
         call_create_saleorder_and_invoice(@hotel)
        @reservation_no = @hotel.reservation_no
       #flash[:notice] ="You Have Now Made A Successful Purchased. Your Booking Reference Is:"+@hotel.reservation_no if @hotel
        Notifier.complete_reservation(@hotel.partner_id.email,"Room Has Been Booked Successfully. Your Booking Reference Is:"+@hotel.reservation_no).deliver if @hotel
         logger.info "i am here after successful reservation"
          session[:amount] = nil
          session[:newlysavedreservationid] = nil
           session["campany_id"] =  nil
    session["checkin"] = nil
    session["checkout"] = nil
    session["selectedroom"] = nil
    session[:database_name] = nil
  #session[:room_no] = nil
  #session[:res_part] = nil
  #session[:res_part_add] = nil
         #this small change i will need to do here and that is instead of redirecting it i will just show
         # a successfull payment page
         #redirect_to :controller=>"reservation",:action=>"room_type"
         
       rescue => e
     @my_logger ||= Logger.new("#{Rails.root}/log/onlygdsandweb.log")
    
        logger.info "there is problem in connection"
       logger.info e
       logger.info e.message
       logger.info e.inspect
       @my_logger.info "this is new error"
       @my_logger.info Time.now
       
       @my_logger.info e.message
       @my_logger.info e.inspect
       #params[:token]
       #session[:newlysavedreservationid] hotel reservation id stored in session
           
  @respartner = eval(session[:database_name].to_s.upcase.to_s)::ResPartner.find(session[:user_id_avail])
    
  partner_name = @respartner.name 
  checkindate = session[:checkin]
  checkoutdate = session[:checkout]
  roomname = []
  converted_amt = ""
  session["selectedroom"].each do |roomid|
            hrm = eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.search([["product_id","=",roomid[0].to_i]])[0]
            roomname << eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.find(hrm).product_id.name
  end
         
         
  
  amount = session[:amount] 
     @currencyname = "USD"
        if eval(session[:database_name].to_s.upcase.to_s)::ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
          @currencyname = eval(session[:database_name].to_s.upcase.to_s)::ResCurrency.find(:all,:domain=>[['base','=',true]])[0].name     
        end
        #here also i need to add one more conditions.if the conversion takes place then show it in view
        available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
        #if the currency is not included in this array and its also not as usd then show the usd conversion rate
        if available_paypal_array.include?(@currencyname)
        elsif @currencyname == "USD"
        else
          #here is a transferred rate
          usdr = eval(session[:database_name].to_s.upcase.to_s)::ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
          converted_amt  = session[:amount].to_i * usdr.rate
        end
  
  paypal_transaction_id = purchase.params['transaction_id']
  
       Notifier.paypal_error_message(partner_name,checkindate,checkoutdate,roomname.join(', '),amount,converted_amt,paypal_transaction_id,@currencyname).deliver  
      
       redirect_to root_url ,:notice=>"Error In Network Connection"
       end
  end
  
  end
  
  
  def checkout_hotel_reservation
    logger.info "checkout_hotel_reservaton11"
      @roombarname = []
        @respartner = ResPartner.find(session[:user_id_avail])
        @resname = @respartner.name
        session[:amount] = nil
        @hotelc = HotelReservation.new
        @hotelc.partner_id = session[:user_id_avail]
        @hotelc.partner_order_id = session[:user_id_avail]
        @hotelc.shop_id = 1
        @hotelc.partner_invoice_id = session[:user_id_avail]
        @hotelc.partner_shipping_id = session[:user_id_avail]
        @hotelc.date_order = Date.today
        @hotelc.pricelist_id = 1
        @hotelc.printout_group_id = 1
        @hotelc.source = 'through_web'
        checkindate = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split(':')[1].to_i )
        checkoutdate = DateTime.new(session[:checkout].split(' ')[0].to_s.split('/')[2].to_i,session[:checkout].split(' ')[0].to_s.split('/')[0].to_i,session[:checkout].split(' ')[0].to_s.split('/')[1].to_i,session[:checkout].split(' ')[1].to_s.split(':')[0].to_i,session[:checkout].split(' ')[1].to_s.split(':')[1].to_i )
        zone = ActiveSupport::TimeZone.new("Asia/Kolkata")
        tmzci=Time.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split(':')[1].to_i)
        tmzco=Time.new(session[:checkout].split(' ')[0].to_s.split('/')[2].to_i,session[:checkout].split(' ')[0].to_s.split('/')[0].to_i,session[:checkout].split(' ')[0].to_s.split('/')[1].to_i,session[:checkout].split(' ')[1].to_s.split(':')[0].to_i,session[:checkout].split(' ')[1].to_s.split(':')[1].to_i)
        tmzutcin= tmzci.in_time_zone("UTC")
        tmzutcout= tmzco.in_time_zone("UTC")
        @hotelc.checkin =  tmzutcin
        @hotelc.checkout = tmzutcout
        @hotelc.dummy = session[:checkout]
        DateTime.new#ymdh
        if session[:checkin].blank?
          redirect_to root_url ,:notice=>'Your Session Is Expired Please Select Room Again' and return;
        end
        logger.info "checkinnnnnnnnnnnnnnnnnnnnnnnnnnn"
        logger.info session[:checkin]
        logger.info session[:checkout]
        doc_date = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split('/')[1].to_i ).ago  14.days 
        doc_date = Date.today if doc_date < Date.today
        @hotelc.doc_date = doc_date
        @hotelc.save   
        #when i copied this code i think i forget to copy a session[:newlysavedreservationid] variable which is required
        #after paypal payments complete a payment
        #session[:newlysavedreservationid] = @newres.id
        logger.info session["selectedroom"]
        logger.info "sessionnnnnnnnnnnnnnnnn777777777n"
        if session["selectedroom"]
           session["selectedroom"].each do |roomid|
           resline = HotelReservationLine.new
           resline.line_id = @hotelc.id 
           hrm = HotelRoom.search([["product_id","=",roomid[0].to_i]])[0]
           resline.categ_id = HotelRoom.find(hrm).product_id.product_tmpl_id.categ_id.id
           @roombarname << HotelRoom.find(hrm).product_id.name
           resline.room_number = roomid[0].to_i
           resline.price =  ProductProduct.find(roomid[0].to_i).product_tmpl_id.list_price.to_f
           resline.reservation_id = @hotelc.id 
           logger.info resline.save
           resline.reload
           session["#{resline.room_number.name}"] = 0
           logger.info "an reservation lineeeeeeeeeeeeeeeeeeeee"
           logger.info checkoutdate
           logger.info checkindate
           logger.info (checkoutdate - checkindate).to_i
           #here need to check an checkout policy for this particular shop. there are 2 possibilities one 
           #is 24 hr e.g room price is 1000
           #so oif the checkin date is 1-1-2013 8 am and checkout is at 3-1-2013 at 7pm clock so the price will be
           #1-1-2013  8am to 2-1-2013 8am = 1000
           #2-1-2013  8am to 3-1-2013 8am = 1000
           #3-1-2013  8am to 3-1-2013 7pm = 1000
           #so the total is  3000
           #here i need to first find out which shop is this i can find that by the company available
           #here in an session i need to find out which co is there and take the first 
            cknp = CheckoutConfiguration.find(:all,:domain=>[['shop_id','=',1]]).first.name
           if cknp == "24hour"
             #here i am copying checkin and checkout variables so that it will not make any conflict in its current flow
             checkindfortd = checkindate
             checkoutdfortd = checkoutdate
              #dtd = Time.diff(checkindfortd,checkoutdfortd)
              #here i need to do a calculation as follows.
             #if its a month then get that much days in month and multiply by that much with price
             #here i need to take current date and find out the days remaining in that particular month
             #ultimetly what i need to do is get every day and month in houres so i use the logic that each day is of 24 hrs
             #therefore if the day difference is 0 then whatever may be the oures i should charge an 1 day cost.
             #then if there is day difference then get the month then get the start date of month 
             ###################################################################################
             #just changing the logic in mind here instead of getting and month and calculating an days.
             #lets go next day untile its equivalent to checkout date.and each day add one price. and lastly check an hour
             #another simple logic is i should go on increasing the days untile i get that checkindate is greater than
             #checkout dateand each day i should increase an amount
                    #if the difference between months start and end date is 0 then consider it as 1 day price
            while checkindfortd < checkoutdfortd
                 session[:amount] = session[:amount].to_i + resline.price.to_i 
                 session["#{resline.room_number.name}"] = session["#{resline.room_number.name}"].to_i + resline.price.to_i
                 checkindfortd = checkindfortd.next_day
            end  
            else
             if ((checkoutdate - checkindate).to_i == 0) 
                 logger.info "some errporrrrrrrrrrrrrrrr as value is zero"
                  session[:amount] = session[:amount].to_i +   resline.price.to_i    
                  session["#{resline.room_number.name}"] = session["#{resline.room_number.name}"].to_i + resline.price.to_i
                   logger.info session[:amount]
             else
                session[:amount] = session[:amount].to_i +  (resline.price.to_i * (checkoutdate - checkindate).to_i )
                session["#{resline.room_number.name}"] = session["#{resline.room_number.name}"].to_i + (resline.price.to_i * (checkoutdate - checkindate).to_i )
                logger.info session[:amount].to_i
                logger.info "ssssssssss11111111ss"
                logger.info resline.price.to_i
                logger.info "prrrrrrrrrr44444444rrrrrrrr"
                logger.info (checkoutdate - checkindate).to_i
                logger.info "checkout date is l55555555555onger"
                logger.info session[:amount]
             end
             end
           #this i am copying here
            amttsd = 0    
            if @multiplybyusrates
              amttsd = session["#{resline.room_number.name}"].to_i * ResCurrency.find(:all,:domain=>[['name','=', 'USD']])[0].rate * 100
            else
              amttsd = session["#{resline.room_number.name}"].to_i * 100 
            end
        
     ch={
       :name=>resline.room_number.name,
       :description => resline.room_number.name,
       :amount=> amttsd
     }
     logger.info "chhhhhhhhhhhhhhh"
     logger.info ch
     @item_hash_array << ch 
           #here copy end
        
            end
        end
       #here i am just putting an note that is in previous code what i have done is calculated a price i think instead of that
       #after a reservation i can directly get an price. 
       #yes but i am wrong here means what i feel is without calling an function on reservation or reservation line. the price 
       #is even not get calculated 
        #@hotelc.reload
        #@hotelc.reload
        #i seen a problem here that is the reservation line is always blank in view
        #so i will create a 
        logger.info @hotelc
        logger.info "newressssssssssssss777777"
        logger.info @hotelc.reservation_line
        
        #now here i need to add a code for currency converter. so here first i need to check with paypal if that 
        #currency code matches if yes then there is no need to change.otherwise change it to usd.
        @currencyname = "USD"
        if ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
          @currencyname = ResCurrency.find(:all,:domain=>[['base','=',true]])[0].name     
        end
        #here also i need to add one more conditions.if the conversion takes place then show it in view
        available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
        #if the currency is not included in this array and its also not as usd then show the usd conversion rate
        if available_paypal_array.include?(@currencyname)
        elsif @currencyname == "USD"
        else
          #here is a transferred rate
          usdr = ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
          @convert_amount = session[:amount].to_i * usdr.rate
        end
        logger.info "..................."
  end 
   
  def create_hotel_reservation
      @roombarname = []
        @respartner = eval(session[:database_name].to_s.upcase.to_s)::ResPartner.find(session[:user_id_avail])
        @resname = @respartner.name
        session[:amount] = nil
        @hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.new
        @hotel.partner_id = session[:user_id_avail]
        @hotel.partner_order_id = session[:user_id_avail]
        @hotel.shop_id = 1
        @hotel.partner_invoice_id = session[:user_id_avail]
        @hotel.partner_shipping_id = session[:user_id_avail]
        @hotel.date_order = Date.today
        @hotel.pricelist_id = 1
        @hotel.printout_group_id = 1
        @hotel.source = 'through_web'
        checkindate = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split(':')[1].to_i )
        checkoutdate = DateTime.new(session[:checkout].split(' ')[0].to_s.split('/')[2].to_i,session[:checkout].split(' ')[0].to_s.split('/')[0].to_i,session[:checkout].split(' ')[0].to_s.split('/')[1].to_i,session[:checkout].split(' ')[1].to_s.split(':')[0].to_i,session[:checkout].split(' ')[1].to_s.split(':')[1].to_i )
        zone = ActiveSupport::TimeZone.new("Asia/Kolkata")
        tmzci=Time.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split(':')[1].to_i)
        tmzco=Time.new(session[:checkout].split(' ')[0].to_s.split('/')[2].to_i,session[:checkout].split(' ')[0].to_s.split('/')[0].to_i,session[:checkout].split(' ')[0].to_s.split('/')[1].to_i,session[:checkout].split(' ')[1].to_s.split(':')[0].to_i,session[:checkout].split(' ')[1].to_s.split(':')[1].to_i)
        tmzutcin= tmzci.in_time_zone("UTC")
        tmzutcout= tmzco.in_time_zone("UTC")
        @hotel.checkin =  tmzutcin
        @hotel.checkout = tmzutcout
        @hotel.dummy = session[:checkout]
        DateTime.new#ymdh
        if session[:checkin].blank?
          redirect_to root_url ,:notice=>'Your Session Is Expired Please Select Room Again' and return;
        end
        logger.info "checkinnnnnnnnnnnnnnnnnnnnnnnnnnn"
        logger.info session[:checkin]
        logger.info session[:checkout]
        doc_date = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split('/')[1].to_i ).ago  14.days 
        doc_date = Date.today if doc_date < Date.today
        @hotel.doc_date = doc_date
        @hotel.save   
        #when i copied this code i think i forget to copy a session[:newlysavedreservationid] variable which is required
        #after paypal payments complete a payment
        #session[:newlysavedreservationid] = @newres.id
        logger.info session["selectedroom"]
        logger.info "sessionnnnnnnnnnnnnnnnnn"
         @room = []
      
     
     
        if session["selectedroom"]
           session["selectedroom"].each do |roomid|
             
           
           resline = eval(session[:database_name].to_s.upcase.to_s)::HotelReservationLine.new
           resline.line_id = @hotel.id 
           hrm = eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.search([["product_id","=",roomid[0].to_i]])[0]
           resline.categ_id = eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.find(hrm).product_id.product_tmpl_id.categ_id.id
           @roombarname << eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.find(hrm).product_id.name
              @room <<   eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.find(hrm).product_id.name
           resline.room_number = roomid[0].to_i
           resline.price =  eval(session[:database_name].to_s.upcase.to_s)::ProductProduct.find(roomid[0].to_i).product_tmpl_id.list_price.to_f
           resline.reservation_id = @hotel.id 
           logger.info resline.save
           session["#{resline.room_number.name}"] = 0
           logger.info "an reservation lineeeeeeeeeeeeeeeeeeeee"
           logger.info checkoutdate
           logger.info checkindate
           logger.info (checkoutdate - checkindate).to_i
           #here need to check an checkout policy for this particular shop. there are 2 possibilities one 
           #is 24 hr e.g room price is 1000
           #so oif the checkin date is 1-1-2013 8 am and checkout is at 3-1-2013 at 7pm clock so the price will be
           #1-1-2013  8am to 2-1-2013 8am = 1000
           #2-1-2013  8am to 3-1-2013 8am = 1000
           #3-1-2013  8am to 3-1-2013 7pm = 1000
           #so the total is  3000
           #here i need to first find out which shop is this i can find that by the company available
           #here in an session i need to find out which co is there and take the first 
            cknp = eval(session[:database_name].to_s.upcase.to_s)::CheckoutConfiguration.find(:all,:domain=>[['shop_id','=',1]]).first.name
           if cknp == "24hour"
             #here i am copying checkin and checkout variables so that it will not make any conflict in its current flow
             checkindfortd = checkindate
             checkoutdfortd = checkoutdate
              #dtd = Time.diff(checkindfortd,checkoutdfortd)
              #here i need to do a calculation as follows.
             #if its a month then get that much days in month and multiply by that much with price
             #here i need to take current date and find out the days remaining in that particular month
             #ultimetly what i need to do is get every day and month in houres so i use the logic that each day is of 24 hrs
             #therefore if the day difference is 0 then whatever may be the oures i should charge an 1 day cost.
             #then if there is day difference then get the month then get the start date of month 
             ###################################################################################
             #just changing the logic in mind here instead of getting and month and calculating an days.
             #lets go next day untile its equivalent to checkout date.and each day add one price. and lastly check an hour
             #another simple logic is i should go on increasing the days untile i get that checkindate is greater than
             #checkout dateand each day i should increase an amount
                    
                   #if the difference between months start and end date is 0 then consider it as 1 day price
            while checkindfortd < checkoutdfortd
                 session[:amount] = session[:amount].to_i + resline.price.to_i 
                 session["#{resline.room_number.name}"] = session["#{resline.room_number.name}"].to_i + resline.price.to_i
                 checkindfortd = checkindfortd.next_day
            end  
                    
                 
              
           else
           
        
            if ((checkoutdate - checkindate).to_i == 0) 
                 logger.info "some errporrrrrrrrrrrrrrrr as value is zero"
                  session[:amount] = session[:amount].to_i +   resline.price.to_i    
                  session["#{resline.room_number.name}"] = session["#{resline.room_number.name}"].to_i + resline.price.to_i
            
                  logger.info session[:amount]
             else
                session[:amount] = session[:amount].to_i +  (resline.price.to_i * (checkoutdate - checkindate).to_i )
                session["#{resline.room_number.name}"] = session["#{resline.room_number.name}"].to_i + (resline.price.to_i * (checkoutdate - checkindate).to_i )
                logger.info session[:amount].to_i
                logger.info "sssssssssss"
                logger.info resline.price.to_i
                logger.info "prrrrrrrrrrrrrrrrrr"
                logger.info (checkoutdate - checkindate).to_i
                logger.info "checkout date is longer"
                logger.info session[:amount]
             end
             end
        
           end
        end
       #here i am just putting an note that is in previous code what i have done is calculated a price i think instead of that
       #after a reservation i can directly get an price. 
       #yes but i am wrong here means what i feel is without calling an function on reservation or reservation line. the price 
       #is even not get calculated 
        @hotel.reload
        @hotel.reload
        #i seen a problem here that is the reservation line is always blank in view
        #so i will create a 
        logger.info @hotel
        logger.info "newressssssssssssss"
        #now here i need to add a code for currency converter. so here first i need to check with paypal if that 
        #currency code matches if yes then there is no need to change.otherwise change it to usd.
        @currencyname = "USD"
        if eval(session[:database_name].to_s.upcase.to_s)::ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
          @currencyname = eval(session[:database_name].to_s.upcase.to_s)::ResCurrency.find(:all,:domain=>[['base','=',true]])[0].name     
        end
        #here also i need to add one more conditions.if the conversion takes place then show it in view
        available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
        #if the currency is not included in this array and its also not as usd then show the usd conversion rate
        if available_paypal_array.include?(@currencyname)
        elsif @currencyname == "USD"
        else
          #here is a transferred rate
          usdr = eval(session[:database_name].to_s.upcase.to_s)::ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
          @convert_amount = session[:amount].to_i * usdr.rate
        end
  end 
   
   
  
  def rejected_payment
      p "here the payment is rejected by person"
      #what i have to do here is find the reservation id and destroy it. and redirect to root url.
       session[:database_name] = Ipbasesdb.find_by_ipaddress(params[:token]).dbname 
  logger.info "i just seen one error where the constant is uninitialize for session[:database_name] that is why makking "
  logger.info "an connection again"
  logger.info "the session valueeeeeeeeeeeee"
  logger.info session[:database_name]
  logger.info session[:checkout]
  if session[:database_name].blank?
     redirect_to root_url ,:notice=>"Your Session Is Expired Please Select Room Again" and return
  end
  @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => session[:database_name], :username =>'admin', :password   => 'admin',:scope_prefix => session[:database_name].to_s.upcase.to_s)      #p "Connected to opererp database"
   #@hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(session[:newlysavedreservationid])
  #@hotel.destroy
  # as now there is no need to destroy a record as it already get deleted after creation just a redirection is sufficient
  logger.info "the session valueeeeeeeeeeeee"
  logger.info session[:database_name]
  logger.info session[:checkout]
  reset_session
  logger.info "the session valueeeeeeeeeeeee"
  logger.info session[:database_name]
  logger.info session[:checkout]
   redirect_to root_url ,:notice=>"You Have Cancelled An Reservation"
  end 
   
   
  
  private

  def gateway
        @gateway ||= PaypalExpressGateway.new(
           :login => 'kedar.pathak-facilitator_api1.pragtech.co.in',
          :password => '1364994877',
          :signature => 'ACLa8jsQN8TPFLDY57dLNb5-3qq.AgN5u20e33t3nrXP3uDzoZTGNERk'
        )
  end
   
   def check_connection
     @my_logger ||= Logger.new("#{Rails.root}/log/onlygdsandweb.log")
     begin
       @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => "hotel_kedar_1", :username =>'admin', :password   => 'admin')      #p "Connected to opererp database"
 
     rescue=>e
       logger.info "there is problem in connection"
       logger.info e
       logger.info e.message
       logger.info e.inspect
       @my_logger.info "this is new error"
       @my_logger.info Time.now
       
       @my_logger.info e.message
       @my_logger.info e.inspect
       
       render :action => "error"
     end
     
   end

end

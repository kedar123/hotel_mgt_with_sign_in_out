class PaymentsController < ApplicationController
   include ActiveMerchant::Billing
  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
    end
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
        @newres.checkin = session[:checkin]
        @newres.checkout = session[:checkout] 
        @newres.dummy = session[:checkout]
        p "sssssssssssssssssssssssss"
        p session[:checkin]#mm-dd-yy
        
        DateTime.new#ymdh
        if session[:checkin].blank?
          redirect_to root_url ,:notice=>'Your Session Is Expired Please Select Room Again' and return;
        end
        logger.info "checkinnnnnnnnnnnnnnnnnnnnnnnnnnn"
        logger.info session[:checkin]
        logger.info session[:checkout]
        
        checkindate = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split(':')[1].to_i )
        checkoutdate = DateTime.new(session[:checkout].split(' ')[0].to_s.split('/')[2].to_i,session[:checkout].split(' ')[0].to_s.split('/')[0].to_i,session[:checkout].split(' ')[0].to_s.split('/')[1].to_i,session[:checkout].split(' ')[1].to_s.split(':')[0].to_i,session[:checkout].split(' ')[1].to_s.split(':')[1].to_i )

        doc_date = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split('/')[1].to_i ).ago  14.days 
        doc_date = Date.today if doc_date < Date.today
        @newres.doc_date = doc_date
        @newres.save   
        #when i copied this code i think i forget to copy a session[:newlysavedreservationid] variable which is required
        #after paypal payments complete a payment
        session[:newlysavedreservationid] = @newres.id
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
           logger.info "an reservation lineeeeeeeeeeeeeeeeeeeee"
           logger.info checkoutdate
           logger.info checkindate
           logger.info (checkoutdate - checkindate).to_i
           
             if ((checkoutdate - checkindate).to_i == 0) 
                 logger.info "some errporrrrrrrrrrrrrrrr as value is zero"
                  session[:amount] = session[:amount].to_i +   resline.price.to_i    
                  logger.info session[:amount]
             else
                session[:amount] = session[:amount].to_i +  (resline.price.to_i * (checkoutdate - checkindate).to_i )  
                logger.info "checkout date is longer"
                logger.info session[:amount]
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
    
   logger.info "amoint"
   logger.info params[:amount].to_i * 100
   logger.info request.remote_ip
   logger.info url_for(:action => 'confirm', :only_path => false)
   logger.info url_for(:action => 'index', :only_path => false)
   
  setup_response = gateway.setup_purchase(params[:amount].to_i * 100,
    :items => [{:name => "Openerp Module", :quantity => 1,:description => "All Modules",:amount=> params[:amount].to_i * 100}], 
    :ip                => request.remote_ip,
    :return_url        => url_for(:action => 'confirm', :only_path => false),
    :cancel_return_url => url_for(:action => 'cancel', :only_path => false)
  )
 logger.info "this is set up responseaaa"
 logger.info setup_response.inspect
  session[:amount] = params[:amount]
  session[:newlysavedreservationid] =  params[:newlysavedreservationid]
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
  redirect_to gateway.redirect_url_for(setup_response.token)
  end   
    
    
    
    #this code i am keeping as it is because there is no need to hide anything
     def call_create_saleorder_and_invoice(hotelres)
    logger.info "oneeeeeeeee7777777777777777777"
    logger.info "this is blankkkkkkkkkkkkkkkk"
    logger.info hotelres.inspect
    logger.info "222222222222222222222222222222222"
     hotelres.call("confirmed_reservation",[hotelres.id])
     logger.info "oneeeeeeeee+++++++++++++" 
    # hotelres.call("create_folio",[hotelres.id])
     logger.info "oneeeeeeeee----------" 
     #hf = eval(session[:database_name].to_s.upcase.to_s)::HotelFolio.search([["reservation_id","=",hotelres.id]])[0]
     #hf =  eval(session[:database_name].to_s.upcase.to_s)::HotelFolio.find(hf)
     logger.info "oneeeeeeeee"
     
     #i am commenting this because now need to change the payment to journal entries.
     acm = eval(session[:database_name].to_s.upcase.to_s)::AccountMove.new
     acm.journal_id = eval(session[:database_name].to_s.upcase.to_s)::AccountJournal.search([['type','=','bank']])[0]
     acm.company_id = hotelres.company_id.id
     acm.ref = hotelres.reservation_no
     acm.save
     acm.reload
     #now need to create 2 lines one for debit and one for credit 
     acml = eval(session[:database_name].to_s.upcase.to_s)::AccountMoveLine.new
     acml.move_id = acm.id
     acml.name = hotelres.reservation_no
     acml.partner_id = hotelres.partner_id.id
     acml.account_id = hotelres.partner_id.property_account_receivable.id
     acml.credit = hotelres.total_cost1
     acml.debit = 0
     acml.status = 'draft'
     acml.save
     #now need to copy for second lineeeeeeeeee
     acml = eval(session[:database_name].to_s.upcase.to_s)::AccountMoveLine.new
     acml.move_id = acm.id
     acml.name = hotelres.reservation_no
     acml.partner_id = hotelres.partner_id.id
      
     acml.account_id =  eval(session[:database_name].to_s.upcase.to_s)::AccountJournal.find(eval(session[:database_name].to_s.upcase.to_s)::AccountJournal.search([['type','=','bank']])[0]).default_debit_account_id.id
   
     acml.debit = hotelres.total_cost1
     acml.credit = 0
     acml.status = 'draft'
     acml.save
     
    
    
    
    
    
     #hf.wkf_action("order_confirm")
     #logger.info "twoooooooooo"
     #hf.wkf_action("manual_invoice")
     #logger.info "threeeeeeeeeeee"
     #hf.invoice_ids.each do |inv|
     #  inv.wkf_action("invoice_open")
     #  inv.call("invoice_pay_customer",[inv.id])
     #end
     #logger.info "is this object is static"
     #logger.info hotelres.inspect
     #logger.info "need to call twice" 
     #hotelres = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(hotelres.id)
     #logger.info hotelres.inspect
     #call_voucher_create(hotelres,hf)
  end
  
  def confirm
    redirect_to :action => 'index' unless params[:token]
   
  session[:database_name] = Ipbasesdb.find_by_ipaddress(params[:token]).dbname 
  logger.info "i just seen one error where the constant is uninitialize for session[:database_name] that is why makking "
  logger.info "an connection again"
  @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => session[:database_name], :username =>'admin', :password   => 'admin',:scope_prefix => session[:database_name].to_s.upcase.to_s)      #p "Connected to opererp database"
 
  @hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(session[:newlysavedreservationid])
  #i am taking this into another variables because sometimes in view this ooor @hotel object is not availabel
  @checkin = @hotel.checkin
  @checkout = @hotel.checkout
  @room = []
  @hotel.reservation_line.each do |ersl|
       @room <<   ersl.room_number.name
  end
  @resname = @hotel.partner_id.name
   
  
  session[:newlysavedreservationid]
  details_response = gateway.details_for(params[:token])
  
  if !details_response.success?
    @message = details_response.message
    render :action => 'error'
    return
  end
    
  @address = details_response.address
  
  end
  
  
  def cancel
       render :layout=>false
  end
    
  
   def complete
    purchase = gateway.purchase(session[:amount].to_i * 100,
    :ip       => request.remote_ip,
    :payer_id => params[:payer_id],
    :token    => params[:token]
  )
  logger.info "purchasing amount"
  logger.info session[:amount]
  logger.info session[:amount]
  logger.info session[:newlysavedreservationid]
   
  
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
       @hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(session[:newlysavedreservationid])
       #@hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(@hotel.id)
       @resname = @hotel.partner_id.name
         logger.info @hotel.inspect
         call_create_saleorder_and_invoice(@hotel)
        @reservation_no = @hotel.reservation_no
       #flash[:notice] ="You Have Now Made A Successful Purchased. Your Booking Reference Is:"+@hotel.reservation_no if @hotel
    
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
         logger.info "is this error"
         logger.info e.message
        # @already_created_sales_order = true if  e.message.include? "Order Reference must be unique per Company!"
         #raise e
         flash[:notice] =  e.message
         # here i need to check the error and ask him to contact us and also tell him that u r payment is done
         logger.info "redirecting back from rescue"
      redirect_to :back
       end
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
   @hotel = eval(session[:database_name].to_s.upcase.to_s)::HotelReservation.find(session[:newlysavedreservationid])
  @hotel.destroy
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


end

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
        checkindate = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split(':')[1].to_i )
        checkoutdate = DateTime.new(session[:checkout].split(' ')[0].to_s.split('/')[2].to_i,session[:checkout].split(' ')[0].to_s.split('/')[0].to_i,session[:checkout].split(' ')[0].to_s.split('/')[1].to_i,session[:checkout].split(' ')[1].to_s.split(':')[0].to_i,session[:checkout].split(' ')[1].to_s.split(':')[1].to_i )
         session[:amount] = nil
        if session[:checkin].blank?
          redirect_to root_url ,:notice=>'Your Session Is Expired Please Select Room Again' and return;
        end
           if session["selectedroom"]
           session["selectedroom"].each do |roomid|
            pr =  ProductProduct.find(roomid[0].to_i)
            @roombarname << pr.name
           price = pr.product_tmpl_id.list_price.to_f
              cknp = CheckoutConfiguration.find(:all,:domain=>[['shop_id','=',1]]).first.name
           if cknp == "24hour"
             #here i am copying checkin and checkout variables so that it will not make any conflict in its current flow
             checkindfortd = checkindate
             checkoutdfortd = checkoutdate
             while checkindfortd < checkoutdfortd
                 session[:amount] = session[:amount].to_i + price.to_i
                 checkindfortd = checkindfortd.next_day
            end
            else
             if ((checkoutdate - checkindate).to_i == 0)
                   session[:amount] = session[:amount].to_i + price.to_i
              else
                session[:amount] = session[:amount].to_i + (price.to_i * (checkoutdate - checkindate).to_i )
                end
             end
            end
        end
        @currencyname = "USD"
        if ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
          @currencyname = ResCurrency.find(:all,:domain=>[['base','=',true]])[0].name
        end
         available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
         if available_paypal_array.include?(@currencyname)
         elsif @currencyname == "USD"
         else
             usdr = ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
            @convert_amount = session[:amount].to_i * usdr.rate
         end
    end
   
   
  
   
  
  def checkout
    begin
    available_paypal_array = ["AUD","CAD","CZK","DKK","EUR","HKD","HUF","JPY","NOK","NZD","PLN","GBP","SGD","SEK","CHF"]
    paypal_currency = "USD"
    base_currency = ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
    paypal_amount = params[:amount].to_i
   @multiplybyusrates = false
   if base_currency && available_paypal_array.include?(base_currency.name)
       paypal_currency = base_currency.name
       paypal_amount = params[:amount].to_i * 100
    else
      if base_currency && base_currency.name == "USD"
       paypal_amount = paypal_amount * 100#usd
     else
        if base_currency
         @multiplybyusrates = true
         paypal_amount = (paypal_amount * ResCurrency.find(:all,:domain=>[['name','=', 'USD']])[0].rate)*100
       else
         paypal_amount = paypal_amount * 100
       end
     end
   end
    room_name = []
    @item_hash_array = []
    checkout_hotel_reservation
    setup_response = gateway.setup_purchase(paypal_amount,
    :items => @item_hash_array,
    :ip => request.remote_ip,
    :return_url => url_for(:action => 'confirm', :only_path => false),
    :cancel_return_url => url_for(:action => 'cancel', :only_path => false),
    :currency => paypal_currency
    )
   session[:amount] = params[:amount]
   session[:database_name] = session[:database_name]
   Ipbasesdb.create(:dbname=>"hotel_kedar_1" ,:ipaddress=>setup_response.token)
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
         if available_paypal_array.include?(base_currency.name)
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
     acml.account_id = eval(session[:database_name].to_s.upcase.to_s)::AccountJournal.find(eval(session[:database_name].to_s.upcase.to_s)::AccountJournal.search([['type','=','bank']])[0]).default_debit_account_id.id
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
       default_cur = ResCurrency.find(:all,:domain=>[['name','=','USD' ]])[0]
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
     @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => session[:database_name], :username =>'admin', :password => 'admin',:scope_prefix => session[:database_name].to_s.upcase.to_s) #p "Connected to opererp database"
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
        if available_paypal_array.include?(base_currency.name)
           base_currency = base_currency.name
        else
           base_currency = "USD"
        end
      end
      paypal_amount = session[:amount].to_i
      ##################eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
         base_currencyc = eval(session[:database_name].to_s.upcase.to_s)::ResCurrency.find(:all,:domain=>[['base','=',true]])[0]
          if base_currencyc && available_paypal_array.include?(base_currencyc.name)
            paypal_amount = session[:amount].to_i * 100
          #when its different currency then no need to translate it to * by 100
          else
     #i assume that if its not included in paypal array and if the currency is not usd then convert it to usd
     if base_currencyc && base_currencyc.name == "USD"
       paypal_amount = paypal_amount * 100#usd
     else
        if base_currencyc
          paypal_amount = (paypal_amount * ResCurrency.find(:all,:domain=>[['name','=', 'USD']])[0].rate)*100
       else
         paypal_amount = paypal_amount * 100
       end
     end
   end ##################3333eeeeeeeee
     
    purchase = gateway.purchase(paypal_amount,
    :ip => request.remote_ip,
    :payer_id => params[:payer_id],
    :token => params[:token],
    :currency => base_currency
  )
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
         logger.info "12344444444444444444444"
          create_hotel_reservation()
          logger.info "the purchaseeeeeeeeeee"
          logger.info purchase.inspect
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
           session["campany_id"] = nil
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
          converted_amt = session[:amount].to_i * usdr.rate
        end
  
  paypal_transaction_id = purchase.params['transaction_id']
  
       Notifier.paypal_error_message(partner_name,checkindate,checkoutdate,roomname.join(', '),amount,converted_amt,paypal_transaction_id,@currencyname).deliver
      
       redirect_to payments_server_connection_error_path
       end
  end
  
  end
  
  
  def checkout_hotel_reservation
         session[:amount] = nil
         checkindate = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split(':')[1].to_i )
         checkoutdate = DateTime.new(session[:checkout].split(' ')[0].to_s.split('/')[2].to_i,session[:checkout].split(' ')[0].to_s.split('/')[0].to_i,session[:checkout].split(' ')[0].to_s.split('/')[1].to_i,session[:checkout].split(' ')[1].to_s.split(':')[0].to_i,session[:checkout].split(' ')[1].to_s.split(':')[1].to_i )
         if session[:checkin].blank?
           redirect_to root_url ,:notice=>'Your Session Is Expired Please Select Room Again' and return;
         end
         if session["selectedroom"]
            session["selectedroom"].each do |roomid|
              pr = ProductProduct.find(roomid[0].to_i)
               price = pr.product_tmpl_id.list_price.to_f
              session["#{pr.name}_#{pr.id}"] = 0
              cknp = CheckoutConfiguration.find(:all,:domain=>[['shop_id','=',1]]).first.name
           if cknp == "24hour"
              checkindfortd = checkindate
             checkoutdfortd = checkoutdate
             while checkindfortd < checkoutdfortd
                 session[:amount] = session[:amount].to_i + price.to_i
                 session["#{pr.name}_#{pr.id}"] = session["#{pr.name}_#{pr.id}"].to_i + price.to_i
                 checkindfortd = checkindfortd.next_day
            end
            else
             if ((checkoutdate - checkindate).to_i == 0)
                   session[:amount] = session[:amount].to_i + price.to_i
                   session["#{pr.name}_#{pr.id}"] = session["#{pr.name}_#{pr.id}"].to_i + price.to_i
              else
                session[:amount] = session[:amount].to_i + (price.to_i * (checkoutdate - checkindate).to_i )
                session["#{pr.name}_#{pr.id}"] = session["#{pr.name}_#{pr.id}"].to_i + (price.to_i * (checkoutdate - checkindate).to_i )
              end
             end
           #this i am copying here
            amttsd = 0
            if @multiplybyusrates
              amttsd = session["#{pr.name}_#{pr.id}"].to_i * ResCurrency.find(:all,:domain=>[['name','=', 'USD']])[0].rate * 100
            else
              amttsd = session["#{pr.name}_#{pr.id}"].to_i * 100
            end
        
     ch={
       :name=>pr.name,
       :description => pr.name,
       :amount=> amttsd
     }
      @item_hash_array << ch
             end
        end
    
  end
   
  def create_hotel_reservation
     @room = []
      
      @respartner = eval(session[:database_name].to_s.upcase.to_s)::ResPartner.find(session[:user_id_avail])
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
      @hotel.checkin = tmzutcin
      @hotel.checkout = tmzutcout
      @hotel.dummy = session[:checkout]
         if session[:checkin].blank?
           redirect_to root_url ,:notice=>'Your Session Is Expired Please Select Room Again' and return;
         end
         doc_date = DateTime.new(session[:checkin].split(' ')[0].to_s.split('/')[2].to_i,session[:checkin].split(' ')[0].to_s.split('/')[0].to_i,session[:checkin].split(' ')[0].to_s.split('/')[1].to_i,session[:checkin].split(' ')[1].to_s.split(':')[0].to_i,session[:checkin].split(' ')[1].to_s.split('/')[1].to_i ).ago 14.days
         doc_date = Date.today if doc_date < Date.today
        @hotel.doc_date = doc_date
        @hotel.save
        @room = []
         if session["selectedroom"]
           session["selectedroom"].each do |roomid|
             
            resline = eval(session[:database_name].to_s.upcase.to_s)::HotelReservationLine.new
            resline.line_id = @hotel.id
            hrm = eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.search([["product_id","=",roomid[0].to_i]])[0]
            resline.categ_id = eval(session[:database_name].to_s.upcase.to_s)::HotelRoom.find(hrm).product_id.product_tmpl_id.categ_id.id
            resline.room_number = roomid[0].to_i
           resline.price = eval(session[:database_name].to_s.upcase.to_s)::ProductProduct.find(roomid[0].to_i).product_tmpl_id.list_price.to_f
           resline.reservation_id = @hotel.id
           logger.info resline.save
             @room << ProductProduct.find(roomid[0].to_i).name
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
  @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => session[:database_name], :username =>'admin', :password => 'admin',:scope_prefix => session[:database_name].to_s.upcase.to_s) #p "Connected to opererp database"
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
       @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => "hotel_kedar_1", :username =>'admin', :password => 'admin') #p "Connected to opererp database"
 
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


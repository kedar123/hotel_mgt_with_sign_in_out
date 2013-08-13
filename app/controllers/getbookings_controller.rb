class GetbookingsController < ApplicationController
  # GET /getbookings
  # GET /getbookings.json
  layout 'gds'
   before_filter :check_gds_availability
  def index
    
   # getbook = Getbooking.get_bookings
    p "the getbook response"
    #p getbook
    p "getbookkkkkkkk"

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @getbookings }
    #end
  end

  # GET /getbookings/1
  # GET /getbookings/1.json
  def show
    @getbooking = Getbooking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @getbooking }
    end
  end

  # GET /getbookings/new
  # GET /getbookings/new.json
  def new
    #@getbooking = Getbooking.new
    @select_shop = GDS::SaleShop.find(:all,:domain=>[['company_id','=',session[:gds_company_id].to_i ]])
   
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @getbooking }
    end
  end

  # GET /getbookings/1/edit
  def edit
    @getbooking = Getbooking.find(params[:id])
  end

  # POST /getbookings
  # POST /getbookings.json
  
  #to get started with today and to get a link at what i had done on saturday just take one revision here.
  #on create all the reservation data it will come here with all the xml field data included in it.then here at first
  #i am creating an partner if its not created firstly.then creating an hotel reservation.and then creating
  #an payment part. 
  #so last time i have not included an ooor gem which i am including it now and then i will see what is 
  #
  #here i am just checking the dates of booked hotel reservation. for no conflict i am removing all the
  #reservations from openerp web view
  #todays work start with just checking with is the really room reservation is get added or not
  def create
  #here i have not thought for the things like when i import an reservations from gds and if the rooms 
  #are not allocated sufficiently then i should display a message and i think snding an email to admin
  #that please allocate the rooms in openerp as the reservations are already done.but i dont think this
  #situation will appear  
    begin
      logger.info GDS
    rescue
      redirect_to gds_auths_path ,:notice=>"Your Session Has Been Expired Please Login again" and return
    end
    getbooking = Getbooking.get_bookings(params)
    logger.info "some get bookings3333333335555555511111111"
    logger.info getbooking.inspect
    respond_to do |format|
         #here i first need to include ooor gem . then first i need to create respartner 
         #then need to create an hotel reservation and then need to create a payment part
         
        Getbooking.create_partner_if_not_created(getbooking) 
        #after creating an partner now need to start creating an reservation 
        logger.info "the session is blank"
        logger.info session[:gds_shop_id]
        logger.info "company id is blank"
        logger.info session[:gds_company_id]
        logger.info "88888888888888888888"
         
        retv = Getbooking.create_hotel_reservation(getbooking,params[:shop_id],session[:gds_company_id])
        
       if retv.blank?
         logger.info "8888888888888888888888"
         # as currently i can check the blank condition directly because there are only two values one is blank and one is some value
        #flash[:notice] = getbooking.body
        format.html {  redirect_to new_getbooking_path ,:notice=>"Reservations Are Imported Successfully" }
        format.json { render json: @getbooking.errors, status: :unprocessable_entity }
       else
         logger.info "77777777777777777777777"
        format.html { render :text=>"some rooms are already booked. means room booked in reconline but not available to book in openerp so create a room and assign it to gds. or no bookings are get"}
       end
    end
  end

  # PUT /getbookings/1
  # PUT /getbookings/1.json
  def update
    @getbooking = Getbooking.find(params[:id])

    respond_to do |format|
      if @getbooking.update_attributes(params[:getbooking])
        format.html { redirect_to @getbooking, notice: 'Getbooking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @getbooking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getbookings/1
  # DELETE /getbookings/1.json
  def destroy
    @getbooking = Getbooking.find(params[:id])
    @getbooking.destroy

    respond_to do |format|
      format.html { redirect_to getbookings_url }
      format.json { head :no_content }
    end
  end
  
  
  
    private
  def check_gds_availability
    begin
      logger.info GDS
    rescue
      redirect_to gds_auths_path ,:notice=>"Your Session Has Been Expired Please Login Again" and return
    end
    #here i also need to check an session for gusername is available or not for logged in user purpose.
     if session[:gusername].blank?
        redirect_to gds_auths_path,:notice=>"Your Session Has Been Expired Please Login Again" and return
     end
    
      begin
        #only checking an GDS is not sufficient actually need an fire a query so that a connection can occure
      GDS::SaleShop.find(:all,:domain=>[['company_id','=',session[:gds_company_id].to_i ]])
      rescue=>e
        @my_logger ||= Logger.new("#{Rails.root}/log/onlygdsandweb.log")
         logger.info "there is problem in connection"
       logger.info e
       logger.info e.message
       logger.info e.inspect
       @my_logger.info "this is new error"
       @my_logger.info Time.now
       
       @my_logger.info e.message
       @my_logger.info e.inspect
       
       render :action => "error" ,:layout=>false
      end
    
  end
  
end

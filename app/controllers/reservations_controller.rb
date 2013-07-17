class ReservationsController < ApplicationController
  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reservations }
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/new
  # GET /reservations/new.json
  def new
    @reservation = Reservation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/1/edit
  def edit
    @reservation = Reservation.find(params[:id])
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(params[:reservation])

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render json: @reservation, status: :created, location: @reservation }
      else
        format.html { render action: "new" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reservations/1
  # PUT /reservations/1.json
  def update
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end
  
  def show_dates
    @resname = ""
    if !session[:user_id_avail].blank?
      @partner_id = ResPartner.find(session[:user_id_avail])
      @resname = @partner_id.name
    end
      render :layout=>"show_dates"
  end
  
  #if the user clicks on book the room. then in javascript i need to check that user at least checked one room check
  # box and after submit 
  def book_the_room
    
  end
  
  #here now i need to fetch all the rooms of a particular company id. this is the only change in my previous coding
  #and current coding
  def show_availability_of_rooms
    #here i am making an connection again because i seen one error of uninitialize constant. which should not happen 
    #actually because at first time i am connecting to openerp which according to me should be kept in memory. but still 
    #because of error i am connecting again
    @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => "hotel_kedar_1", :username =>'admin', :password   => 'admin')      #p "Connected to opererp database"
    @resname = ""
    if !session[:user_id_avail].blank?
      @partner_id = ResPartner.find(session[:user_id_avail])
      @resname = @partner_id.name
    end
    @book_room_array =  check_book_room_search(params)
    logger.info @room
    logger.info "roommmmmmm"
    render :layout=>"show_dates"
  end
  
  
  # here i just need to change everything in datetime format so that when storing a data i can see a a check in and checkout
  # date time
   def check_book_room_search(params)
     logger.info "what are paramssssssssssssssssssss"
     logger.info params
     #extracting some code from room_type method
     @category = []
     @room = []
     @hotelroom = HotelRoom.find(:all)  
     
      @hotelroom.each do |hr|
        logger.info "not herererererer"
        logger.info hr
        logger.info hr.product_id
        #as per discussion i need to change this code to compare with company id
        logger.info "there are some conflicts"
        logger.info hr.company_id.id.to_s
        logger.info hr.company_id.id.to_s
        logger.info "888888888888888888888888"
        logger.info params["company_id"].to_s
        logger.info "55555555555555"
       if hr.company_id.id.to_s ==  params["company_id"].to_s
         logger.info "inside a company is sameeeeeeeeeeeee"
        if hr.product_id
          logger.info "inside a product iddddddddddddddddd"
          logger.info "inside the room"
          logger.info hr.product_id.categ_id.name
          logger.info hr.product_id.categ_id.id
          @category << [hr.product_id.categ_id.name,hr.product_id.categ_id.id]  
          logger.info hr.product_id.name
          logger.info hr.product_id.id
          logger.info hr.product_id.categ_id.id
          @room << [hr.product_id.name,hr.product_id.id,hr.product_id.categ_id.id]
        else
          logger.info "55555555544444444441111111222222222"
        end
       end
       
        logger.info "adding the rooommm"
      end
      logger.info "the all roomssssss"
      logger.info @room.inspect
      logger.info @category.inspect
      
     
     #end of extractionnnnnnnnnnnnnnnnnnnnnnnnnn
    data = []
    booked_room = []   
     HotelRoom.find(:all).each do |roomid|
       if roomid.company_id.id.to_s == params["company_id"].to_s
         logger.info "ijijijijijij"
            hrbh = HotelRoomBookingHistory.search([["name","=","#{roomid.product_id.name}"]])
             if !hrbh.blank?
              data << hrbh
             end
       end
      end
     data.flatten!  if !data.blank?
     data = HotelRoomBookingHistory.find(data)
     data.each do |dd|
      ####2012-09-04   2012-09-13   from params
      ### 2012-09-01   2012-09-15
      ###4   params
      ####1
      if !params['checkin'].blank? 
        #here i need to do a date time object 
        logger.info params
        logger.info "this is the format of date and time i am getting"
        #"07/12/2013 03:13"  this string i need to parse
logger.info params['checkin'].split(" ")[1].to_s.split(":")[0]
logger.info params['checkin'].split(" ")[1].to_s.split(":")[1]       
logger.info "divvvvvvvvvvv erroooooooooooooooo"
        paramscheckin = DateTime.new(params['checkin'].split(" ")[0].to_s.split("/")[2].to_i,params['checkin'].split(" ")[0].to_s.split("/")[0].to_i,params['checkin'].split(" ")[0].to_s.split("/")[1].to_i,params['checkin'].split(" ")[1].to_s.split(":")[0].to_i,params['checkin'].split(" ")[1].to_s.split(":")[1].to_i )
        paramschekout = DateTime.new(params['checkout'].split(" ")[0].to_s.split("/")[2].to_i,params['checkout'].split(" ")[0].to_s.split("/")[0].to_i,params['checkout'].split(" ")[0].to_s.split("/")[1].to_i,params['checkout'].split(" ")[1].to_s.split(":")[0].to_i,params['checkout'].split(" ")[1].to_s.split(":")[1].to_i )
        logger.info "Date validationnnnnnnnnnnnnnnnnnnnn"
        logger.info paramscheckin.inspect
        logger.info paramschekout.inspect
        logger.info dd.check_in_date.inspect
        logger.info dd.check_out_date.inspect
        if paramscheckin >= dd.check_in  and paramschekout <= dd.check_out
          logger.info "I am her88e4"
          booked_room << dd
        elsif paramscheckin >= dd.check_in  and paramschekout >= dd.check_out  and paramscheckin <= dd.check_out  and dd.check_in >  paramschekout
          logger.info "I am here744"
          booked_room << dd
        elsif  paramscheckin <= dd.check_in  and paramschekout <= dd.check_out  and paramschekout >= dd.check_in    
          booked_room << dd
          logger.info "I am here4"
        elsif  paramscheckin <= dd.check_in  and paramschekout >= dd.check_out   
          booked_room << dd
          logger.info "I am here4"
          logger.info paramscheckin
        elsif  dd.check_in <= paramscheckin and dd.check_out <= paramschekout  and paramscheckin <= dd.check_out
          booked_room << dd
          logger.info "I am here5"
           logger.info paramscheckin
        end
      end
    end
    name_array = []
    booked_room.each do |rn|
      name_array << rn.name
    end
    logger.info "returning the array"
    logger.info name_array    
    name_array    
  end
  
end

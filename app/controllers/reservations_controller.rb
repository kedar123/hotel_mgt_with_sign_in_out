class ReservationsController < ApplicationController
  # GET /reservations
  # GET /reservations.json
  before_filter :check_connection
  layout 'web_layout'
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
  
  
  def room_confirm
        Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => 'hotel_kedar_1', :username =>'admin', :password   => 'admin')       
     all_res_room = HotelRoomBookingHistory.find(:all)
      all_res_room.each do |ares|
        p ares.name
      end
    @room_hash = {}
    @category_type = ProductCategory.where(:isroomtype=>"true") 
    year = params[:date][:year] if params[:date]
    month = params[:date][:month] if params[:date]
    #i think this condition i am putting here is because 
    if year.nil?
      year = 2012
    end
    #if the month is zero then i need to show a calender for a full year
    # start from jan to dec
     if month.blank?
       #month = 1 
       
       create_a_year_calender(month,year,all_res_room)
      return    
     end
     p "==========================================="
     logger.info "this is monthdddddddddddddddddddddddd"
     logger.info month.to_i
     p month.to_i
     @date = Date.civil(year.to_i,month.to_i,-1)    
     p @date
     #above fetchinga all the booked rooms
      p all_res_room
     logger.info all_res_room
     logger.info "all res room"
     logger.info all_res_room.size
     #loop on fetched booked room
    all_res_room.each do |each_room|
      dayrange = []
      #here i get
      logger.info "from 8 loop"
      logger.info each_room.name
      logger.info each_room.check_in_date
       if params[:date] 
        p params[:date]
        #  5 day and 5 month and date is 15
        logger.info "rooooooooooooooooo"
        logger.info each_room.name
        logger.info each_room.check_in_date
        logger.info @date
        logger.info "this is atooooooooooo datewswswswswswsws"
        logger.info each_room.check_in_date.class
        logger.info @date.class
        if each_room.check_in_date < @date 
          logger.info "465d46a5d4654d"
          #it will come here because the @date is the last day of the month
          if   each_room.check_out_date > @date
            logger.info "5as45a4s5a454"
            if each_room.check_out_date.month > @date.month                
              if each_room.check_in_date.month == @date.month
                dayrange = each_room.check_in_date.day .. @date.day
              else
                dayrange = 1 .. @date.day
              end                
            else                 
              dayrange = 1 .. @date.day            
            end
          elsif each_room.check_in_date.month < @date.month
            if  each_room.check_out_date.year > @date.year
              dayrange = 1..@date.day
            elsif each_room.check_out_date.month > @date.month
              if each_room.check_in_date.year == @date.year
                dayrange = 1..@date.day
              end
            else
              logger.info "why does not it come hererere"
              if each_room.check_out_date.month == @date.month
                if each_room.check_in_date.year == @date.year
                  dayrange = 1..each_room.check_out_date.day
                end
              end
            end
          elsif  each_room.check_in_date.month == @date.month            
            logger.info each_room.name
            logger.info each_room.check_in_date.month
            logger.info @date.month
            logger.info "this is monthhhhh4857"
            logger.info each_room.check_in_date.day..each_room.check_out_date.day      
            logger.info "this is date range"
            if each_room.check_in_date.year == @date.year
              dayrange = each_room.check_in_date.day..each_room.check_out_date.day      
            end     
          elsif each_room.check_out_date < @date
            logger.info each_room.name
            logger.info each_room.check_in_date.month
            logger.info @date.month
            logger.info "this is monthhhhh48575485"
            logger.info 1..each_room.check_out_date.day    
            if  each_room.check_out_date.year == @date.year 
              if each_room.check_out_date.month == @date.month 
                dayrange = 1..each_room.check_out_date.day     
              end
            end
                 
          elsif each_room.check_out_date == @date
            logger.info "lastly it come hererdffdfd"
            logger.info each_room.check_out_date < @date
            logger.info each_room.check_out_date
            logger.info @date.inspect
            dayrange = 1..each_room.check_out_date.day   
          end
        elsif each_room.check_in_date == @date # means it is last date
          dayrange =  @date.day .. @date.day
          logger.info "wsws5s454sw4s54s"         
        end
      else
       end
       dayrangedate = []
      dayrange.each do |dd|
        dayrangedate << dd
      end
       if @room_hash.has_key?(each_room.name)
        @room_hash[each_room.name] =   @room_hash[each_room.name] + dayrangedate     
      else       
        logger.info  each_room.category_id.name
        logger.info "catiddddddddddddd"
        if params[:room_type] == "All Rooms"     
           @room_hash[each_room.name] =   dayrangedate
        elsif params[:room_type] == each_room.category_id.name       
           @room_hash[each_room.name] =   dayrangedate
        end    
      end
    end
     
    logger.info @room_hash
    logger.info "some room hashhhhhhhhhhhhhhhhhhh"
    
    
    
    #above code is for taking the booked entry for the hotel room. chage it for next 7 days   
    #take next 7 daye hotel room book data detail from the month which user has selected. if the month is december then next year 
    #jan is there.
    # this code i think is for creating a blank array may be in javascript array i needed it.
    HotelRoom.find(:all).each do |hrr| 
      if @room_hash.has_key?(hrr.product_id.name)
      else
         if params[:room_type] == "All Rooms"     
            @room_hash[hrr.product_id.name] =   []   
         elsif params[:room_type] == hrr.categ_id.name
            @room_hash[hrr.product_id.name] =   []       
         end
      end 
    end  
    logger.info  "wwwwwwwwwwwwwwwwwww"
    logger.info @room_hash.inspect
    #here the room hash is created with the rooms within that date range

    logger.info "s9879sa7xxsa"
    next_seven_day_code

    render :layout=>false
  end
    #here i need to fetch the room record for next 7 days of currently user selected month
  def next_seven_day_code
    @nextdate = @date.next_month
    all_res_room = HotelRoomBookingHistory.find(:all)
    @room_hash_next_seven_day = {}
    logger.info all_res_room
    logger.info "all res room"
    logger.info all_res_room.size
    all_res_room.each do |each_room|
      dayrange = []
      #here i get
      logger.info "from 8 loop"
      logger.info each_room.name
      logger.info each_room.check_in_date.month.to_i
       if  each_room.check_in_date.month.to_i == @nextdate.month
        logger.info "next 7 day"
        if each_room.check_in_date.year.to_i == @nextdate.year
          logger.info "next 7 year"
          if each_room.check_out_date > @nextdate
            logger.info "next monthhhhhh"                 
            dayrange = each_room.check_in_date.day .. @nextdate.day               
          else
            logger.info "nesdtdtdtdtdt"
            if   each_room.check_out_date.day > 8
              logger.info "whwhwhwhwh"
              dayrange = each_room.check_in_date.day .. 8
            else
              logger.info "888s88a8s8a8s8s88"
              dayrange = each_room.check_in_date.day .. each_room.check_out_date.day
            end  
          end
          logger.info each_room.name
          logger.info "room name"
        end
      elsif each_room.check_in_date.month.to_i < @nextdate.month
        logger.info "lesssss"
        logger.info each_room.name
        if each_room.check_in_date.year.to_i == @nextdate.year
          logger.info "848484fgfgftttftftf"
          if each_room.check_out_date.month == @nextdate.month        
            logger.info "8s78s78s78s7s87s87s"
            if  each_room.check_in_date.day < 2
              dayrange = each_room.check_in_date.day .. each_room.check_out_date.day
            else
              dayrange = 1 .. each_room.check_out_date.day
            end
          elsif each_room.check_out_date.month > @nextdate.month
            dayrange = 1 ..  7
            logger.info "555555555555555555555555555555555"    
          end      
        end
      elsif   each_room.check_in_date.year.to_i < @nextdate.year
        logger.info "actually it should come here"
        if each_room.check_out_date.month > @nextdate.month
          logger.info "yes i am coming hererererer"
          if each_room.check_out_date.year.to_i == @nextdate.year 
            dayrange = 1 ..  7
          end
        elsif each_room.check_out_date.month == @nextdate.month
          logger.info "but i should not come herererer"                 
          dayrange = 1 ..  each_room.check_out_date.day                
        end
        logger.info each_room.name
        logger.info "room name"      
      end

      dayrangedate = []
      dayrange.each do |dd|
        dayrangedate << dd
      end
      if @room_hash_next_seven_day.has_key?(each_room.name)
        @room_hash_next_seven_day[each_room.name] =   @room_hash_next_seven_day[each_room.name] + dayrangedate 
      else
         if params[:room_type] == "All Rooms"     
           @room_hash_next_seven_day[each_room.name] =   dayrangedate
         elsif params[:room_type] ==  each_room.category_id.name     
               @room_hash_next_seven_day[each_room.name] =   dayrangedate    
         end 
      end
    end
   
    HotelRoom.find(:all).each do |hrr|        
      if @room_hash_next_seven_day.has_key?(hrr.product_id.name)
      else        
        if params[:room_type] == "All Rooms"     
            @room_hash_next_seven_day[hrr.product_id.name] =   []   
        elsif hrr.categ_id.name == params[:room_type]             
            @room_hash_next_seven_day[hrr.product_id.name] =   []   
        end
      end  
    end
    #here the room hash is created with the rooms within that date range
    @datenext = Date.civil(@date.next_month.year.to_i,@date.next_month.month.to_i,-1)
    logger.info "lastly it is blank"
    # p @room_hash_next_seven_day
  end
  
  
      def create_a_year_calender(month,year,all_res_room)
     @fullcalender = true 
     p "==========================================="
     logger.info "this is monthdddddddddddddddddddddddd"
     logger.info month.to_i
     p month.to_i
     month = 1
     @date_array = []
     @room_hash_array = []
     
     #this loop is for 12 times because i wanted each room booking status in each month
     for i in 1..12
         @date = Date.civil(year.to_i,i,-1)    
         @date_array << @date
     p @date
     #above fetchinga all the booked rooms
     p all_res_room
     logger.info all_res_room
     logger.info "all res room"
     logger.info all_res_room.size
     #loop on fetched booked room
     local_room_hash = {} 
     logger.info "this is all res roooommmmmm"
     logger.info all_res_room.inspect
    all_res_room.each do |each_room|
      
      dayrange = []
      #here i get
      logger.info "from 8 loop"
      logger.info each_room.name
      logger.info each_room.check_in_date
      if params[:date] 
        p params[:date]
        #  5 day and 5 month and date is 15
        logger.info "rooooooooooooooooo"
        logger.info each_room.name
        logger.info each_room.check_in_date
        logger.info @date
        logger.info "this is atooooooooooo datewswswswswswsws"
        logger.info each_room.check_in_date.class
        logger.info @date.class
        if each_room.check_in_date < @date
          logger.info "465d46a5d4654d"
          #it will come here because the @date is the last day of the month
          if   each_room.check_out_date > @date
            logger.info "5as45a4s5a454"
            if each_room.check_out_date.month > @date.month                
              if each_room.check_in_date.month == @date.month
                dayrange = each_room.check_in_date.day .. @date.day
              else
                dayrange = 1 .. @date.day
              end                
            else                 
              dayrange = 1 .. @date.day            
            end
          elsif each_room.check_in_date.month < @date.month
            if  each_room.check_out_date.year > @date.year
              dayrange = 1..@date.day
            elsif each_room.check_out_date.month > @date.month
              if each_room.check_in_date.year == @date.year
                dayrange = 1..@date.day
              end
            else
              logger.info "why does not it come hererere"
              if each_room.check_out_date.month == @date.month
                if each_room.check_in_date.year == @date.year
                  dayrange = 1..each_room.check_out_date.day
                end
              end
            end
          elsif  each_room.check_in_date.month == @date.month            
            logger.info each_room.name
            logger.info each_room.check_in_date.month
            logger.info @date.month
            logger.info "this is monthhhhh4857"
            logger.info each_room.check_in_date.day..each_room.check_out_date.day      
            logger.info "this is date range"
            if each_room.check_in_date.year == @date.year
              dayrange = each_room.check_in_date.day..each_room.check_out_date.day      
            end     
          elsif each_room.check_out_date < @date
            logger.info each_room.name
            logger.info each_room.check_in_date.month
            logger.info @date.month
            logger.info "this is monthhhhh48575485"
            logger.info 1..each_room.check_out_date.day    
            if  each_room.check_out_date.year == @date.year 
              if each_room.check_out_date.month == @date.month 
                dayrange = 1..each_room.check_out_date.day     
              end
            end
         elsif each_room.check_out_date == @date
            logger.info "lastly it come hererdffdfd"
            logger.info each_room.check_out_date < @date
            logger.info each_room.check_out_date
           logger.info @date.inspect
            dayrange = 1..each_room.check_out_date.day   
          end
        elsif each_room.check_in_date == @date # means it is last date
          dayrange =  @date.day .. @date.day
          logger.info "wsws5s454sw4s54s"         
        end
      else
      end
      dayrangedate = []
      dayrange.each do |dd|
        dayrangedate << dd
      end
      if local_room_hash.has_key?(each_room.name)
        local_room_hash[each_room.name]  =   local_room_hash[each_room.name] + dayrangedate     
      else       
        logger.info  each_room.category_id.name
        logger.info "catiddddddddddddd"
        if params[:room_type] == "All Rooms"     
           local_room_hash[each_room.name] =   dayrangedate
        elsif params[:room_type] == each_room.category_id.name       
           local_room_hash[each_room.name] =   dayrangedate
        end    
      end
      
      
    end
    @room_hash_array << local_room_hash
    end
     #what i need to do here is i need to add all the room names which are not included in the above room hash
     #so that in view my sort functionality should work
     #what i need to do here is i need to loop on each room hash object  and check weather that key 
     #is present in that hash or not if its present then dont do anything else just add a blank array
         HotelRoom.all.each do |ern|
          
           @room_hash_array.each do |local_room_hash|      
      
               if local_room_hash.has_key?(ern.name)
                          
               else       
                        
                    if params[:room_type] == "All Rooms"     
                         local_room_hash[ern.name] =    []
                     
                    end    
               end
           end
      
      
      end

         
    #above code is for taking the booked entry for the hotel room. chage it for next 7 days   
    #take next 7 daye hotel room book data detail from the month which user has selected. if the month is december then 
    #next year jan is there.
    logger.info  "wwwwwwwwwwwwwwwwwww7777777788"
    logger.info @room_hash.inspect
    logger.info @room_hash_array
    #here the room hash is created with the rooms within that date range
    logger.info "s9879sa7xxsa"
    render :layout=>false
      return 
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
    #this will return an rooms which are booked in that period
    logger.info "888888888888@book_room_array"
    logger.info @book_room_array
    logger.info "some category@category"
    logger.info @category
    logger.info "rommmmmmmmm@room"
    logger.info @room
    logger.info @room
    logger.info "roommmmmmm"
    #
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
     #here i need to add one more condition that is when its allocated to gds then done show it. it should not be displayed
     #here on web page
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
        #so here checking of company id is proper because its related to room and not of respartner
       if hr.company_id.id.to_s ==  params["company_id"].to_s
         logger.info "inside a company is sameeeeeeeeeeeee"
        if hr.product_id
          logger.info "inside a product iddddddddddddddddd"
          logger.info "inside the room"
          logger.info hr.product_id.categ_id.name
          logger.info hr.product_id.categ_id.id
          #category array is of category name and category id
          @category << [hr.product_id.categ_id.name,hr.product_id.categ_id.id]  
          logger.info hr.product_id.name
          logger.info hr.product_id.id
          logger.info hr.product_id.categ_id.id
          #room array is of product name , product id, product category id
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
     #actually here i need the the array should be of room id or product id.
    booked_room.each do |rn|
      name_array << rn.history_id.product_id.id
    end
     logger.info "returning the array"
    logger.info name_array    
    name_array    
    #here i need ad.each do d this array that is if the room is allocated to gds then also done show i will get this by 
     paramschecking = Date.new(params['checkin'].split(" ")[0].to_s.split("/")[2].to_i,params['checkin'].split(" ")[0].to_s.split("/")[0].to_i,params['checkin'].split(" ")[0].to_s.split("/")[1].to_i )
     paramschekoutg = Date.new(params['checkout'].split(" ")[0].to_s.split("/")[2].to_i,params['checkout'].split(" ")[0].to_s.split("/")[0].to_i,params['checkout'].split(" ")[0].to_s.split("/")[1].to_i )
     HotelReservationThroughGdsConfiguration.all.each do |ehrtgdsc|
      booked = false
      #here i am using a short line of in between of dates
      if paramschecking >= ehrtgdsc.name  and paramschekoutg <= ehrtgdsc.to_date
          logger.info "I am her88e4"
          booked = true
        elsif paramschecking >= ehrtgdsc.name  and paramschekoutg >= ehrtgdsc.to_date  and paramschecking <= ehrtgdsc.to_date  and ehrtgdsc.name >  paramschekoutg
          logger.info "I am here744"
          booked = true
        elsif  paramschecking <= ehrtgdsc.name  and paramschekoutg <= ehrtgdsc.to_date  and paramschekoutg >= ehrtgdsc.name    
          booked = true
          logger.info "I am here4"
        elsif  paramschecking <= ehrtgdsc.name  and paramschekoutg >= ehrtgdsc.to_date  
          booked = true
          logger.info "I am here4"
          logger.info paramschecking
        elsif  ehrtgdsc.name <= paramschecking and ehrtgdsc.to_date <= paramschekoutg  and paramschecking <= ehrtgdsc.to_date
          booked = true
          logger.info "I am here5"
           logger.info paramschecking
      end
       if booked  
        logger.info "i think here i should come only 2 times1"
       ehrtgdsc.line_ids.each do |eli|
          for rn in eli.room_number
            logger.info rn.id
            logger.info "i think here i should come only 2 times12"
              name_array << rn.id
         end
       end
      end 
     end
    name_array
  end
  
      private
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

class RoomBooksController < ApplicationController
  # GET /room_books
  # GET /room_books.json
  layout 'gds'
  def index
    #@room_books = RoomBook.all
      logger.info "gds classssssssssss reload the data"
       Ooor.new(:url =>session[:gerpurl], :database => session[:gdatabase], :username => session[:gusername] , :password => session[:userauth] ,:scope_prefix=>'GDS' ,:reload => true)
        hrtgc = GDS::HotelReservationThroughGdsConfiguration.all
      hrtgc.each do |eachobjtoreload|
         eachobjtoreload.reload
       end
     @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @room_books }
    end
  end

  def show_type
     logger.info "show typeeeeeeeeee"
    @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:id])
    logger.info "ssssssssssssssss"
    @hrtgdsconf.reload
    logger.info "77777777777777777777"
    @paramscheckin = @hrtgdsconf.name
    logger.info @paramscheckin
    @paramscheckout = @hrtgdsconf.to_date
    logger.info @paramscheckout
    #from this i need to fetch 
    @hrtgdsconf.line_ids.each do |elid|
             elid.reload
             elid.categ_id.reload
    end
    all_cat_name = []
    @hrtgdsconf.line_ids.each do |elid|
           all_cat_name << elid.categ_id.name
    end
    @all_cat_name = all_cat_name.uniq
  end
  
  
  
  def action_gds_conf
     if params[:commit] == "Delete"
       if !params[:gdshc].blank?
           params[:gdshc].each do |ecid|
             p ecid
             p '55555555'
             @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(ecid)
             @hrtgdsconf.destroy
           end
       end
       redirect_to :back ,:notice=>'Gds Configuration Is Deleted'
    end
    
    if params[:commit] == "Add"
       redirect_to room_books_add_room_path
    end  
   
     
  end
  
  
  #here i need to show a header that is from date and to date fields
  def add_room
     # @prgcat = GDS::ProductCategory.find(:all,:domain=>[['isroomtype','=',true]])
  end
  
  #so here i need to show here the dates in text field only which are hidden and add a room type button
  #here additionally what i need to show is its childrens
  #so here first i need to find out a category then first find out a gdsconf from that find its lines
  #from lines
  #i think here only i need to change and check if the date is overlapped or not.up to this action the person will come by 2
  #ways one is from first time commit button value as 'Get Available Rooms'. and the other way is from last page that is 
  #after an add_to_gds at that time "commit"=>"Add to gds" . so the difference between these 2 are. i need to check 
  # the date overlapping at first step only and not at second step. which i can differentiate be the submit button value
  
  def add_room_date
      begin
        logger.info "just checking here an if GDS is already there then means an user is logged in or not.if not loggedn in"
        logger.info "then redirect to login page else nothing to do"
        logger.info GDS
        
      rescue=>e
        redirect_to gds_auths_path ,:notice=>"Your Session Has Been Expired" and return
      end
      @prgcat = GDS::ProductCategory.find(:all,:domain=>[['isroomtype','=',true]])
      paramscheckin = "#{params[:start_date].split('/')[2]}-#{params[:start_date].split('/')[1]}-#{params[:start_date].split('/')[0]}"
      paramschekout = "#{params[:end_date].split('/')[2]}-#{params[:end_date].split('/')[1]}-#{params[:end_date].split('/')[0]}"
      @hotelgdsconf = GDS::HotelReservationThroughGdsConfiguration.search([ ["to_date","=", paramschekout ],["name","=",paramscheckin ] ])[0]
      @hotelgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(@hotelgdsconf)
      logger.info @hotelgdsconf
      logger.info "@hotelgdsconf@hotelgdsconf@hotelgdsconf@hotelgdsconf@hotelgdsconf"
       paramscheckin1 = Date.civil(params[:start_date].split("/")[2].to_i,params[:start_date].split("/")[1].to_i,params[:start_date].split("/")[0].to_i)
       paramschekout1 = Date.civil(params[:end_date].split("/")[2].to_i,params[:end_date].split("/")[1].to_i,params[:end_date].split("/")[0].to_i)
       #here i need to copy the date range function so that i can see weather the date is overlapped or not  
      if params[:commit] == 'Get Available Rooms'
         allgdsconfgr = GDS::HotelReservationThroughGdsConfiguration.all
         weatherconfisavlornot = false
         allgdsconfgr.each do |hrtgdsconf|
              if paramscheckin1 >= hrtgdsconf.name  and paramschekout1 <= hrtgdsconf.to_date
                    weatherconfisavlornot = true
              elsif paramscheckin1 >= hrtgdsconf.name  and paramschekout1 >= hrtgdsconf.to_date  and paramscheckin1 <= hrtgdsconf.to_date  and hrtgdsconf.name >  paramschekout1
                    weatherconfisavlornot = true
              elsif  paramscheckin1 <= hrtgdsconf.name  and paramschekout1 <= hrtgdsconf.to_date and paramschekout1 >= hrtgdsconf.name  
                    weatherconfisavlornot = true
              elsif  paramscheckin1 <= hrtgdsconf.name  and paramschekout1 >= hrtgdsconf.to_date 
                    weatherconfisavlornot = true
              elsif  hrtgdsconf.name <= paramscheckin1 and hrtgdsconf.to_date <= paramschekout1  and paramscheckin1 <= hrtgdsconf.to_date
                    weatherconfisavlornot = true
              end 
        end
          if weatherconfisavlornot == true
             redirect_to :back ,:notice=>'The Date Is Overlapped'
         end
      end
       logger.info "is this sssssssssssssssssssssssssssss"
       logger.info weatherconfisavlornot
  end
  
  def add_to_gds
  
    logger.info "1111111111111111111111111"
       addtogdsroom = []
     catid =  ""
    params[:addroom].each do |key,value|
      if value == "1"
         logger.info 'this loop is here'
          logger.info "11111111111111111111111114444444444444"
         addtogdsroom << GDS::ProductProduct.find(:all,:domain=>[['name','=',key]])[0].id
         logger.info "i got product id"
         catid = GDS::ProductProduct.find(:all,:domain=>[['name','=',key]])[0].categ_id.id
         logger.info "category id"
      end
    end
    hrtgdsconf = ""
    logger.info "gdsidddd"
    logger.info params[:gdscid]
     if params[:gdscid].blank?
      hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.new
      hrtgdsconf.shop_id = 1
      hrtgdsconf.to_date = params[:checkout]
      hrtgdsconf.name =   params[:checkin]
      hrtgdsconf.save
      hrtgdsconf.reload
    else
      logger.info "already got con"
      hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:gdscid])
    end
    catnotmatched = false
     hrtgdsconf.line_ids.each do |eld|
      #need to test this
      logger.info "is this blankkkkkkkkkkkkk"
      logger.info eld.categ_id.id.to_i
      logger.info catid.to_i
      if eld.categ_id.id.to_i == catid.to_i
        logger.info "already in thjis catg"
         asrmn = eld.associations['room_number']
         asrmn << addtogdsroom
         eld.associations['room_number'] = asrmn.flatten!
         logger.info eld.inspect
         logger.info "888888888888888888"
         eld.save
         catnotmatched = true
      end
    end
    #if the line ids are not present then i need to create here
    alllineids = hrtgdsconf.line_ids
    logger.info alllineids
    logger.info "allllllllllllllllllllll54"
    if catnotmatched == false
      logger.info "hhhhhhhhhhhhhhhhhhhhhhhhhh"
      hrlin = GDS::HotelReservationThroughGdsLine.new
      hrlin.name = hrtgdsconf.id
      hrlin.categ_id = catid
      hrlin.associations['room_number'] = addtogdsroom
      hrlin.save
    end
    logger.info "55555555555555555555555555555555555"
    logger.info "44444444444444444444444444444444444"
    
     redirect_to room_books_add_room_date_path({:room_type=>params[:room_type],:start_date=>params[:start_date],:end_date=>params[:end_date],:gdscid=>hrtgdsconf.id})  
  end
  
  #here i just need to find and delete that particular gdsline
  def check_an_delete_button(params)
    if params[:hgdscline]
      params[:hgdscline].each do |ehdscl|
        hrl=GDS::HotelReservationThroughGdsLine.find(ehdscl)
        hrl.destroy
      end
    end  
    
  end
  
  #  Parameters: {"utf8"=>"✓", "authenticity_token"=>"Q5t9TWEtLfBZMymrupzp+nIrp39sY+VFgvODY2LNDEg=", 
  #  "start_date"=>"01/01/2014", "end_date"=>"31/01/2014", "room_type"=>"DBL", "commit"=>"Add Room"}
  
  #in this action i need to check the commit value of buttons if its delete then call another small action 
  def get_available_room_type
    if params[:commit] == 'delete'
       check_an_delete_button(params)
       if  params[:hgdscline]
         redirect_to :back,:notice=>"The Reservation Line Is Deleted"
       else
         redirect_to :back ,:notice=>"You Have Not Selected Room Type For Deletion"
       end
       
    else
       @prgcat = GDS::ProductCategory.find(:all,:domain=>[['isroomtype','=',true]])
    #fetch all the product whoes isroom is true and category is according to params
    #here what i need to check is is the date range is already there in hotelreservationconfiguration or not
    allgdsconfgr = GDS::HotelReservationThroughGdsConfiguration.all
    paramscheckin = Date.civil(params[:start_date].split("/")[2].to_i,params[:start_date].split("/")[1].to_i,params[:start_date].split("/")[0].to_i)
    paramschekout = Date.civil(params[:end_date].split("/")[2].to_i,params[:end_date].split("/")[1].to_i,params[:end_date].split("/")[0].to_i)
     weatherconfisavlornot = false
    allgdsconfgr.each do |hrtgdsconf|
         if paramscheckin >= hrtgdsconf.name  and paramschekout <= hrtgdsconf.to_date
          weatherconfisavlornot = true
        elsif paramscheckin >= hrtgdsconf.name  and paramschekout >= hrtgdsconf.to_date  and paramscheckin <= hrtgdsconf.to_date  and hrtgdsconf.name >  paramschekout
          weatherconfisavlornot = true
        elsif  paramscheckin <= hrtgdsconf.name  and paramschekout <= hrtgdsconf.to_date and paramschekout >= hrtgdsconf.name  
          weatherconfisavlornot = true
        elsif  paramscheckin <= hrtgdsconf.name  and paramschekout >= hrtgdsconf.to_date 
          weatherconfisavlornot = true
        elsif  hrtgdsconf.name <= paramscheckin and hrtgdsconf.to_date <= paramschekout  and paramscheckin <= hrtgdsconf.to_date
          weatherconfisavlornot = true
        end 
    end
     logger.info "is this sssssssssssssssssssssssssssss"
    logger.info weatherconfisavlornot
     if weatherconfisavlornot == false
    selectedallprd = GDS::ProductProduct.find(:all,:domain=>[['isroom','=',true]])
    @filteredroomarray = []
      @paramscheckin = paramscheckin
    @paramschekout = paramschekout
    #ymd
    #here i am reloading all the things
     selectedallprd.each do |er|
      er.reload
      er.categ_id.reload
     end
     selectedallprd.each do |er|
       if er.categ_id.name == params[:room_type]
         @filteredroomarray  << er.name
      end
    end
    #now from this array i need to delete all the rooms which are already allocated. for creating an array
    #but that should be datewise. so first i need a loop on gdsline then get its booked date. then compare this date to
    #params date . and check if this date range makes some conflict. if yes then remove it else keep it.
    pcid = GDS::ProductCategory.search([['name','=',params[:room_type]]])[0]
    allgdsconfgr = GDS::HotelReservationThroughGdsConfiguration.all
    @bookedgdsc = []
    #here i am getting all the hrtgc and checking if the room is there or not. i just need to copy this code for 
    #the purpose of room can be deleted or not
    allgdsconfgr.each do |hrc|
    hrc.reload  
       if paramscheckin >= hrc.name  and paramschekout <= hrc.to_date
         @bookedgdsc << hrc 
         elsif paramscheckin >= hrc.name  and paramschekout >= hrc.to_date  and paramscheckin <= hrc.to_date  and hrc.to_date >  paramschekout
           @bookedgdsc << hrc 
         elsif  paramscheckin <= hrc.name  and paramschekout <= hrc.to_date  and paramschekout >= hrc.name    
           @bookedgdsc << hrc 
         elsif  paramscheckin <= hrc.name  and paramschekout >= hrc.to_date   
           @bookedgdsc << hrc 
         elsif  hrc.name <= paramscheckin and hrc.to_date <= paramschekout  and paramscheckin <= hrc.to_date
           @bookedgdsc << hrc 
       end 
    end
     logger.info "do i am nillllllllll"
     logger.info @bookedgdsc
    bookedroom = []
    #here its now simple that is get all the room name and then just remove a room name from above all room name array
    #also just check the category type 
    @bookedgdsc.each do |bgds|
      bgds.line_ids.each do |li|
        li.reload
        
         li.room_number.each do |rn|
           rn.reload
            rn.categ_id.reload
         end
       end
     end
    @bookedgdsc.each do |bgds|
      bgds.line_ids.each do |li|
         li.room_number.each do |rn|
          if rn.categ_id.name == params[:room_type]
             bookedroom << rn.name
          end
        end
       end
     end
    #and lastly just removing the rooms
    logger.info "the array before doing a transactions"
    logger.info @filteredroomarray
    logger.info "brrrrrrrrrrrrrrrrrrrrr"
    logger.info bookedroom
    bookedroom.each do |br|
      if @filteredroomarray.include?(br)
         @filteredroomarray.delete(br)
      end
    end
    else
      redirect_to :back ,:notice=>"The Date Is Overlapped"
    end
    end
     
  end 
  
  
  
  def available_for_gds
      #now here i need to fetch all the rooms allocated in this hrcgds
    #so again i need to find gds configuration so that in view i can show all the room names by loop
    @gdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:gdsid])
    if params[:commit]=='Save'
       paramscheckin = "#{params[:start_date].split('/')[2]}-#{params[:start_date].split('/')[1]}-#{params[:start_date].split('/')[0]}"
       paramschekout = "#{params[:end_date].split('/')[2]}-#{params[:end_date].split('/')[1]}-#{params[:end_date].split('/')[0]}"
    
         @gdsconf.to_date = paramschekout
         @gdsconf.name =   paramscheckin
         @gdsconf.save
         redirect_to :back ,:notice=>"The Values Has Been Updated"
    end
    
    
  end
  
  
  
  def delete_gdsline
    p "here is the delete gdslineeeeeeeeee"
    p params
   
  end
  
  
  # GET /room_books/1
  # GET /room_books/1.json
  def show
    @room_book = RoomBook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room_book }
    end
  end

  # GET /room_books/new
  # GET /room_books/new.json
  def new
    @room_book = RoomBook.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room_book }
    end
  end

  # GET /room_books/1/edit
  def edit
    @room_book = RoomBook.find(params[:id])
  end

  # POST /room_books
  # POST /room_books.json
  def create
    @room_book = RoomBook.new(params[:room_book])

    respond_to do |format|
      if @room_book.save
        format.html { redirect_to @room_book, notice: 'Room book was successfully created.' }
        format.json { render json: @room_book, status: :created, location: @room_book }
      else
        format.html { render action: "new" }
        format.json { render json: @room_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /room_books/1
  # PUT /room_books/1.json
  def update
    @room_book = RoomBook.find(params[:id])

    respond_to do |format|
      if @room_book.update_attributes(params[:room_book])
        format.html { redirect_to @room_book, notice: 'Room book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @room_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_books/1
  # DELETE /room_books/1.json
  def destroy
    @room_book = RoomBook.find(params[:id])
    @room_book.destroy

    respond_to do |format|
      format.html { redirect_to room_books_url }
      format.json { head :no_content }
    end
  end
end

class RoomBooksController < ApplicationController
  # GET /room_books
  # GET /room_books.json
   require 'xmlrpc/client'
     require 'xmlsimple' 
   before_filter :check_gds_availability
   
  layout 'room_book'
  def index
    #@room_books = RoomBook.all
      logger.info "gds classssssssssss reload the data"
      #if the shop id is present then store it in session for future reference
    if params[:shop_id]
      session[:gds_shop_id] = params[:shop_id]
      session[:gds_shop_id_name] = GDS::SaleShop.find(params[:shop_id].to_i).name
    end
       if session[:gerpurl].blank?
         redirect_to gds_auths_path and return
       end
        Ooor.new(:url =>session[:gerpurl], :database => session[:gdatabase], :username => session[:gusername] , :password => session[:userauth] ,:scope_prefix=>'GDS' ,:reload => true)
        hrtgc = GDS::HotelReservationThroughGdsConfiguration.all
        hrtgc.each do |eachobjtoreload|
           eachobjtoreload.reload
        end
    #this code is for reload that is why no need to put an condition of gds_shop_id   
    logger.info "gds shop idddddddd"
    logger.info session[:gds_shop_id]
    if params[:page].blank?
      @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.search([['shop_id','=',session[:gds_shop_id].to_i]],0,20)
    else
      if params[:page].to_i == 20
         @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.search([['shop_id','=',session[:gds_shop_id].to_i]],0,20)
      end
      if params[:page].to_i == 40
         @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.search([['shop_id','=',session[:gds_shop_id].to_i]],0,40)
      end
      if params[:page] ==  'unlimited'
         @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.search([['shop_id','=',session[:gds_shop_id].to_i]])
      end
      
      
      
    end
     
     @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(@hrtgdsconf)
     
     respond_to do |format|
        format.html  {render :layout=>"gds"}
        format.json { render json: @room_books }
     end
  end
  
  
  
  
  
  #this method will allow user to select a shop
  def select_shop
     @select_shop = GDS::SaleShop.find(:all,:domain=>[['company_id','=',session[:gds_company_id].to_i ]])
      render :layout=>"gds"
 
  end 
  
     
  
  def show_view
    begin
      logger.info GDS
    rescue
      redirect_to gds_auths_path ,:notice=>'Your Session Has Been Expired Please Login'  and return 
    end
    
    
    @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:id])
     render :layout=>"gds"
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
 
    all_cat_name = []
    @hrtgdsconf.line_ids.each do |elid|
           if elid.categ_id
             all_cat_name << elid.categ_id.name
           end
    end
    @all_cat_name = all_cat_name.uniq
     render :layout=>"gds"
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
     #here i need to copy the code from updateavails for the purpose of updating an count on reconline.com
     if params[:commit] == "Synchronize"
        synch_selected_gdsconf(params) 
        redirect_to :back ,:notice=>'Selected Gds Configuration Has Been Updated'
     end
     if params[:commit].blank? and !params[:page].blank?
        redirect_to room_books_path(:page=>params[:page])
     end
  end
  
  #the down method will select and synch an particular gdsconf
  
  def synch_selected_gdsconf(params)
       if !params[:gdshc].blank?
           params[:gdshc].each do |ecid|
             p ecid
             p '55555555'
             #@hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(ecid)
             #here i need to copy an code for updating an particular gds conf count 
             synch_this_gds_conf(ecid)
           end
       end
  end
  
  
  def synch_this_gds_conf(ecid)
  #first i am copying an code which will create an one array element for the purpose of updating an count on reconline.com
  @main_array = []
    hrgds = GDS::HotelReservationThroughGdsConfiguration.find(ecid)
    #GDS::HotelReservationThroughGdsConfiguration.all.each do |hrgds|
      child_array = []
      child_array << Date.civil(hrgds.name.year,hrgds.name.month,hrgds.name.day)
      child_array << Date.civil(hrgds.to_date.year,hrgds.to_date.month,hrgds.to_date.day)
      room_type_hash = {}
      if hrgds.shop_id.id == session[:gds_shop_id].to_i
        #the above condition i am putting because its change in this new version
        hrgds.line_ids.each do |eli|
          #here i need to add one more condition and that is of just checking an room type.because currently 
          #its limited to DBL,KING
           if eli.categ_id.name == "DBL" or  eli.categ_id.name == "KING"
              room_type_hash[eli.categ_id.name]=eli.associations['room_number'].count
           end
        end
      end
       child_array << room_type_hash
      @main_array << child_array
    #end
     @main_array.each do |eca|
         #here i will call a seperate function because the functionality is little more
         check_room_available_and_update_count(eca)
     end
 end
    
 
  
   def check_room_available_and_update_count(eca)
    
   date1 = eca[0]
   date2 = eca[1]
    logger.info date1
    logger.info date2
    logger.info date2.class
    logger.info "some datesssssss"
      uri = URI('http://test.reconline.com/recoupdate/update.asmx/GetAvailFB')
      uri1 = URI('http://test.reconline.com/recoupdate/update.asmx/UpdateAvail')
  #i need to create a loop again because an keys of hash may be multiple and i am parsing an count only by a 
  #particular room type
    #i can put here key of 0 because i know that 
   #and all this should be in date range 
   logger.info "this all need to changeeeeeeeeeeeeeeeeeeee"
   logger.info eca
  for actd in date1..date2  
      eca[2].keys.each do |ek|  
      res = Net::HTTP.post_form(uri, "User"=>"kedar","Password"=>"ked2012","idHotel"=>"38534","idSystem"=>0,"ForeignPropCode"=>'blank',
            "IncludeRateLevels"=>"BAR" ,"ExcludeRateLevels"=>"","IncludeRoomTypes"=>ek,"ExcludeRoomTypes"=>"","StartDate"=>"#{actd.day}.#{actd.month}.#{actd.year}",
            "EndDate"=>"#{actd.day}.#{actd.month}.#{actd.year}" )
        logger.info "the paaramsmsmsms"
        logger.info res.inspect
        logger.info res.to_hash
        logger.info res.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        logger.info res.body
        config = XmlSimple.xml_in(res.body)
         logger.info config.inspect
         logger.info "this is configgggggggggggggggggggggggggggg"
         theavailroomsis = config['diffgram'][0]['NewDataSet'][0]['Availability'][0]['AVAIL'][0] 
         logger.info "i should get this as 90"
         logger.info theavailroomsis
         theavailroomsis = theavailroomsis.split(":")[1]
          logger.info theavailroomsis.to_i
          if eca[2][ek].to_i > theavailroomsis.to_i
             #if it is greater then i need to reduce that much count
             thenum = eca[2][ek].to_i - theavailroomsis.to_i
             logger.info "so this is the difference"
             logger.info thenum
             logger.info eca[2][ek].to_i
             #now need to update this number
             logger.info "before sending a request"
              res = Net::HTTP.post_form(uri1, "User"=>"kedar","Password"=>"ked2012","idHotel"=>'38534',"idSystem"=>0,"ForeignPropCode"=>'blank',
        "IncludeRateLevels"=>"BAR","ExcludeRateLevels"=>"","IncludeRoomTypes"=>ek,"ExcludeRoomTypes"=>"","StartDate"=>"#{actd.day}.#{actd.month}.#{actd.year}",
        "Availability"=>"+#{thenum}")
              logger.info "after sending a request"
         end
          if eca[2][ek].to_i < theavailroomsis.to_i
            thenum = theavailroomsis.to_i - eca[2][ek].to_i  
             #now need to update this number
             logger.info "this is gggggggggggg"
             logger.info thenum
             logger.info eca[2][ek].to_i
             res = Net::HTTP.post_form(uri1, "User"=>"kedar","Password"=>"ked2012","idHotel"=>'38534',"idSystem"=>0,"ForeignPropCode"=>'blank',
        "IncludeRateLevels"=>"BAR","ExcludeRateLevels"=>"","IncludeRoomTypes"=>ek,"ExcludeRoomTypes"=>"","StartDate"=>"#{actd.day}.#{actd.month}.#{actd.year}",
        "Availability"=>"-#{thenum}") 
      logger.info res
      logger.info res.body
      logger.info "8888888888888888888"
         end
          #now here if this count is bigger then that much count i need to reduce else if the count is less then
         #increase the count and then call a web service again.
       end
  end  
  end
  
  
  
  
  
  #here i need to show a header that is from date and to date fields
  def add_room
     # @prgcat = GDS::ProductCategory.find(:all,:domain=>[['isroomtype','=',true]])
     render :layout=>"gds" 
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
      logger.info "with this shop id i am making an query to hrtgc"
      @hotelgdsconf = GDS::HotelReservationThroughGdsConfiguration.search([["to_date","=", paramschekout ],["name","=",paramscheckin ],["shop_id","=",session[:gds_shop_id].to_i ]])[0]
      @hotelgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(@hotelgdsconf)
      logger.info @hotelgdsconf
      logger.info "@hotelgdsconf@hotelgdsconf@hotelgdsconf@hotelgdsconf@hotelgdsconf"
       paramscheckin1 = Date.civil(params[:start_date].split("/")[2].to_i,params[:start_date].split("/")[1].to_i,params[:start_date].split("/")[0].to_i)
       paramschekout1 = Date.civil(params[:end_date].split("/")[2].to_i,params[:end_date].split("/")[1].to_i,params[:end_date].split("/")[0].to_i)
       #here i need to copy the date range function so that i can see weather the date is overlapped or not  
     #because here the room is assigned to a particular shop and its assume that one room has only one shop.so in the down loop 
     #there is no need to particularly check the shop id of HotelReservationThroughGdsConfiguration. because in any case if the
     #date is overlapped 
     if params[:commit] == 'Get  Rooms'
         allgdsconfgr = GDS::HotelReservationThroughGdsConfiguration.find(:all,:domain=>[['shop_id','=',session[:gds_shop_id].to_i]])
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
             redirect_to :back ,:notice=>'The Date Is Overlapped' and return
         end
      end
       logger.info "is this sssssssssssssssssssssssssssss"
       logger.info weatherconfisavlornot
       render :layout=>"gds" 
  end
  
  def add_to_gds
    #begin
    #its because when showing an rooms that is products i am showing only that particular shop id products.
    #so again here there is no need to check again
    logger.info "1111111111111111111111111"
       addtogdsroom = []
     catid =  ""
    params[:addroom].each do |key,value|
      if value == "1"
         logger.info 'this loop is here'
          logger.info "11111111111111111111111114444444444444"
         addtogdsroom << GDS::ProductProduct.find(key).id
         logger.info "i got product id"
         catid = GDS::ProductProduct.find(key).categ_id.id
         logger.info "category id"
      end
    end
    hrtgdsconf = ""
    logger.info "gdsidddd"
    logger.info params[:gdscid]
     if params[:gdscid].blank?
      hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.new
      hrtgdsconf.shop_id = session[:gds_shop_id]
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
       
      if eld.categ_id && eld.categ_id.id.to_i == catid.to_i
        logger.info "already in thjis catg"
         asrmn = eld.associations['room_number']
         asrmn << addtogdsroom
         asrmn = asrmn.flatten!
         logger.info asrmn
         logger.info "1111111111"
         logger.info asrmn.uniq
         
         asrmn = asrmn.uniq
         logger.info asrmn
         logger.info "44444444444444444444455555"
          
         #this above condition i am putting because sometimes there is error if user go back and submit a form again.
         #this is not the case of openerp but in web form it might happen
         eld.associations['room_number'] = asrmn
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
    
     #redirect_to room_books_add_room_date_path({:room_type=>params[:room_type],:start_date=>params[:start_date],:end_date=>params[:end_date],:gdscid=>hrtgdsconf.id})  
    redirect_to "/room_books/show_type/"+hrtgdsconf.id.to_s,:notice=>"The Room Is Added To A Configuration"  and return
   # rescue => e
   #   logger.info "1111111111111111111"
   #   logger.info e.message
   #   logger.info "666666666666666666"
   #   logger.info e.inspect
   #   logger.info "44444444444444444444444444444444444444444"
   #   redirect_to room_books_path ,:notice=>e.message and return
    #end
  
  end
  
  #here i just need to find and delete that particular gdsline
  def check_an_delete_button(params)
    if params[:hgdscline]
      params[:hgdscline].each do |ehdscl|
        hrl=GDS::HotelReservationThroughGdsLine.find(ehdscl)
        if hrl
        hrl.destroy
        end
      end
    end  
    
  end
  
  #  Parameters: {"utf8"=>"✓", "authenticity_token"=>"Q5t9TWEtLfBZMymrupzp+nIrp39sY+VFgvODY2LNDEg=", 
  #  "start_date"=>"01/01/2014", "end_date"=>"31/01/2014", "room_type"=>"DBL", "commit"=>"Add Room"}
  
  #in this action i need to check the commit value of buttons if its delete then call another small action 
  def get_available_room_type
     Ooor.new(:url =>session[:gerpurl], :database => session[:gdatabase], :username => session[:gusername] , :password => session[:userauth] ,:scope_prefix=>'GDSA' ,:reload => true)
      
    if params[:commit] == 'delete'
       check_an_delete_button(params)
       if  params[:hgdscline]
         redirect_to :back,:notice=>"The Reservation Line Is Deleted" and return
       else
         redirect_to :back ,:notice=>"You Have Not Selected Room Type For Deletion" and return
       end
       
    else
      
       @prgcat = GDSA::ProductCategory.find(:all,:domain=>[['isroomtype','=',true]])
    #fetch all the product whoes isroom is true and category is according to params
    #here what i need to check is is the date range is already there in hotelreservationconfiguration or not
    allgdsconfgr = GDSA::HotelReservationThroughGdsConfiguration.all
    paramscheckin = Date.civil(params[:start_date].split("/")[2].to_i,params[:start_date].split("/")[1].to_i,params[:start_date].split("/")[0].to_i)
    paramschekout = Date.civil(params[:end_date].split("/")[2].to_i,params[:end_date].split("/")[1].to_i,params[:end_date].split("/")[0].to_i)
     
   
    selectedallprd = GDSA::ProductProduct.find(:all,:domain=>[['isroom','=',true],['shop_id','=',session[:gds_shop_id].to_i]])
    #so by putting this condition in above query for shop id i will show all the rooms related to  a particular shop. so there is
    #no possiblity to add a room to a gdsconf for different type of room
    @filteredroomarray = []
      @paramscheckin = paramscheckin
      @paramschekout = paramschekout
    #ymd
    
     selectedallprd.each do |er|
       if er.categ_id.name == params[:room_type]
         #what i am changing here in filtered array keeping an product object instead of name
         @filteredroomarray  << er
      end
    end
    #now from this array i need to delete all the rooms which are already allocated. for creating an array
    #but that should be datewise. so first i need a loop on gdsline then get its booked date. then compare this date to
    #params date . and check if this date range makes some conflict. if yes then remove it else keep it.
    pcid = GDSA::ProductCategory.search([['name','=',params[:room_type]]])[0]
    #allgdsconfgr = GDSA::HotelReservationThroughGdsConfiguration.all
    @bookedgdsc = []
    #here i am getting all the hrtgc and checking if the room is there or not. i just need to copy this code for 
    #the purpose of room can be deleted or not
    #the logic is as follows. first i get all the products with that particular shop id
    #the with allgdsconfgr i am taking first all the configuration withing that period.the consept here is one room is allocated
    #to one shop at a time 
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
    #so the above loop is get all the gdsconfiguration from that particular date. and the down loop is getting all the names
    #which are already assigned to gdsconf so that again never need reassign
    @bookedgdsc.each do |bgds|
      bgds.line_ids.each do |li|
         li.room_number.each do |rn|
          if rn.categ_id.name == params[:room_type]
            #here i am making an change and that is instead of nai am keepingme 
             bookedroom << rn
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
      
 
  
    end
    render :layout=>"gds" 
  end 
  
  def edit_available_for_gds
    
  end
  
  def available_for_gds
      #now here i need to fetch all the rooms allocated in this hrcgds
      #so again i need to find gds configuration so that in view i can show all the room names by loop
    begin
      logger.info GDS
    rescue=>e
      redirect_to gds_auths_path ,:notice=>"Your Session Has Been Expired Please Login Again" and return
    end
      if !params[:id].blank?
        id=''
        if params[:id].include? 'avlfgds'
           id = params[:id].split('&&')[0]
           avlfgds = params[:id].split('&&')[1].split("=")[1]
           params[:avlfgds] = avlfgds
           params[:checkin] = params[:id].split('&&')[2].split("=")[1]
           params[:checkout] = params[:id].split('&&')[3].split("=")[1]
        end
        @gdsconf = GDS::HotelReservationThroughGdsConfiguration.find(id)
      else
        @gdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:gdsid])
      end
    if params[:commit]=='Save'
       paramscheckin = "#{params[:start_date].split('/')[2]}-#{params[:start_date].split('/')[1]}-#{params[:start_date].split('/')[0]}"
       paramschekout = "#{params[:end_date].split('/')[2]}-#{params[:end_date].split('/')[1]}-#{params[:end_date].split('/')[0]}"
    
         @gdsconf.to_date = paramschekout
         @gdsconf.name =   paramscheckin
         #here there might be an date overlapping error 
         #so i am putting this code in begin rescue 
         begin
         @gdsconf.save
         rescue=>e
           logger.info e.inspect
           logger.info e.message
           redirect_to room_books_path ,:notice=>e.message and return
         end
         redirect_to room_books_path ,:notice=>"The Values Has Been Updated" and return
    end
    #if it is an add an item then i have to redirect it to add an item method.this method will keep the layout
    #same but it will have an drop down box for selecting an room type
    #Add Room  need to replace Add An Item
    if params[:commit] == 'Add Room'
      
          
         redirect_to room_books_add_an_item_path({:gdsid=>params[:gdsid]}) and return
            
      
    end
    
    
     render :layout=>"gds"
  end
  
    
    #this is just a view rooms 
    def view_rooms
      p params
      p "555555555555555555555"
      @gdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:id])
       render :layout=>"gds"
       
    
    end
  
  
  #this method is get called after creation of rooms that is why the gdsconfid is available so there is no need to check 
  #anything for gdsshopid
  #this method is to show a room which admin can add to this gdsconfigurarion. 
  def add_an_item
      @gdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:gdsid])
      @prgcat = GDS::ProductCategory.find(:all,:domain=>[['isroomtype','=',true]])
      #i am copying here the delete allocated room code because currently i am changing a flow little bit and wanted the deletion
      #of room should be in one page only instead of in different pages.
      if params[:commit] == 'Delete Allocated Rooms'
         params[:deleteroom].each do |key,value|
      if value == "1"
         splittheroomname = key.split('_')
         hrtglrn = GDS::HotelReservationThroughGdsLine.find(splittheroomname[-2]).associations['room_number']
         logger.info "this is firstttttttttttttttttttttttttt"
         logger.info hrtglrn
         #above getting a room number array 
         #here i need to check weather the room is already booked or not. that i will check by a roombookinghistory
         logger.info "do i am checking thisssssssssss"
         logger.info splittheroomname.inspect
         logger.info splittheroomname[-1].to_i
         #first need to find a product for the name purpose
         pr = GDS::ProductProduct.find(splittheroomname[-1].to_i)
         hrtglrn.delete(splittheroomname[-1].to_i)
         logger.info "this is firstttt88888888888888tttttttttttttt"
         logger.info hrtglrn
         #above removing an room number from array variable
         hrtgl = GDS::HotelReservationThroughGdsLine.find(splittheroomname[-2])
         logger.info "there are some errors"
         logger.info hrtgl
         logger.info "some wrong before reservation array"
         logger.info hrtgl.associations['room_number']
         hrtgl.associations['room_number'] = hrtglrn
         logger.info "assigned room number"
         logger.info hrtgl.associations['room_number']
         hrtgl.save
         #so ultimetly its get deleted here
         #and i need to redirect back to 
         #
       end
    end
    redirect_to "/room_books/show_type/"+@gdsconf.id.to_s,:notice=>"Selected Rooms Were Deleted" and return
    end
     
    #if commit value is Show Rooms that means here i need to show all the available rooms for adding to that particular date range
    #
    if params[:commit] == 'Show Rooms'
      #here i need to create an array of all the available rooms of that particular type
      #fetch all the product whoes isroom is true and category is according to params
      #here what i need to check is is the date range is already there in hotelreservationconfiguration or not
      paramscheckin = Date.civil(params[:start_date].split("/")[2].to_i,params[:start_date].split("/")[1].to_i,params[:start_date].split("/")[0].to_i)
      paramschekout = Date.civil(params[:end_date].split("/")[2].to_i,params[:end_date].split("/")[1].to_i,params[:end_date].split("/")[0].to_i)
     #here i need to change this line as i am showing here all the rooms of that particular shop. means one room can be 
     #assigned to one shop that is to one hotel. so if the hotel means shop is different then conceptually one room can 
     #not be assign by gdsconf to different shops. and that is why when showing an room i am checking an shop id. so 
     #ultimetly i am showing only rooms which are allocated to a particular shop and that is why there is no way to 
     #assign an room to multiple shops. this is an conditions i put through an web interface . i am not sure what is 
     #happened in openerp for the same
     #selectedallprd = GDS::ProductProduct.find(:all,:domain=>[['isroom','=',true]])
     selectedallprd = GDS::ProductProduct.find(:all,:domain=>[['isroom','=',true],['shop_id','=',session[:gds_shop_id].to_i]])
     @filteredroomarray = []
     @paramscheckin = paramscheckin
     @paramschekout = paramschekout
     #ymd
      selectedallprd.each do |er|
       if er.categ_id.name == params[:room_type]
         @filteredroomarray  << er
      end
    end
     #now from this array i need to delete all the rooms which are already allocated. for creating an array
     #but that should be datewise. so first i need a loop on gdsline then get its booked date. then compare this date to
     #params date . and check if this date range makes some conflict. if yes then remove it else keep it.
     pcid = GDS::ProductCategory.search([['name','=',params[:room_type]]])[0]
     allgdsconfgr = GDS::HotelReservationThroughGdsConfiguration.all
    #this allgdsconfgr is fine for finding all because there is no need to see an shop id because this i am doing for the purpose of
    #compare and to see weather the room is booked or not.so if i got 
    #here GDS::HotelReservationThroughGdsConfiguration.all  will work for following reason
    #1)its because one room is assigned to shop compulsory.so in final loop where i am deleting an room . so suppose if i 
    #get that this particular room is already assigned then that means that room is assigned to another shop by openerp because
    #from rails app this is not possible. else its already assigned to this particular shop id so it should be removed. so i think
    #its better to keep find all instead of finding it by shop id.
    #
    #
    #allgdsconfgr = GDS::HotelReservationThroughGdsConfiguration.find(:all,:domain=>[['shop_id','=',session[:gds_shop_id].to_i]])
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
    bookedroom = []
 
    @bookedgdsc.each do |bgds|
      bgds.line_ids.each do |li|
         li.room_number.each do |rn|
          if rn.categ_id.name == params[:room_type]
             bookedroom << rn
          end
        end
       end
     end
    #and lastly just removing the rooms
     #34,35 product class is in   bookedroom
    bookedroom.each do |br|
      if @filteredroomarray.include?(br)
        
         @filteredroomarray.delete(br)
      else
         
      end
    end
 
      
      ##################################################################################3
    end
    #here i need to copy the code of adding a rooms to gds
   if params[:commit] == 'Add To Gds'
    #i am copying the code hereeeeeeeeeeeeeeeeeee
         addtogdsroom = []
         catid =  ""
    params[:addroom].each do |key,value|
      if value == "1"
         logger.info 'this loop is here'
          addtogdsroom << GDS::ProductProduct.find(key).id
          logger.info "i got product id"
          catid = GDS::ProductProduct.find(key).categ_id.id
          logger.info "category id"
      end
    end
    hrtgdsconf = ""
    logger.info "gdsidddd"
    logger.info params[:gdscid]
    #@gdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:gdsid])
    #its above already got
      catnotmatched = false
     @gdsconf.line_ids.each do |eld|
      #need to test this
      logger.info "is this blankkkkkkkkkkkkk"
      logger.info eld.categ_id.id.to_i
      logger.info catid.to_i
      if eld.categ_id.id.to_i == catid.to_i
        logger.info "already in thjis catg"
         asrmn = eld.associations['room_number']
         logger.info "there are some conflictssssssssssssssssssssssssssss"
         logger.info asrmn
         logger.info addtogdsroom
         logger.info "ssssssssssssssssssssssssssssssssssssssssssssssssss"
         asrmn << addtogdsroom
         logger.info "7777777777"
         logger.info asrmn
           
         asrmn = asrmn.flatten!
         asrmn = asrmn.uniq
         
         logger.info "2222222222"
          
         eld.associations['room_number'] = asrmn
         logger.info eld.inspect
      
         logger.info "888888888888888888"
         eld.save
         catnotmatched = true 
      end
    end
     if catnotmatched == false
      logger.info "hhhhhhhhhhhhhhhhhhhhhhhhhh"
      hrlin = GDS::HotelReservationThroughGdsLine.new
      hrlin.name = @gdsconf.id
      hrlin.categ_id = catid
      hrlin.associations['room_number'] = addtogdsroom
      hrlin.save
    end
      
    #if the line ids are not present then i need to create here
    
    
    #and copying the code here complete
    
    redirect_to "/room_books/show_type/"+@gdsconf.id.to_s,:notice=>"The Room Is Added To A Configuration"  and return
   end 
    
    render :layout=>"gds" 
  end
  
  
  
  def delete_allocated_room
    
       p params
    p "555555555555555555555555555555"
    #for deleting a room 
    if params[:commit]  == "Add A Room"
      #here i need to add a room 
      params[:start_date] = params[:start_date].to_s.gsub(/[-]/,'/')
      params[:end_date] = params[:end_date].to_s.gsub(/[-]/,'/')
      #the params is yymmdd
      #needtosend id ddmmyy
        start_date = "#{params[:start_date].split('/')[2]}/#{params[:start_date].split('/')[1]}/#{params[:start_date].split('/')[0]}"
        end_date = "#{params[:end_date].split('/')[2]}/#{params[:end_date].split('/')[1]}/#{params[:end_date].split('/')[0]}"
       redirect_to room_books_get_available_room_type_path({:start_date=>start_date,:end_date=>end_date,:room_type=>params[:room_type],:gdscid=>params[:gdscid]})
    else
     #from the above parameter i need to delete a room  through an association
    params[:deleteroom].each do |key,value|
      if value == "1"
          splittheroomname = key.split('_')
         hrtglrn = GDS::HotelReservationThroughGdsLine.find(splittheroomname[-2]).associations['room_number']
         #so in hrtglrn i am taking an array of room numbers
         logger.info "this is firstttttttttttttttttttttttttt"
         logger.info hrtglrn
         #above getting a room number array 
         #here i need to check weather the room is already booked or not. that i will check by a roombookinghistory
         logger.info "do i am checking thisssssssssss"
         logger.info splittheroomname.inspect
         logger.info splittheroomname[-1].to_i
         #first need to find a product for the name purpose
         pr = GDS::ProductProduct.find(splittheroomname[-1].to_i)
         hrtglrn.delete(splittheroomname[-1].to_i)
         logger.info "this is firstttt88888888888888tttttttttttttt"
         logger.info hrtglrn
         #above removing an room number from array variable
         hrtgl = GDS::HotelReservationThroughGdsLine.find(splittheroomname[-2])
         @hcid = hrtgl.name.id
         logger.info "there are some errors"
         logger.info hrtgl
         logger.info "some wrong before reservation array"
         logger.info hrtgl.associations['room_number']
         hrtgl.associations['room_number'] = hrtglrn
         logger.info "assigned room number"
         logger.info hrtgl.associations['room_number']
         hrtgl.save
         #i assume here that this room_number is used for updation and less the number of rooms.
         #but the problem i faced was when its just a one record then it can not assign an blank array at that time
         #i manually delete the record by finding the 
          #so ultimetly its get deleted here
         #and i need to redirect back to 
         #
         #here let me try one more thing that is when i want to make an blank third table at that time this above deletion will
         #not worked. so i am trying here direct xml rpc call if possible .
          if hrtglrn.blank?
           logger.info "this is blankkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk"
           logger.info "at this time i need to fire a query"
                hrtgl.room_number  = [[6, false, []]]
          
         logger.info "assigned room number"
       
         hrtgl.save
               #  server = XMLRPC::Client.new2("http://192.168.1.47:8069/xmlrpc"+"/common")
               #  content = server.call("login", "hotel_mgmt_payment_7" ,"admin","admin")
               #  database = "hotel_mgmt_payment_7"
               #  username = "admin"
               #  password = "admin"

               #  socket = XMLRPC::Client.new( 'http://192.168.1.47', '/xmlrpc/common', 8069 )
               #  user_id = socket.login( database, username, password )
               #  logger.info "the user idddddddddddd"
               #  logger.info user_id
               #  socket = XMLRPC::Client.new( 'http://localhost', '/xmlrpc/object', 8069 )
               #  partners = socket.execute(database, user_id, password,'res.partner', 'read', ['name'])
               #  logger.info partners.inspect
               #  logger.info "8888888888888888888888"
                 
              
          else
            logger.info "this is i like else"
          end 
         #i could not do this because through xmlrpc i can not seen an query execution directly to postgresql
        end
    end
   # redirect_to room_books_path ,:notice=>"Selected Room Has Been Deleted"
    redirect_to "/room_books/show_type/"+@hcid.to_s,:notice=>"Selected Rooms Were Deleted" and return
   
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
  
  
  
  private
  def check_gds_availability
    begin
      logger.info "some gdssssssssssssssss"
      logger.info GDS
      logger.info "555555555555555555555555"
      
    rescue 
      logger.info "no rescueeeeeeeee"
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

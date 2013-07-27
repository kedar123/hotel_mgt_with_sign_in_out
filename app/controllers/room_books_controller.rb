class RoomBooksController < ApplicationController
  # GET /room_books
  # GET /room_books.json
   require 'xmlrpc/client'
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
     @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(:all,:domain=>[['shop_id','=',session[:gds_shop_id].to_i]])
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
     if params[:commit] == 'Get Available Rooms'
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
             redirect_to :back ,:notice=>'The Date Is Overlapped'
         end
      end
       logger.info "is this sssssssssssssssssssssssssssss"
       logger.info weatherconfisavlornot
       render :layout=>"gds" 
  end
  
  def add_to_gds
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
    
     #redirect_to room_books_add_room_date_path({:room_type=>params[:room_type],:start_date=>params[:start_date],:end_date=>params[:end_date],:gdscid=>hrtgdsconf.id})  
    redirect_to "/room_books/show_type/"+hrtgdsconf.id.to_s,:notice=>"The Room Is Added To A Configuration"  and return
 
  
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
    allgdsconfgr = GDSA::HotelReservationThroughGdsConfiguration.all
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
         @gdsconf.save
         redirect_to room_books_path ,:notice=>"The Values Has Been Updated" and return
    end
    #if it is an add an item then i have to redirect it to add an item method.this method will keep the layout
    #same but it will have an drop down box for selecting an room type
    if params[:commit] == 'Add An Item'
      
          
         redirect_to room_books_add_an_item_path({:gdsid=>params[:gdsid]}) and return
            
      
    end
    
    
     render :layout=>"gds"
  end
  
  
  
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
  
    
   
    selectedallprd = GDS::ProductProduct.find(:all,:domain=>[['isroom','=',true]])
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
    logger.info "the array before doing a transactions"
    logger.info @filteredroomarray
    logger.info "brrrrrrrrrrrrrrrrrrrrr"
    logger.info bookedroom
    bookedroom.each do |br|
      if @filteredroomarray.include?(br)
         @filteredroomarray.delete(br)
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
         asrmn << addtogdsroom
         eld.associations['room_number'] = asrmn.flatten!
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
              
               #  server = XMLRPC::Client.new2("http://192.168.1.47:8069/xmlrpc"+"/common")
               #  content = server.call("login", "hotel_kedar_1" ,"admin","admin")
               #  database = "hotel_kedar_1"
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
end

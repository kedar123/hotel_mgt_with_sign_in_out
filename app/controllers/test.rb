 #this method is get called after creation of rooms that is why the gdsconfid is available so there is no need to check 
  #anything for gdsshopid
  #this method is to show a room which admin can add to this gdsconfigurarion. 
  def add_an_item
      @gdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:gdsid])
      
      #the above query is required for the 
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
      @prgcat = GDS::ProductCategory.find(:all,:domain=>[['isroomtype','=',true]])
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
       logger.info "is this shopidddddddddd"
       logger.info session[:gds_shop_id].to_i
       selectedallprd = GDS::ProductProduct.find(:all,:domain=>[['isroom','=',true],['shop_id','=',session[:gds_shop_id].to_i]])
       #so here finding all the products of particular shop and where isroom is true
       logger.info "just checking here what shoukld be an class2222222"
       logger.info "7777777777777777777"  
      @filteredroomarray = []
      @paramscheckin = paramscheckin
      @paramschekout = paramschekout
      #ymd
      selectedallprd.each do |er|
        if er.categ_id.name == params[:room_type]
           @filteredroomarray  << er
        end
      end
      #i should keep the above loop because there is no direct way to fire this type of categorywise fire a query.
     #now from this array i need to delete all the rooms which are already allocated. for creating an array
     #but that should be datewise. so first i need a loop on gdsline then get its booked date. then compare this date to
     #params date . and check if this date range makes some conflict. if yes then remove it else keep it.
    pcid = GDS::ProductCategory.search([['name','=',params[:room_type]]])[0]
    allgdsconfgr = GDS::HotelReservationThroughGdsConfiguration.all
    #this allgdsconfgr is fine for finding all because there is no need to see an shop id because this i am doing for the 
    #purpose of
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
    
    #34,35 product class is in   bookedroom
    bookedroom.each do |br|
      if @filteredroomarray.include?(br)
        logger.info "yes this is include"
        logger.info br.id
        logger.info br.name
         @filteredroomarray.delete(br)
      else
        logger.info "not included"
        logger.info br.id
        logger.info br.name
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
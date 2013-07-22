class UpdateavailsController < ApplicationController
  # GET /updateavails
  # GET /updateavails.json
  layout 'gds'
  require 'xmlsimple' 
  before_filter :reload_me
  
  
  def index
    #updateavails = Updateavail.update_avail

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @updateavails }
    end
  end

  # GET /updateavails/1
  # GET /updateavails/1.json
  def show
    @updateavail = Updateavail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @updateavail }
    end
  end
  
  #changing the logic as per discussion with parikshit its more easy to go with workflow with openerp
  #everywhere i am  reloading an object for the safty purpose.and ooor caches the models and data also 
  def all_list
     logger.info "allllllllllllllllllisttttttttttttttttttttt"
     # if $authenticate.blank?
        logger.info "i am blankkkkkkkkkkkkkkkkkkkkkkkkk"
     #   redirect_to root_url and return
     # else
     #   $authenticate.load_models(['hotel.reservation.through.gds.configuration'])
     # end
      #i am commenting the above code because the global variable is not responding here
      #therefore i am changing here a little code just checking a class here for GDS
      #this GDS is given error when its uninitialize so that i am putting it in begin rescue
      #so if its in begin and error occures then redirect to gds admin path with flash notice
       logger.info "gds classssssssssss reload the data"
       Ooor.new(:url =>session[:gerpurl], :database => session[:gdatabase], :username => session[:gusername] , :password => session[:userauth] ,:scope_prefix=>'GDS' ,:reload => true)
        hrtgc = GDS::HotelReservationThroughGdsConfiguration.all
      hrtgc.each do |eachobjtoreload|
         eachobjtoreload.reload
       end
       @hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.all
  end
  
  #show type here i need to fetch all the lineids to get the categories in that configuration
  #and append that in array and then show that array in view
  #here its because of find i am not reloading this object but because after the find code there are line ids loop.
  #that might be cached that is why keeping a reload loop before use of it
  
  #so what h
  def show_type
    logger.info "show typeeeeeeeeee"
    hrtgdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:id])
    logger.info "ssssssssssssssss"
    hrtgdsconf.reload
    logger.info "77777777777777777777"
    @paramscheckin = hrtgdsconf.name
    logger.info @paramscheckin
    @paramscheckout = hrtgdsconf.to_date
    logger.info @paramscheckout
    #from this i need to fetch 
    hrtgdsconf.line_ids.each do |elid|
             elid.reload
             elid.categ_id.reload
    end
    all_cat_name = []
    hrtgdsconf.line_ids.each do |elid|
           all_cat_name << elid.categ_id.name
    end
    @all_cat_name = all_cat_name.uniq
     
  end
  
  #here i need to add a room to a gds again so for that 
  def add_to_gds
     addtogdsroom = []
     catid =  ""
    params[:addroom].each do |key,value|
      if value == "1"
         logger.info 'this loop is here'
         
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
     redirect_to updateavails_all_list_path    
  end
  
  
  #this method is for the purpose of updating a room count in reconline.com
  #this method should return an array whoes format is 
  #[idofgdscnf,{:dbl=>10,king=>10},startdateobject,edob,]
  def count_rooms
    p $authenticate
    p "74521111111111111111111111111111"
     #i am writing a code here for reloading all the objects as i seen one problem and that is when i delete
     #a room and start an update count it fails actually the code gets run but its not get an updated value. so when 
     #restart a rails server its get updated. so currently i am just checking by reloading each object.weather its
     #updating each day record or not
     
    ##################################a5a55a55a55a5a5a5a555a5a5a5a5a5a5a5a5a5a55a5a5a5a5a5a5a
    HotelReservationThroughGdsConfiguration.all.each do |hrgds|
      hrgds.reload
      hrgds.line_ids.each do |eli|
        eli.reload
      end
    end
    #################################3335a5a5a55a5a55a5a5a5a55a5a5a5a5a5a5a5a5a5a5a55a55a5a5a5
    
    @main_array = []
    HotelReservationThroughGdsConfiguration.all.each do |hrgds|
      child_array = []
      child_array << Date.civil(hrgds.name.year,hrgds.name.month,hrgds.name.day)
      child_array << Date.civil(hrgds.to_date.year,hrgds.to_date.month,hrgds.to_date.day)
      room_type_hash = {}
      hrgds.line_ids.each do |eli|
         room_type_hash[eli.categ_id.name]=eli.associations['room_number'].count
      end
      child_array << room_type_hash
      @main_array << child_array
    end
    logger.info "this is all mani array"
    logger.info @main_array
    
    logger.info "after getting an array now need a loop on that"
    #now a loop
    #in this loop  i first need to fetch the records for each day and update it . its a little time consuming
    #
    @main_array.each do |eca|
      #here i will call a seperate function because the functionality is little more
      check_room_available_and_update_count(eca)
    end
    
    redirect_to updateavails_all_list_path ,:notice=>"updated rooms"
    
  end
  
  #the format is like this
  #[Fri, 28 Jun 2013, Tue, 02 Jul 2013, {"DBL"=>10}]
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
  
  
  
  #here i first need to show all the rooms of type selected by that particular user 
  #in all_list i will get allhrtgc. then in show_type i will show  all the types of that 
  #hrtgc . then here i need to show all the rooms available for gds. for that i need hrtgc id as well
  #here i will get an gdcsid and type 
  #these are the params
  #"avlfgds"=>"KING", "gdsid"=>"1",
  def available_for_gds
    #now here i need to fetch all the rooms allocated in this hrcgds
    #so again i need to find gds configuration so that in view i can show all the room names by loop
    @gdsconf = GDS::HotelReservationThroughGdsConfiguration.find(params[:gdsid])
  end
  
  def delete_allocated_room
    p params
    p "555555555555555555555555555555"
    #for deleting a room 
     
    #from the above parameter i need to delete a room  through an association
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
    redirect_to updateavails_all_list_path
  end
  
  
  #this page should show 2 text field for start date and end date also i will put a static code dbl and king.
  def get_dates
     @prgcat = GDS::ProductCategory.find(:all,:domain=>[['isroomtype','=',true]])
  end
  
  #now on this page i need to show date wise rooms available. so rooms available means . so here its same as 
  #reservation of rooms.also that rooms should be of a particular type like either its dbl or its king.  
  def get_date_wise_available_room
 
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
     
   

  # GET /updateavails/new
  # GET /updateavails/new.json
  def new
    
    
=begin
    #@updateavail = Updateavail.new
#so at backend in controller i should first fetch all the records from loop of 1..12 
#i am making here some static code like i am calculating the 2 years data that is current year and next year
#next year i am considering because let say some one is booking at december and he can book like 25 dec to 1st jan.
#so that is why its 2 year data
#here one problem will occure and that is suppose one gds room is allocated for dec to jan then for a particular year
# i will considered it as only to a december.
#now how should i create an array for 12 months . lets say if there is no record in a particular month then its blank
#but in array the blank word should be there.and if the word blank is there then skip in the view.
anarrayofhrtgc = []
#instead of starting from 1st month  it should start from current month
    for i in Time.now.month..12
      #within a for loop i need to fetch first all the records from gds configuration table.as per a month wise 
      #again i will considered a loop again on the hrtgdscon for the purpose of month.
      #how should i add an blank word in an array.let say there is a variable named as make_me_blank. the default value is
      #true if it goes in if condition then it becomes false.if it is false then there is no need to add blank. if its true
      #then add a blank and make it false
      hrtgdsconf = HotelReservationThroughGdsConfiguration.all
      make_me_blank = []
      #what i will do here is i will create an blank array. and append all the records to that array and lastly append that 
      #array to main array. so by doing this there is no need of variable creation as if its blank then automatically an blank array
      # is get inserted
      for eachhrc in hrtgdsconf
        #here it might happen that there are multiple records for a particular month.so instead of inserting each record
        #i need to collect everything within one array and append that array to a main array.
        #here i need to add a logic for date comparison as its not only a month but an year should be less than or equal to 
        #current date but at the same time the end date should be greater than or equal to todays date so that the booking
        #is done or not on that particular date is came to know.so the conditions are
        #if the name that is start date is less than current date then check its to_date that is end date should be greater than
        #or equal to current date
        #i am doing this because i want to show rooms booked for a particular month and for particular date.but which should 
        #start from current month and a date is available in gdsconfiguration.
        #that is why here an year comparison is imp because a month can be of any year. but what i want is the year should be
        #in the range of current date.which means the start date that is day,month,year should be less than .
        #actually i just wanted to show all the rooms which are available in that particular month. so there is no need for
        #day comparison.just a month and year is sufficient .so get all the gdsconfig with its date then check 
        #first the month is same and then check the year is equal or less and the end date year should be equal or greater
        #and then add
           if eachhrc.name.month == i
             if eachhrc.name.year <= Time.now.year
              if  eachhrc.to_date.year >= Time.now.year
                  make_me_blank << eachhrc
              end
             end
           end
      end
         anarrayofhrtgc << make_me_blank
     end
     #the same above loop i am copying for the purpose next year so for next year it should be from 1 to 12
    for i in 1..12
       hrtgdsconf = HotelReservationThroughGdsConfiguration.all
       make_me_blank = []
       for eachhrc in hrtgdsconf
         if eachhrc.name.month == i && (Time.now.year + 1) == eachhrc.name.year#this is for next year logic
               make_me_blank << eachhrc
         end
       end
         anarrayofhrtgc << make_me_blank
    end 
    #so ultimetly i will get 24 months array first 12 months for current year and second 12 months for next year
    logger.info anarrayofhrtgc
    logger.info "is this an arrayyyyyyyyyyyyyyyyyyy555555555555555555"
     
     
=end    
     #same loop i will copy for the purpose of next year 
     respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @updateavail }
    end
    
    
  end

  # GET /updateavails/1/edit
  def edit
    @updateavail = Updateavail.find(params[:id])
  end

  # POST /updateavails
  # POST /updateavails.json
  def create
    @updateavail = Updateavail.update_avail(params)

    respond_to do |format|
      if @updateavail.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Updateavail was successfully created.'
        format.html { redirect_to  :action=>:index  }
        format.json { render json: @updateavail, status: :created, location: @updateavail }
      else
        flash[:notice] = @updateavail.body
        format.html { render action: "new" }
        format.json { render json: @updateavail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /updateavails/1
  # PUT /updateavails/1.json
  def update
    @updateavail = Updateavail.find(params[:id])

    respond_to do |format|
      if @updateavail.update_attributes(params[:updateavail])
        format.html { redirect_to @updateavail, notice: 'Updateavail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @updateavail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updateavails/1
  # DELETE /updateavails/1.json
  def destroy
    @updateavail = Updateavail.find(params[:id])
    @updateavail.destroy

    respond_to do |format|
      format.html { redirect_to updateavails_url }
      format.json { head :no_content }
    end
  end
  
    #currently ia am checking just a login here . later here all the modules will be reloaded. by use of this the
  #controller code can be minimized.but currently just checking an connection is done or not
  def reload_me
    #as i am commenting the code here because in integration i seen that the global variable is not 
    #in use means its blank . so to salve a reload problem i need to manually reload each method. and each object.
    
    #      if $authenticate.blank?
    #            redirect_to root_url and return
    #      else
            # $authenticate.load_models(['hotel.reservation.through.gds.configuration','hotel.reservation.through.gds.line','product.product','product.category',])    
            #this code will come for optimizing the code means while loading a code in a complete controller i can
            #load a modules for each request. and remove all the loading modules in each different methods. it might
            #happen that the request and response timeout will be increased so that is why i am commenting this now
    #      end 
    
    #as i seen one time error that is when the connection is lost at that time the uninitialize constant
    #error is shown so instead of showing that error i should check this in before filter
    
    begin
      logger.info GDS
    rescue=>e
        logger.info e.inspect
        logger.info e.message
        logger.info "some messageeeeee"
        redirect_to gds_auth_path ,:notice=>"the session has been closed need to login again" and return
    end
    
    
  end
  
  
end

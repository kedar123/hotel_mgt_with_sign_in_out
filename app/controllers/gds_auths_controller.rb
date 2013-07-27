class GdsAuthsController < ApplicationController
   require 'xmlrpc/client'
   layout 'gdsauth'
   #i am keeping the layout different because there is no need to show a link for going back pages.
   
  #this controller i am creating for the purpose of authentication for gds purpose so that there will not be an conflict
  #between web form authentication and gds authentication. so the authentication code from gds that is savon from 
  #authentications controller will be copied here 
  # GET /gds_auths
  # GET /gds_auths.json
  #what i think here is i should not change anything from the web booking form what i should change is and i think this
  #is a simple way that is make every thing dynamic here like an creating a ooor instance with scope prefix.so there will
  #not be any conflict bet 2 apps as the web booking form will use different ooor instance.
  def index
    #@gds_auths = GdsAuth.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gds_auths }
    end
  end

  # GET /gds_auths/1
  # GET /gds_auths/1.json
  def show
    @gds_auth = GdsAuth.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gds_auth }
    end
  end

  # GET /gds_auths/new
  # GET /gds_auths/new.json
  def new
    @gds_auth = GdsAuth.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gds_auth }
    end
  end

  # GET /gds_auths/1/edit
  def edit
    @gds_auth = GdsAuth.find(params[:id])
  end

  # POST /gds_auths
  # POST /gds_auths.json
  def create
     begin
   server = XMLRPC::Client.new2("http://192.168.1.47:8069/xmlrpc"+"/common")
   #here i am making some fields static 
   content = server.call("login", "hotel_kedar_1" ,params[:username].to_s,params[:userauth].to_s)  
     respond_to do |format|
      if  content == 1
        #here i am creating an global variable that is why we can access it into other controller and reload the models 
        #which are not get reloaded by default and cached otherwise.
        #the major change here i need to do is i will create an ooor instance with scope prefix.and not with a $authenticate 
        #variable. so that there will not be an conflict.
        #what i feel here is lets have a $variable be there because i think that will help me reloading in next methods. but same time
        #keep a scope prefix for the purpose of accessing the openerp tables.
        $authenticate = Ooor.new(:url => "http://192.168.1.47:8069/xmlrpc" , :database => "hotel_kedar_1", :username => params[:username] , :password => params[:userauth] ,:scope_prefix=>'GDS' ,:reload => true)
        #here i need to keep the values in session as i seen there is a reload issue in showing all list method
        # in updateavails controller. so what i am doing here is keeping this values in session
        #and try to create a new instance with these values
        session[:gerpurl] =  "http://192.168.1.47:8069/xmlrpc"
        session[:gdatabase] =  "hotel_kedar_1"
        session[:gusername] = params[:username]
        session[:userauth] = params[:userauth]
        #here now a flow is little changed as after authenticate i should show a page where an user can select an 
        #company . so i am just creating an method named select_company
          #format.html { redirect_to admins_path, notice: 'Authenticate was successfully created.' }
          format.html { redirect_to gds_select_company_path, notice: 'Authenticate was successfully created.' }
          
          format.json { render json: $authenticate, status: :created, location: $authenticate }
      else
         format.html { redirect_to gds_auths_path, notice: 'Authentication was unsuccessfull.' }
         format.json { render json: $authenticate.errors, status: :unprocessable_entity }
      end
    end
   rescue =>e
     respond_to do |format|
          format.html { redirect_to gds_auths_path, notice: 'Authentication was unsuccessfull.' }
         format.json { render json: @authenticate.errors, status: :unprocessable_entity }
           end
   end
  end
  
  
  #this method will only show all the companies related to a particular database. there is not much need of layouts
  #as this is just a second step
  def gds_select_company
    @all_companies = GDS::ResCompany.all
  end
  
  

  # PUT /gds_auths/1
  # PUT /gds_auths/1.json
  def update
    @gds_auth = GdsAuth.find(params[:id])

    respond_to do |format|
      if @gds_auth.update_attributes(params[:gds_auth])
        format.html { redirect_to @gds_auth, notice: 'Gds auth was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gds_auth.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gds_auths/1
  # DELETE /gds_auths/1.json
  def destroy
    @gds_auth = GdsAuth.find(params[:id])
    @gds_auth.destroy

    respond_to do |format|
      format.html { redirect_to gds_auths_url }
      format.json { head :no_content }
    end
  end
end

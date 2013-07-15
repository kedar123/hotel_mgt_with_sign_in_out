class AuthenticatesController < ApplicationController
  # GET /authenticates
  # GET /authenticates.json
  def index
    @authenticates = Authenticate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authenticates }
    end
  end

  # GET /authenticates/1
  # GET /authenticates/1.json
  def show
    @authenticate = Authenticate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authenticate }
    end
  end

  # GET /authenticates/new
  # GET /authenticates/new.json
  def new
    @authenticate = Authenticate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @authenticate }
    end
  end

  # GET /authenticates/1/edit
  def edit
    @authenticate = Authenticate.find(params[:id])
  end

  # POST /authenticates
  # POST /authenticates.json
  def create
    @authenticate = Authenticate.new(params[:authenticate])

    respond_to do |format|
      if @authenticate.save
        format.html { redirect_to @authenticate, notice: 'Authenticate was successfully created.' }
        format.json { render json: @authenticate, status: :created, location: @authenticate }
      else
        format.html { render action: "new" }
        format.json { render json: @authenticate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /authenticates/1
  # PUT /authenticates/1.json
  def update
    @authenticate = Authenticate.find(params[:id])

    respond_to do |format|
      if @authenticate.update_attributes(params[:authenticate])
        format.html { redirect_to @authenticate, notice: 'Authenticate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @authenticate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authenticates/1
  # DELETE /authenticates/1.json
  def destroy
    @authenticate = Authenticate.find(params[:id])
    @authenticate.destroy

    respond_to do |format|
      format.html { redirect_to authenticates_url }
      format.json { head :no_content }
    end
  end
  
  def select_company
    @ooor = Ooor.new(:url => 'http://192.168.1.47:8069/xmlrpc', :database => "hotel_kedar_1", :username =>'admin', :password   => 'admin')      #p "Connected to opererp database"
    @res = ResCompany.all 
    logger.info @res.inspect
  end
  
  #by this method 
  # here i need to store everything in the session because after sign in i need to redirect him towards payment preview page
  def sign_in
    
    session["campany_id"] = params["campany_id"]
    session["checkin"] = params["checkin"]
    session["checkout"] = params["checkout"]
    session["selectedroom"] = params["room"]
  end
  
  
   def sign_in_auth
     @useravailable  = ResPartner.search([ ["email","=", "#{params[:useremail]}"],["login_password","=","#{params[:userpassword]}" ] ] )
     if @useravailable.blank?
         redirect_to authenticates_sign_in_path() ,:notice=>"Unsuccessful Login"
     else
       #now i should redirect to a preview page which is similar to previous payment page.
       #here i am keeping a user id in session for future reference
       session[:user_id_avail] = @useravailable[0]
       redirect_to   payments_preview_payment_path
     end
   end
   
   
   def sign_up
     
   end
   
   
  
end

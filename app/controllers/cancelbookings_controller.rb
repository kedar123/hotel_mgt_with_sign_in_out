class CancelbookingsController < ApplicationController
  # GET /cancelbookings
  # GET /cancelbookings.json
  def index
    @cancelbookings = []

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @cancelbookings }
    #end
    
   #getres = Cancelbooking.cancel
   p "the responseee"
   #p getres
   p "and the responseee"
  end

  # GET /cancelbookings/1
  # GET /cancelbookings/1.json
  def show
    @cancelbooking = Cancelbooking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cancelbooking }
    end
  end

  # GET /cancelbookings/new
  # GET /cancelbookings/new.json
  def new
   # @cancelbooking = Cancelbooking.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cancelbooking }
    end
  end

  # GET /cancelbookings/1/edit
  def edit
    @cancelbooking = Cancelbooking.find(params[:id])
  end

  # POST /cancelbookings
  # POST /cancelbookings.json
  def create
    cancelbooking = Cancelbooking.cancel(params)

    respond_to do |format|
      if cancelbooking.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] =  'Cancelbooking was successfully created.'
        format.html { redirect_to :action=>"index"    }
        format.json { render json: @cancelbooking, status: :created, location: @cancelbooking }
      else
        flash[:notice] = cancelbooking.body
        format.html { render action: "new" }
        format.json { render json: @cancelbooking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cancelbookings/1
  # PUT /cancelbookings/1.json
  def update
    @cancelbooking = Cancelbooking.find(params[:id])

    respond_to do |format|
      if @cancelbooking.update_attributes(params[:cancelbooking])
        format.html { redirect_to @cancelbooking, notice: 'Cancelbooking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cancelbooking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cancelbookings/1
  # DELETE /cancelbookings/1.json
  def destroy
    @cancelbooking = Cancelbooking.find(params[:id])
    @cancelbooking.destroy

    respond_to do |format|
      format.html { redirect_to cancelbookings_url }
      format.json { head :no_content }
    end
  end
end

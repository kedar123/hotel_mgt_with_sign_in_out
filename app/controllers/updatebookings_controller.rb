class UpdatebookingsController < ApplicationController
  # GET /updatebookings
  # GET /updatebookings.json
  def index
    #updatebookings = Updatebooking.update_booking

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @updatebookings }
    end
  end

  # GET /updatebookings/1
  # GET /updatebookings/1.json
  def show
    @updatebooking = Updatebooking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @updatebooking }
    end
  end

  # GET /updatebookings/new
  # GET /updatebookings/new.json
  def new
    #@updatebooking = Updatebooking.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @updatebooking }
    end
  end

  # GET /updatebookings/1/edit
  def edit
    @updatebooking = Updatebooking.find(params[:id])
  end

  # POST /updatebookings
  # POST /updatebookings.json
  def create
    updatebooking = Updatebooking.update_booking(params)

    respond_to do |format|
      if updatebooking.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        format.html { redirect_to updatebooking, notice: 'Updatebooking was successfully created.' }
        format.json { render json: updatebooking, status: :created, location: updatebooking }
      else
        format.html { render action: "new" }
        format.json { render json: updatebooking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /updatebookings/1
  # PUT /updatebookings/1.json
  def update
    @updatebooking = Updatebooking.find(params[:id])

    respond_to do |format|
      if @updatebooking.update_attributes(params[:updatebooking])
        format.html { redirect_to @updatebooking, notice: 'Updatebooking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @updatebooking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updatebookings/1
  # DELETE /updatebookings/1.json
  def destroy
    @updatebooking = Updatebooking.find(params[:id])
    @updatebooking.destroy

    respond_to do |format|
      format.html { redirect_to updatebookings_url }
      format.json { head :no_content }
    end
  end
end

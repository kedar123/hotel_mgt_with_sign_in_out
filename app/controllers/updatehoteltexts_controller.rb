class UpdatehoteltextsController < ApplicationController
  # GET /updatehoteltexts
  # GET /updatehoteltexts.json
  def index
    @updatehoteltexts = Updatehoteltext.update_hotel_text

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @updatehoteltexts }
    end
  end

  # GET /updatehoteltexts/1
  # GET /updatehoteltexts/1.json
  def show
    @updatehoteltext = Updatehoteltext.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @updatehoteltext }
    end
  end

  # GET /updatehoteltexts/new
  # GET /updatehoteltexts/new.json
  def new
    @updatehoteltext = Updatehoteltext.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @updatehoteltext }
    end
  end

  # GET /updatehoteltexts/1/edit
  def edit
    @updatehoteltext = Updatehoteltext.find(params[:id])
  end

  # POST /updatehoteltexts
  # POST /updatehoteltexts.json
  def create
    @updatehoteltext = Updatehoteltext.new(params[:updatehoteltext])

    respond_to do |format|
      if @updatehoteltext.save
        format.html { redirect_to @updatehoteltext, notice: 'Updatehoteltext was successfully created.' }
        format.json { render json: @updatehoteltext, status: :created, location: @updatehoteltext }
      else
        format.html { render action: "new" }
        format.json { render json: @updatehoteltext.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /updatehoteltexts/1
  # PUT /updatehoteltexts/1.json
  def update
    @updatehoteltext = Updatehoteltext.find(params[:id])

    respond_to do |format|
      if @updatehoteltext.update_attributes(params[:updatehoteltext])
        format.html { redirect_to @updatehoteltext, notice: 'Updatehoteltext was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @updatehoteltext.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updatehoteltexts/1
  # DELETE /updatehoteltexts/1.json
  def destroy
    @updatehoteltext = Updatehoteltext.find(params[:id])
    @updatehoteltext.destroy

    respond_to do |format|
      format.html { redirect_to updatehoteltexts_url }
      format.json { head :no_content }
    end
  end
end

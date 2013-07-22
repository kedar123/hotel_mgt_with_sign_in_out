class GetroomratecodesController < ApplicationController
  # GET /getroomratecodes
  # GET /getroomratecodes.json
  def index
    #getroomratecodes = Getroomratecode.get_room_rate_codes

    #p getroomratecodes
    p "the response"
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @getroomratecodes }
    end
  end

  # GET /getroomratecodes/1
  # GET /getroomratecodes/1.json
  def show
    @getroomratecode = Getroomratecode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @getroomratecode }
    end
  end

  # GET /getroomratecodes/new
  # GET /getroomratecodes/new.json
  def new
     

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @getroomratecode }
    end
  end

  # GET /getroomratecodes/1/edit
  def edit
    @getroomratecode = Getroomratecode.find(params[:id])
  end

  # POST /getroomratecodes
  # POST /getroomratecodes.json
  def create
     
    @Getroomratecode = Getroomratecode.get_room_rate_codes(params)
    respond_to do |format|
      if @Getroomratecode.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Getroomratecode was successfully created.'
        format.html { redirect_to :action=>:index     }
        format.json { render json: @getroomratecode, status: :created, location: @getroomratecode }
      else
        flash[:notice] = @Getroomratecode.body
        format.html { render action: "new" }
        format.json { render json: @getroomratecode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /getroomratecodes/1
  # PUT /getroomratecodes/1.json
  def update
    @getroomratecode = Getroomratecode.find(params[:id])

    respond_to do |format|
      if @getroomratecode.update_attributes(params[:getroomratecode])
        format.html { redirect_to @getroomratecode, notice: 'Getroomratecode was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @getroomratecode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getroomratecodes/1
  # DELETE /getroomratecodes/1.json
  def destroy
    @getroomratecode = Getroomratecode.find(params[:id])
    @getroomratecode.destroy

    respond_to do |format|
      format.html { redirect_to getroomratecodes_url }
      format.json { head :no_content }
    end
  end
end

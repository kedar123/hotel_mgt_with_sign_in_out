class GetroomratecodefbsController < ApplicationController
  # GET /getroomratecodefbs
  # GET /getroomratecodefbs.json
  def index
    #getroomratecodefbs = Getroomratecodefb.get_room_rate_codes_fb

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @getroomratecodefbs }
    end
  end

  # GET /getroomratecodefbs/1
  # GET /getroomratecodefbs/1.json
  def show
    @getroomratecodefb = Getroomratecodefb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @getroomratecodefb }
    end
  end

  # GET /getroomratecodefbs/new
  # GET /getroomratecodefbs/new.json
  def new
    #@getroomratecodefb = Getroomratecodefb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @getroomratecodefb }
    end
  end

  # GET /getroomratecodefbs/1/edit
  def edit
    @getroomratecodefb = Getroomratecodefb.find(params[:id])
  end

  # POST /getroomratecodefbs
  # POST /getroomratecodefbs.json
  def create
    @getroomratecodefb = Getroomratecodefb.get_room_rate_codes_fb(params)

    respond_to do |format|
      if @getroomratecodefb.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Getroomratecodefb was successfully created.'
        format.html { redirect_to :action=>:index    }
        format.json { render json: @getroomratecodefb, status: :created, location: @getroomratecodefb }
      else
        flash[:notice] = @getroomratecodefb.body
        format.html { render action: "new" }
        format.json { render json: @getroomratecodefb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /getroomratecodefbs/1
  # PUT /getroomratecodefbs/1.json
  def update
    @getroomratecodefb = Getroomratecodefb.find(params[:id])

    respond_to do |format|
      if @getroomratecodefb.update_attributes(params[:getroomratecodefb])
        format.html { redirect_to @getroomratecodefb, notice: 'Getroomratecodefb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @getroomratecodefb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getroomratecodefbs/1
  # DELETE /getroomratecodefbs/1.json
  def destroy
    @getroomratecodefb = Getroomratecodefb.find(params[:id])
    @getroomratecodefb.destroy

    respond_to do |format|
      format.html { redirect_to getroomratecodefbs_url }
      format.json { head :no_content }
    end
  end
end

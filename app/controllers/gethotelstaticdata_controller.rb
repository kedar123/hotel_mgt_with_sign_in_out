class GethotelstaticdataController < ApplicationController
  # GET /gethotelstaticdata
  # GET /gethotelstaticdata.json
  def index
    
    #hotelstatisdata = Gethotelstaticdatum.get_hotel_static_data
    p "the statis data"
    #p hotelstatisdata
    p "the statis datatatat"

   # respond_to do |format|
   #   format.html # index.html.erb
   #   format.json { render json: @gethotelstaticdata }
   # end
  end

  # GET /gethotelstaticdata/1
  # GET /gethotelstaticdata/1.json
  def show
    @gethotelstaticdatum = Gethotelstaticdatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gethotelstaticdatum }
    end
  end

  # GET /gethotelstaticdata/new
  # GET /gethotelstaticdata/new.json
  def new
    #@gethotelstaticdatum = Gethotelstaticdatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gethotelstaticdatum }
    end
  end

  # GET /gethotelstaticdata/1/edit
  def edit
    @gethotelstaticdatum = Gethotelstaticdatum.find(params[:id])
  end

  # POST /gethotelstaticdata
  # POST /gethotelstaticdata.json
  def create
    gethotelstaticdatum = Gethotelstaticdatum.get_hotel_static_data(params)

    respond_to do |format|
      if gethotelstaticdatum.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Gethotelstaticdatum was successfully created.'
        format.html { redirect_to :action=>:index  }
        format.json { render json: @gethotelstaticdatum, status: :created, location: @gethotelstaticdatum }
      else
        flash[:notice] = gethotelstaticdatum.body
        
        format.html { render action: "new" }
        format.json { render json: @gethotelstaticdatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gethotelstaticdata/1
  # PUT /gethotelstaticdata/1.json
  def update
    @gethotelstaticdatum = Gethotelstaticdatum.find(params[:id])

    respond_to do |format|
      if @gethotelstaticdatum.update_attributes(params[:gethotelstaticdatum])
        format.html { redirect_to @gethotelstaticdatum, notice: 'Gethotelstaticdatum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gethotelstaticdatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gethotelstaticdata/1
  # DELETE /gethotelstaticdata/1.json
  def destroy
    @gethotelstaticdatum = Gethotelstaticdatum.find(params[:id])
    @gethotelstaticdatum.destroy

    respond_to do |format|
      format.html { redirect_to gethotelstaticdata_url }
      format.json { head :no_content }
    end
  end
end

class GethotelstaticdatagdsController < ApplicationController
  # GET /gethotelstaticdatagds
  # GET /gethotelstaticdatagds.json
  def index
    @gethotelstaticdatagds = []
    
    p "the response of gethotelstatic datagds" 
  #  p gethotelstaticdatagds
    p "the gethotelstatic " 
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gethotelstaticdatagds }
    end
  end

  # GET /gethotelstaticdatagds/1
  # GET /gethotelstaticdatagds/1.json
  def show
    @gethotelstaticdatagd = Gethotelstaticdatagd.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gethotelstaticdatagd }
    end
  end

  # GET /gethotelstaticdatagds/new
  # GET /gethotelstaticdatagds/new.json
  def new
   # @gethotelstaticdatagd = Gethotelstaticdatagd.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gethotelstaticdatagd }
    end
  end

  # GET /gethotelstaticdatagds/1/edit
  def edit
    @gethotelstaticdatagd = Gethotelstaticdatagd.find(params[:id])
  end

  # POST /gethotelstaticdatagds
  # POST /gethotelstaticdatagds.json
  def create
    gethotelstaticdatagd = Gethotelstaticdatagd.get_hotel_static_data_gds(params)

    respond_to do |format|
      if gethotelstaticdatagd.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Gethotelstaticdatagd was successfully created.'
        format.html { redirect_to :action=>:index  }
        format.json { render json: @gethotelstaticdatagd, status: :created, location: @gethotelstaticdatagd }
      else
        flash[:notice] = gethotelstaticdatagd.body
        format.html { render action: "new" }
        format.json { render json: @gethotelstaticdatagd.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gethotelstaticdatagds/1
  # PUT /gethotelstaticdatagds/1.json
  def update
    @gethotelstaticdatagd = Gethotelstaticdatagd.find(params[:id])

    respond_to do |format|
      if @gethotelstaticdatagd.update_attributes(params[:gethotelstaticdatagd])
        format.html { redirect_to @gethotelstaticdatagd, notice: 'Gethotelstaticdatagd was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gethotelstaticdatagd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gethotelstaticdatagds/1
  # DELETE /gethotelstaticdatagds/1.json
  def destroy
    @gethotelstaticdatagd = Gethotelstaticdatagd.find(params[:id])
    @gethotelstaticdatagd.destroy

    respond_to do |format|
      format.html { redirect_to gethotelstaticdatagds_url }
      format.json { head :no_content }
    end
  end
end

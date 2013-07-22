class GethotelsController < ApplicationController
  # GET /gethotels
  # GET /gethotels.json
  def index
    
    @gethotels = Gethotel.get_hotels(params)
    p "get hotels"
    p @gethotels
    p @gethotels.body
    p "444444444444444444444"
    p @gethotels.class
    p "7777777777777777777"
    
     
    
    @gethotelshash = Hash.from_xml(@gethotels.body) 
   # p gethotels
    p "the get hotels"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gethotels }
    end
  end

  # GET /gethotels/1
  # GET /gethotels/1.json
  def show
    @gethotel = Gethotel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gethotel }
    end
  end

  # GET /gethotels/new
  # GET /gethotels/new.json
  def new
    #@gethotel = Gethotel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gethotel }
    end
  end

  # GET /gethotels/1/edit
  def edit
    @gethotel = Gethotel.find(params[:id])
  end

  # POST /gethotels
  # POST /gethotels.json
  def create
    gethotel = Gethotel.get_hotels(params)
    respond_to do |format|
      if gethotel.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Gethotel was successfully created.'
        format.html { redirect_to  :action=>:index   }
        format.json { render json: @gethotel, status: :created, location: @gethotel }
      else
        flash[:notice] =  gethotel.body
        format.html { render action: "new" }
        format.json { render json: @gethotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gethotels/1
  # PUT /gethotels/1.json
  def update
    @gethotel = Gethotel.find(params[:id])

    respond_to do |format|
      if @gethotel.update_attributes(params[:gethotel])
        format.html { redirect_to @gethotel, notice: 'Gethotel was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gethotel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gethotels/1
  # DELETE /gethotels/1.json
  def destroy
    @gethotel = Gethotel.find(params[:id])
    @gethotel.destroy

    respond_to do |format|
      format.html { redirect_to gethotels_url }
      format.json { head :no_content }
    end
  end
end

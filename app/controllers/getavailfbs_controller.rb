class GetavailfbsController < ApplicationController
  # GET /getavailfbs
  # GET /getavailfbs.json
  def index
    #@getavailfbs = Getavailfb.all

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @getavailfbs }
    #end
    
    
   # getavaires = Getavailfb.get_avail_fb
    p "getavailablefbresponse"
    #p getavaires
    p "getavailablefbresponse"
    
    
    
  end

  # GET /getavailfbs/1
  # GET /getavailfbs/1.json
  def show
    @getavailfb = Getavailfb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @getavailfb }
    end
  end

  # GET /getavailfbs/new
  # GET /getavailfbs/new.json
  def new
    #@getavailfb = Getavailfb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @getavailfb }
    end
  end

  # GET /getavailfbs/1/edit
  def edit
    @getavailfb = Getavailfb.find(params[:id])
  end

  # POST /getavailfbs
  # POST /getavailfbs.json
  def create
    getavailfb = Getavailfb.get_avail_fb(params)
    
    respond_to do |format|
      if  getavailfb.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice]= 'Getavailfb was successfully created.'
        format.html { redirect_to  :action=>:index }
        format.json { render json: @getavailfb, status: :created, location: @getavailfb }
      else
        flash[:notice] = getavailfb.body
        format.html { render action: "new" }
        format.json { render json: @getavailfb.errors, status: :unprocessable_entity }
      end 
    end
  end

  # PUT /getavailfbs/1
  # PUT /getavailfbs/1.json
  def update
    @getavailfb = Getavailfb.find(params[:id])

    respond_to do |format|
      if @getavailfb.update_attributes(params[:getavailfb])
        format.html { redirect_to @getavailfb, notice: 'Getavailfb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @getavailfb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getavailfbs/1
  # DELETE /getavailfbs/1.json
  def destroy
    @getavailfb = Getavailfb.find(params[:id])
    @getavailfb.destroy

    respond_to do |format|
      format.html { redirect_to getavailfbs_url }
      format.json { head :no_content }
    end
  end
end

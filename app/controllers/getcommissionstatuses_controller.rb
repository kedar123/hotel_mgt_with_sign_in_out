class GetcommissionstatusesController < ApplicationController
  # GET /getcommissionstatuses
  # GET /getcommissionstatuses.json
  def index
    p "the get commission response"
   # getcommresp = Getcommissionstatus.get_commission_status
   # p getcommresp
    p "the responseeeeee"

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @getcommissionstatuses }
    #end
  end

  # GET /getcommissionstatuses/1
  # GET /getcommissionstatuses/1.json
  def show
    @getcommissionstatus = Getcommissionstatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @getcommissionstatus }
    end
  end

  # GET /getcommissionstatuses/new
  # GET /getcommissionstatuses/new.json
  def new
    #@getcommissionstatus = Getcommissionstatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @getcommissionstatus }
    end
  end

  # GET /getcommissionstatuses/1/edit
  def edit
    @getcommissionstatus = Getcommissionstatus.find(params[:id])
  end

  # POST /getcommissionstatuses
  # POST /getcommissionstatuses.json
  def create
    getcommissionstatus = Getcommissionstatus.get_commission_status(params)

    respond_to do |format|
      if getcommissionstatus.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Getcommissionstatus was successfully created.'
        format.html { redirect_to :action=>'index'  }
        format.json { render json: @getcommissionstatus, status: :created, location: @getcommissionstatus }
      else
        flash[:notice] = getcommissionstatus.body
        format.html { render action: "new" }
        format.json { render json: @getcommissionstatus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /getcommissionstatuses/1
  # PUT /getcommissionstatuses/1.json
  def update
    @getcommissionstatus = Getcommissionstatus.find(params[:id])

    respond_to do |format|
      if @getcommissionstatus.update_attributes(params[:getcommissionstatus])
        format.html { redirect_to @getcommissionstatus, notice: 'Getcommissionstatus was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @getcommissionstatus.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getcommissionstatuses/1
  # DELETE /getcommissionstatuses/1.json
  def destroy
    @getcommissionstatus = Getcommissionstatus.find(params[:id])
    @getcommissionstatus.destroy

    respond_to do |format|
      format.html { redirect_to getcommissionstatuses_url }
      format.json { head :no_content }
    end
  end
end

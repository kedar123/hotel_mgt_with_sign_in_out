class GetratesController < ApplicationController
  # GET /getrates
  # GET /getrates.json
  def index
   # getrates = Getrate.get_rates

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @getrates }
    end
  end

  # GET /getrates/1
  # GET /getrates/1.json
  def show
    @getrate = Getrate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @getrate }
    end
  end

  # GET /getrates/new
  # GET /getrates/new.json
  def new
    #@getrate = Getrate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @getrate }
    end
  end

  # GET /getrates/1/edit
  def edit
    @getrate = Getrate.find(params[:id])
  end

  # POST /getrates
  # POST /getrates.json
  def create
    getrate = Getrate.get_rates(params)

    respond_to do |format|
      if getrate.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Getrate was successfully created.'
        format.html { redirect_to @getrate  }
        format.json { render json: @getrate, status: :created, location: @getrate }
      else
        flash[:notice] = getrate.body
        format.html { render action: "new" }
        format.json { render json: @getrate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /getrates/1
  # PUT /getrates/1.json
  def update
    @getrate = Getrate.find(params[:id])

    respond_to do |format|
      if @getrate.update_attributes(params[:getrate])
        format.html { redirect_to @getrate, notice: 'Getrate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @getrate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getrates/1
  # DELETE /getrates/1.json
  def destroy
    @getrate = Getrate.find(params[:id])
    @getrate.destroy

    respond_to do |format|
      format.html { redirect_to getrates_url }
      format.json { head :no_content }
    end
  end
end

class GetratesdbsController < ApplicationController
  # GET /getratesdbs
  # GET /getratesdbs.json
  def index
  #  getratesdbs = Getratesdb.get_rates_db

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @getratesdbs }
    end
  end

  # GET /getratesdbs/1
  # GET /getratesdbs/1.json
  def show
    @getratesdb = Getratesdb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @getratesdb }
    end
  end

  # GET /getratesdbs/new
  # GET /getratesdbs/new.json
  def new
    #@getratesdb = Getratesdb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @getratesdb }
    end
  end

  # GET /getratesdbs/1/edit
  def edit
    @getratesdb = Getratesdb.find(params[:id])
  end

  # POST /getratesdbs
  # POST /getratesdbs.json
  def create
    p "while creating"
    getratesdb = Getratesdb.get_rates_db(params)
    p "ssssssss"
    respond_to do |format|
      if getratesdb.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] =  'Getratesdb was successfully created.'
        format.html { redirect_to :action=>:index    }
        format.json { render json: @getratesdb, status: :created, location: @getratesdb }
      else
        flash[:notice] =  getratesdb.body
        format.html { render action: "new" }
        format.json { render json: @getratesdb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /getratesdbs/1
  # PUT /getratesdbs/1.json
  def update
    @getratesdb = Getratesdb.find(params[:id])

    respond_to do |format|
      if @getratesdb.update_attributes(params[:getratesdb])
        format.html { redirect_to @getratesdb, notice: 'Getratesdb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @getratesdb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getratesdbs/1
  # DELETE /getratesdbs/1.json
  def destroy
    @getratesdb = Getratesdb.find(params[:id])
    @getratesdb.destroy

    respond_to do |format|
      format.html { redirect_to getratesdbs_url }
      format.json { head :no_content }
    end
  end
end

class UpdateretesController < ApplicationController
  # GET /updateretes
  # GET /updateretes.json
  def index
   # @updateretes = Updaterete.update_rates

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @updateretes }
    end
  end

  # GET /updateretes/1
  # GET /updateretes/1.json
  def show
    @updaterete = Updaterete.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @updaterete }
    end
  end

  # GET /updateretes/new
  # GET /updateretes/new.json
  def new
   # @updaterete = Updaterete.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @updaterete }
    end
  end

  # GET /updateretes/1/edit
  def edit
    @updaterete = Updaterete.find(params[:id])
  end

  # POST /updateretes
  # POST /updateretes.json
  def create
    @updaterete = Updaterete.update_rates(params)
    respond_to do |format|
        if @updaterete.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
           flash[:notice] = 'Getrate was successfully created.'
           format.html { render :text=>"The Rates Were Properly Updated"  }
           format.json { render json: @updaterete, status: :created, location: @updaterete }
        else
           flash[:notice] = getrate.body
           format.html { render action: "new" }
           format.json { render json: @updaterete.errors, status: :unprocessable_entity }
        end
     end
  end

  # PUT /updateretes/1
  # PUT /updateretes/1.json
  def update
    @updaterete = Updaterete.find(params[:id])

    respond_to do |format|
      if @updaterete.update_attributes(params[:updaterete])
        format.html { redirect_to @updaterete, notice: 'Updaterete was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @updaterete.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /updateretes/1
  # DELETE /updateretes/1.json
  def destroy
    @updaterete = Updaterete.find(params[:id])
    @updaterete.destroy

    respond_to do |format|
      format.html { redirect_to updateretes_url }
      format.json { head :no_content }
    end
  end
end

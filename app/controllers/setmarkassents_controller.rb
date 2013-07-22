class SetmarkassentsController < ApplicationController
  # GET /setmarkassents
  # GET /setmarkassents.json
  def index
    #setmarkassents = Setmarkassent.set_mark_as_sent

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @setmarkassents }
    end
  end

  # GET /setmarkassents/1
  # GET /setmarkassents/1.json
  def show
    @setmarkassent = Setmarkassent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @setmarkassent }
    end
  end

  # GET /setmarkassents/new
  # GET /setmarkassents/new.json
  def new
    #@setmarkassent = Setmarkassent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @setmarkassent }
    end
  end

  # GET /setmarkassents/1/edit
  def edit
    @setmarkassent = Setmarkassent.find(params[:id])
  end

  # POST /setmarkassents
  # POST /setmarkassents.json
  def create
    @setmarkassent = Setmarkassent.set_mark_as_sent(params)

    respond_to do |format|
      if  @setmarkassent.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Setmarkassent was successfully created.'
        format.html { redirect_to :action=>:index    }
        format.json { render json: @setmarkassent, status: :created, location: @setmarkassent }
      else
        flash[:notice] = @setmarkassent.body
        format.html { render action: "new" }
        format.json { render json: @setmarkassent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /setmarkassents/1
  # PUT /setmarkassents/1.json
  def update
    @setmarkassent = Setmarkassent.find(params[:id])

    respond_to do |format|
      if @setmarkassent.update_attributes(params[:setmarkassent])
        format.html { redirect_to @setmarkassent, notice: 'Setmarkassent was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @setmarkassent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /setmarkassents/1
  # DELETE /setmarkassents/1.json
  def destroy
    @setmarkassent = Setmarkassent.find(params[:id])
    @setmarkassent.destroy

    respond_to do |format|
      format.html { redirect_to setmarkassents_url }
      format.json { head :no_content }
    end
  end
end

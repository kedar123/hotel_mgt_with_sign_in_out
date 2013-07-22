class GetnotificationmessagesController < ApplicationController
  # GET /getnotificationmessages
  # GET /getnotificationmessages.json
  def index
   # getnotificationmessages = Getnotificationmessage.get_notification_messages

     p "the getnotification message"
    # p getnotificationmessages
     p "noooooooooooooooo"
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @getnotificationmessages }
    end
  end

  # GET /getnotificationmessages/1
  # GET /getnotificationmessages/1.json
  def show
    @getnotificationmessage = Getnotificationmessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @getnotificationmessage }
    end
  end

  # GET /getnotificationmessages/new
  # GET /getnotificationmessages/new.json
  def new
     

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @getnotificationmessage }
    end
  end

  # GET /getnotificationmessages/1/edit
  def edit
    @getnotificationmessage = Getnotificationmessage.find(params[:id])
  end

  # POST /getnotificationmessages
  # POST /getnotificationmessages.json
  def create
    getnotificationmessage = Getnotificationmessage.get_notification_messages(params)

    respond_to do |format|
      if getnotificationmessage.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Getnotificationmessage was successfully created.'
        format.html { redirect_to  :action=>:index    }
        format.json { render json: @getnotificationmessage, status: :created, location: @getnotificationmessage }
      else
        
         flash[:notice] = getnotificationmessage.body
        format.html { render action: "new" }
        format.json { render json: @getnotificationmessage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /getnotificationmessages/1
  # PUT /getnotificationmessages/1.json
  def update
    @getnotificationmessage = Getnotificationmessage.find(params[:id])

    respond_to do |format|
      if @getnotificationmessage.update_attributes(params[:getnotificationmessage])
        format.html { redirect_to @getnotificationmessage, notice: 'Getnotificationmessage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @getnotificationmessage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getnotificationmessages/1
  # DELETE /getnotificationmessages/1.json
  def destroy
    @getnotificationmessage = Getnotificationmessage.find(params[:id])
    @getnotificationmessage.destroy

    respond_to do |format|
      format.html { redirect_to getnotificationmessages_url }
      format.json { head :no_content }
    end
  end
end
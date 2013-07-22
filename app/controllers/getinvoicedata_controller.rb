class GetinvoicedataController < ApplicationController
  # GET /getinvoicedata
  # GET /getinvoicedata.json
  def index
    @getinvoicedata = []#Getinvoicedatum.get_invoice_data
   
     p "get invoice data" 
    # p getinvoicedata
     p "and the get invoice data"
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @getinvoicedata }
    end
  end

  # GET /getinvoicedata/1
  # GET /getinvoicedata/1.json
  def show
    @getinvoicedatum = Getinvoicedatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @getinvoicedatum }
    end
  end

  # GET /getinvoicedata/new
  # GET /getinvoicedata/new.json
  def new
    #@getinvoicedatum = Getinvoicedatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @getinvoicedatum }
    end
  end

  # GET /getinvoicedata/1/edit
  def edit
    @getinvoicedatum = Getinvoicedatum.find(params[:id])
  end

  # POST /getinvoicedata
  # POST /getinvoicedata.json
  def create
    getinvoicedatum = Getinvoicedatum.get_invoice_data(params)

    respond_to do |format|
      if getinvoicedatum.body.include?("<boolean xmlns=\"http://www.reconline.com/\">true</boolean>")
        flash[:notice] = 'Getinvoicedatum was successfully created.'
        format.html { redirect_to :action=>:index   }
        format.json { render json: @getinvoicedatum, status: :created, location: @getinvoicedatum }
      else
        flash[:notice] =  getinvoicedatum.body
        
        format.html { render action: "new" }
        format.json { render json: @getinvoicedatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /getinvoicedata/1
  # PUT /getinvoicedata/1.json
  def update
    @getinvoicedatum = Getinvoicedatum.find(params[:id])

    respond_to do |format|
      if @getinvoicedatum.update_attributes(params[:getinvoicedatum])
        format.html { redirect_to @getinvoicedatum, notice: 'Getinvoicedatum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @getinvoicedatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /getinvoicedata/1
  # DELETE /getinvoicedata/1.json
  def destroy
    @getinvoicedatum = Getinvoicedatum.find(params[:id])
    @getinvoicedatum.destroy

    respond_to do |format|
      format.html { redirect_to getinvoicedata_url }
      format.json { head :no_content }
    end
  end
end

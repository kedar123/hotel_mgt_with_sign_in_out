class SetdsController < ApplicationController
  # GET /setds
  # GET /setds.json
  def index
    
  #res.partner name compulsory
  
    #resp = ResPartner.new
    #resp.name = 'name1'
    #resp.save
 #   logger.info "888888888888888888"
 #  acinv =  AccountInvoice.new
 #  resp = ResPartner.search([['name','=','name1']])[0]
 #  acinv.partner_id = resp
 #  acjn = AccountJournal.search([['name','=','Sales Journal']])[0]
 #  acinv.journal_id = acjn
 #  acid = AccountAccount.search([['name','=','Debtors']])[0]
 #  acinv.payment_term = 1
 #  acinv.account_id = acid
    
   
 #  logger.info acinv.save
    
    
 #   logger.info acinv
 #  acinvln = AccountInvoiceLine.new
 #  prd = ProductProduct.search([['name_template','=','Service']])[0]
 #  acinvln.product_id = prd
 #  acinvln.name = 'name1'
   
 #  acid = AccountAccount.search([['name','=','Product Sales']])[0]

 #  acinvln.account_id = acid
 #  acinvln.quantity = 5
 #  acinvln.price_unit = 110
 #  acinvln.invoice_id = acinv.id
 #   logger.info acinvln.save
 #  acinv =  AccountInvoice.find(acinv.id)
   
 #  acinv.call "action_date_assign" ,[acinv.id]
 #  acinv.call "action_move_create"  ,[acinv.id]
 #  acinv.call "action_number"   ,[acinv.id]
 #  acinv.call "invoice_validate"  ,[acinv.id]
 #  acinv.call "confirm_paid" ,[acinv.id]
    
 #       respart = ResPartner.search([["email","=", 'kedar.pathak@pragtech.co.in' ]])[0] 
 #       newres = HotelReservation.new
 #       newres.partner_id = respart
 #       newres.partner_order_id = respart
 #       newres.shop_id = 1
 #       newres.partner_invoice_id = respart
 #       newres.partner_shipping_id = respart
 #       newres.date_order = Date.today
 #       newres.pricelist_id = 1
 #       newres.printout_group_id = 1
        
      
 
 #       checkin =  "2014-02-23 00:00:00"
 
 #       newres.checkin = checkin
        #this checkout and checkin i will write more comment on it
 #        checkout = "2014-02-24 00:00:00"
 #       dcin = checkin.split(' ')
 #        newres.dummy = checkout
 #       doc_date = DateTime.new(dcin[0].split('-')[0].to_i,dcin[0].split('-')[1].to_i,dcin[0].split('-')[2].to_i ).ago  14.days 
 #       doc_date = Date.today if doc_date < Date.today
 #       newres.doc_date = doc_date
 #       newres.checkout = checkout
 #       newres.state = 'draft'
 #       newres.percentage = "10"
 #       newres.deposit_policy = "percentage"
 #       newres.deposit_cost1 = "0.00"
 #       newres.untaxed_amt = "0.00"
 #       newres.save  
 #       
        #newres.wkf_action("confirmed_reservation")
    sord = SaleOrder.new
    sord.partner_id = 6
    sord.date_order = '06/17/2013'
    sord.pricelist_id = 1
    sord.partner_invoice_id = 6
    sord.partner_shipping_id = 6
    sord.save
    soln = SaleOrderLine.new
    soln.product_id = 1
    soln.product_uom_qty = 5
    soln.price_unit = 6
    soln.name =  'Service'
    soln.order_id = sord.id
    soln.save
    sord.call "action_button_confirm",[sord.id]
    sadvpinv = SaleAdvancePaymentInv.new
    sadvpinv.advance_payment_method = 'all'
    sadvpinv.save
    sadvpinv.call "create_invoices" ,  [sadvpinv.id] , {:active_ids => [sord.id]}
    logger.info sord.call "action_view_invoice",[sord.id]
    logger.info "ok so ultimetly this is get called"
    acinv = AccountInvoice.search([['origin','=',sord.name ]])[0]
    acinv = AccountInvoice.find(acinv)
    ipcret = acinv.call 'invoice_pay_customer' , [acinv.id]
    
    logger.info "some invoicesssssssssssssssssssssssss"
 
    acv = AccountVoucher.new 
    acv.type = "receipt"
    acv.partner_id = ipcret['context']['default_partner_id']
    acv.save
    
    
    
    
    
    
  end

  # GET /setds/1
  # GET /setds/1.json
  def show
    @setd = Setd.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @setd }
    end
  end

  # GET /setds/new
  # GET /setds/new.json
  def new
    @setd = Setd.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @setd }
    end
  end

  # GET /setds/1/edit
  def edit
    @setd = Setd.find(params[:id])
  end

  # POST /setds
  # POST /setds.json
  def create
    @setd = Setd.new(params[:setd])

    respond_to do |format|
      if @setd.save
        format.html { redirect_to @setd, notice: 'Setd was successfully created.' }
        format.json { render json: @setd, status: :created, location: @setd }
      else
        format.html { render action: "new" }
        format.json { render json: @setd.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /setds/1
  # PUT /setds/1.json
  def update
    @setd = Setd.find(params[:id])

    respond_to do |format|
      if @setd.update_attributes(params[:setd])
        format.html { redirect_to @setd, notice: 'Setd was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @setd.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /setds/1
  # DELETE /setds/1.json
  def destroy
    @setd = Setd.find(params[:id])
    @setd.destroy

    respond_to do |format|
      format.html { redirect_to setds_url }
      format.json { head :no_content }
    end
  end
end

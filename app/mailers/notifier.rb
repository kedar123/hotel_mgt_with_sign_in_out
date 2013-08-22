class Notifier < ActionMailer::Base
 default from: 'no-reply@example.com',
          return_path: 'system@example.com'
  def welcome(emailaddress,username,emailid,password)
     p "dddddddddddddddddddddddddd"
     p emailaddress
     @username = username
     @emailid = emailid
     @password = password
     
    mail(to: emailaddress)
  end
  
  def forgot_password(password,username,emailaddress)
    @password = password
    @username = username
    mail(to: emailaddress)
  end
  
  def complete_reservation(emailaddr, message)
    @message = message
    mail(to: emailaddr)
  end
        
  def paypal_error_message(partner_name,checkindate,checkoutdate,roomname,amount,converted_amt,paypal_transaction_id,currencyname)
    @partner_name = partner_name
    @checkindate = checkindate
    @checkoutdate = checkoutdate
    @roomname = roomname
    @amount = amount
    @converted_amt = converted_amt
    @paypal_transaction_id = paypal_transaction_id
    @currencyname = currencyname  
   
    mail(to:  "parikshit.bapat@pragtech.co.in", subject: 'Booking Failure Message')
  end
  
  
end

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
  
  
end

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(function() {		
//  //$("[id$='_possesion_date']").datepicker({dateFormat :'dd-mm-yy', changeMonth: true, changeYear:true});
//  //$("[id$='_start_date']").datepicker({dateFormat :'dd-mm-yy', changeMonth: true, changeYear:true});
//  //$("[id$='_end_date']").datepicker({dateFormat :'dd-mm-yy', changeMonth: true, changeYear:true});  
//  //$("[id='+_start_date+']").datepicker({dateFormat :'dd-mm-yy', changeMonth: true, changeYear:true});
//  //$("[id*='_end_date']").datepicker({dateFormat :'dd-mm-yy', changeMonth: true, changeYear:true}); 
//  $("#checkout").datepicker({dateFormat :'yy-mm-dd', changeMonth: true, changeYear:true,firstDay: 1}); 
//  $("#checkin").datepicker({dateFormat :'yy-mm-dd', changeMonth: true, changeYear:true,firstDay: 1}); 
  



});


function check_date(){
     datevalid = true;
     if($("#checkin").datetimepicker("getDate") === null) {
         alert("Select check-in date");
         datevalid = false;    
      }
    if($("#checkout").datetimepicker("getDate") === null) {
        alert("Select your departure date");
        datevalid = false;
    }
     var checkout= new Date($('#checkout').val());
     var checkin = new Date($('#checkin').val());
    if(checkout<checkin)
   {
     alert("Checkin date should be smaller than Checkout Date");
     datevalid = false;
   }
    year = new Date().getFullYear();
    month = new Date().getMonth();
    day = new Date().getDate();
    var today = new Date(year,month,day);;
   if(  checkin < today)
   {
     alert("It should not be less than the current datol");
     datevalid = false;
   }
   return datevalid;
}

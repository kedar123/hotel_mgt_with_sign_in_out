function check_date_gds(){
      datevalid = true;
     if($("#start_date").datepicker("getDate") === null) {
         alert("Select check-in date");
         datevalid = false;    
      }
    if($("#end_date").datepicker("getDate") === null) {
        alert("Select your departure date");
        datevalid = false;
    }
     var checkout = new Date($('#end_date').val().split('/')[2] +"-"+ $('#end_date').val().split('/')[1]+"-"+$('#end_date').val().split('/')[0]);
     var checkin = new Date($('#start_date').val().split('/')[2]+"-"+$('#start_date').val().split('/')[1]+"-"+ $('#start_date').val().split('/')[0]);
     
    if(checkout < checkin)
   {
     alert("Checkin date should be smaller than Checkout Date");
     datevalid = false;
   }
    year = new Date().getFullYear();
    month = new Date().getMonth();
    day = new Date().getDate();
    var today = new Date(year,month,day);
    
    
     if(  checkin < today)
   {
     alert("It should not be less than the current datol");
     datevalid = false;
   }
   return datevalid;
}


function check_room_type(){
  var selectedvalue = $("#room_type").val();
    if(selectedvalue == "")
     {
      alert('Please Select DBL OR KING');   
      return false; 
     }
 }
 
 function check_company_tag(){
      var selectedvalue = $("#company_id").val();
     if(selectedvalue == "")
     {
      alert('Please Select One Company');   
      return false; 
     }
  }
  

function check_shop_tag(){
      var selectedvalue = $("#shop_id").val();
         if(selectedvalue == "")
         {
          alert('Please Select One Shop');   
          return false; 
         }
  }



function  get_available_room_type_check_box(){
    var atLeastOneIsChecked = $('input:checkbox').is(':checked');
    if(atLeastOneIsChecked)
        {
            
        }
        else
            {
    alert("Please Select At Least One Room To Add" );
    return false;            
            }
     
         
    
}

function check_delete_room(){
  
 if ($("#deleteroomc").val()=="1")
     {
  var atLeastOneIsChecked = $('input:checkbox').is(':checked');
    if(atLeastOneIsChecked)
        {
         }
        else
            {
    alert("Please Select At Least One Room To Delete" );
    return false;            
            }
            
     }
}



function check_conf_list_check_box(){
    
  
if ($("#deleteroom").val()=="1")
     {
       var atLeastOneIsChecked = $('input:checkbox').is(':checked');
          if(atLeastOneIsChecked)
         {
         }
        else
            {
    alert("Please Select At Least One Room" );
    return false;            
            }
            
     }
 
}


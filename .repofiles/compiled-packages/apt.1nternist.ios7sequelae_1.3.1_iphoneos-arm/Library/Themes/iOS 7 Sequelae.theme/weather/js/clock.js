function updateClock ( )
{



//var TwentyFourHourClock = $.cookie("24hrcookie"); 
var TwentyFourHourClock = "false"; 

  var currentTime = new Date ( );
  var currentHours = currentTime.getHours ( );
  var currentMinutes = currentTime.getMinutes ( );
  var currentSeconds = currentTime.getSeconds ( );

    currentHours = ( currentHours < 10 ? "0" : "" ) + currentHours;
    currentHours = ( currentHours == 0 ) ? 12 : currentHours;
    currentMinutes = ( currentMinutes < 10 ? "0" : "" ) + currentMinutes;

if (TwentyFourHourClock == "true"){

}

  else{
      var timeOfDay = ( currentHours < 12 ) ? " " : " "
  currentHours = ( currentHours > 12 ) ? currentHours - 12 : currentHours;
  currentHours = ( currentHours == 0 ) ? 12 : currentHours;
  }

  /*for leading zero on non 24hr delete this line*
  currentHours = ( currentHours < 10 ? "0" : "" ) + currentHours;

/*-----------------------------------------------------------------------------------------------------------------------------------------------*/

  // Compose the string for display
  var currentTimeString = currentHours + " " + ":";
  var currentTimeString1 = currentMinutes;

  // Update the time display
document.getElementById("hours").firstChild.nodeValue = currentTimeString;
document.getElementById("mins").firstChild.nodeValue = currentTimeString1;
}
function init2 ( )
{
  timeDisplay = document.createTextNode ( "" );
  document.getElementById("ampm").appendChild ( timeDisplay );
}

function amPm ( )
{
  var currentTime = new Date ( );
  var currentHours = currentTime.getHours ( );


/*---------------------------------------------------------------------------------------------------------------------------------AM PM Edit------*/

/* Remove the /* from under this line to display am or pm after the 12 hours clock */  /* NEW!! */

  // Choose either "AM" or "PM" as appropriate
  var timeOfDay = ( currentHours < 12 ) ? "AM" : "PM";
  // Convert the hours component to 12-hour format if needed
  currentHours = ( currentHours > 12 ) ? currentHours - 12 : currentHours;
  // Convert an hours component of "0" to "12"
  currentHours = ( currentHours == 0 ) ? 12 : currentHours;
  // Compose the string for display
  var currentTimeString = timeOfDay;
  // Update the time display
document.getElementById("ampm").firstChild.nodeValue = currentTimeString;
}
function calendarDate ( )
{
  var this_date_name_array = new Array("00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31")
  var this_weekday_name_array = new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
  var this_month_name_array = new Array("January","February","March","April","May","June","July","August","September","October","November","December")  //predefine month names

  var this_date_timestamp = new Date()
  var this_weekday = this_date_timestamp.getDay()
  var this_date = this_date_timestamp.getDate()
  var this_month = this_date_timestamp.getMonth()
  var this_year = this_date_timestamp.getYear()

if (this_year < 1000)
    this_year+= 1900;
if (this_year==101)
    this_year=2001;

document.getElementById("date").firstChild.nodeValue = this_date_name_array[this_date] //concat long date string
document.getElementById("month").firstChild.nodeValue = this_month_name_array[this_month] +" "  //concat long date string
}
// -->

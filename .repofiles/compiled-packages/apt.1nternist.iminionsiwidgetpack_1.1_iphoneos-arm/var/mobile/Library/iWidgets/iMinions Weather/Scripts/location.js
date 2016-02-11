//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
// Author : Vivek Thakur
// Date : 25 Feb 2012
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
// Modified by Dacal.
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------

var prevlatitude = "";
var prevlongitude = "";
var city = "";
var textLat;
var textLong;

function UpdateLocation() {
refreshLocationTimer = setTimeout(UpdateLocation, 20*1000);
jQuery.get('file:///private/var/mobile/Documents/myLocation.txt', function(appdata) {
//jQuery.get('myLocation.txt', function(appdata) {
var myvar = appdata;
var substr = appdata.split('\n');
var templatitude=(substr[0]).split('=');
var templongitude=(substr[1]).split('=');
var latitude = $.trim(templatitude[1]);
var longitude = $.trim(templongitude[1]);

if ((prevlatitude != latitude) || (prevlongitude != longitude)) {
	if (latitude < 0) { textLat = Math.round(latitude*100)/100 + "\u00B0" + "S"; }
	else if (latitude > 0){ textLat = Math.round(latitude*100)/100 + "\u00B0" + "N"; }
	else { textLat = Math.round(latitude*100)/100 + "\u00B0"; }
	if (longitude < 0) { textLong = Math.round(longitude*100)/100 + "\u00B0" + "W"; }
	else if (longitude > 0) { textLong = Math.round(longitude*100)/100 + "\u00B0" + "E"; }
	else { textLong = Math.round(longitude*100)/100 + "\u00B0"; }
	prevlatitude = latitude;
	prevlongitude = longitude;

	// GET WOEID FOR THE NEW LOCATION
	var url = 'http://query.yahooapis.com/v1/public/yql?q=select * from geo.placefinder where text="'+latitude+','+longitude+'" and gflags="R"&format=json';
	$.getJSON(url, function(data) {
	found = data.query.count; // Check if coordinates return a valid localization.
	if ( found == 1) {
		var woeid = data.query.results.Result.woeid;
		city = data.query.results.Result.city;
		neighborhood = data.query.results.Result.neighborhood;
		county = data.query.results.Result.county;
		
		if (UseNeighborhood == true) {
			if (neighborhood != null) { city = neighborhood; } else { city = county; }
		}
		
		// GET OLD LOCALE FROM WOEID
		var url = "http://weather.yahooapis.com/forecastrss?w="+woeid+"&u=f";
		$.get(url, function(data) {
		title = $(data).find('title').text(); // Check if a city is found.
		if (title != "Yahoo! Weather - ErrorCity not found") {
			gps = true;
			zip = $(data).find('guid').text().split('_')[0];
			if ( ((UseCityGPS == false) && (UseNeighborhood == false)) || (city == null) ) { city = $(data).find('location').attr('city'); }
			TextColor = "TextColorGrey";
			weatherRefresherTemp(zip); // Refresh weather as specified in Config.js.
		} else {
			if ( xmldata == false ) {  // Back to locale, but keep the 20s refresh for GPS localization.
			gps = false;
			TextColor = "TextColorGrey";
			validateWeatherLocation(escape(locale).replace(/^%u/g, "%"), setPostal);
			} else {
			gps = true;
			TextColor = "TextColorRed";
			weatherRefresherTemp(zip); 	// Keep the latest valid zip to update the weather.
			}
		}
		}).error(function() {
		if (xmldata == false) {
		dealWithWeather ({error:true});
		} else {
		document.getElementById("coordinates").className = "TextColorRed";
		document.getElementById("coordinates").innerHTML = "[Offline]";
		}
		});
	} else {
		if ( xmldata == false) { // No data. Keep weather or back to locale, maintain the 20s refresh for GPS localization.
		gps = false;
		TextColor = "TextColorGrey";
		validateWeatherLocation(escape(locale).replace(/^%u/g, "%"), setPostal);
		} else {
		document.getElementById("coordinates").className = "TextColorRed";
		document.getElementById("coordinates").innerHTML = "[Offline]";
		}
	}
	}).error(function() {
		if (xmldata == false) {
		dealWithWeather ({error:true});
		} else {
		document.getElementById("coordinates").className = "TextColorRed"; 
		document.getElementById("coordinates").innerHTML = "[Offline]";
		}
	}); 
}
}).error(function() {
clearTimeout(refreshLocationTimer); // No myLocation.txt file, stop GPS mode.
gps = false;
TextColor = "TextColorGrey";
validateWeatherLocation(escape(locale).replace(/^%u/g, "%"), setPostal);
});
}

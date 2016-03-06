var updateWeatherEvery = updateInterval*60*1000;
var xmldata = false;
var postal;
var filename = "";
var where = "";
var whereOld = "";
var refreshLocationTimer;
var updateTimer = 0;
var zip;
var TextColor = "TextColorGrey";

switch (lang) {
case "fr":
	var days = ["Dim","Lun","Mar","Mer","Jeu","Ven","Sam"];
	var months=['Jan','Fev','Mar','Avr','Mai','Jui','Jui','Aou','Sep','Oct','Nov','Dec'];
break;
case "de":
	var days = ["Son","Mon","Die","Mit","Don","Fre","Sam"];
	var months=["Januar","Februar","Marz","April","Mai","Juni","Juli","August","September ","Oktober","November","Dezember"];	    
break;
case "sp":
	var days = ["Dom","Lun","Mar","Mie","Jue","Vie","Sab"];
	var months=['Enero','Febrero','Marzo','Abril','Mayo','Junio','Juliot','Agosto','Septiembre','Octubre','Novimbre','Decimbre'];
break;
case "it":
	var days = ["Dom","Lun","Mar","Mer","Gio","Ven","Sab"];
	var months=['Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno','Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'];
break;
default: 
	var days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
	var months=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
break;
}

function updateClock() {
var currentTime = new Date();
var currentHours = currentTime.getHours();
var currentMinutes = currentTime.getMinutes() < 10 ? '0' + currentTime.getMinutes() : currentTime.getMinutes();
var currentSeconds = currentTime.getSeconds() < 10 ? '0' + currentTime.getSeconds() : currentTime.getSeconds();
var currentDate = currentTime.getDate() < 10 ? '0' + currentTime.getDate() : currentTime.getDate();
var currentYear = currentTime.getFullYear();
timeOfDay = ( currentHours < 12 ) ? "AM" : "PM";
	
if (ampm == false) {
	timeOfDay = "";
	currentHours = ( currentHours < 10 ? "0" : "" ) + currentHours;
	currentTimeString = currentHours + ":" + currentMinutes;
	} else {
	currentHours = ( currentHours > 12 ) ? currentHours - 12 : currentHours;
	currentHours = ( currentHours == 0 ) ? 12 : currentHours;
	currentTimeString = currentHours + ":" + currentMinutes;
}

document.getElementById("hour").innerHTML = currentHours;
document.getElementById("minute").innerHTML = currentMinutes;
document.getElementById("ampm").innerHTML = timeOfDay;
document.getElementById("second").innerHTML = currentSeconds;
document.getElementById("year").innerHTML = currentYear;

if (lang == "am") {
	document.getElementById("weekday").innerHTML = days[currentTime.getDay()] + ",";
	document.getElementById("month").innerHTML = months[currentTime.getMonth()] ;
	document.getElementById("date").innerHTML = currentDate;
	} else {
	document.getElementById("weekday").innerHTML = days[currentTime.getDay()] + ",";
	document.getElementById("month").innerHTML = currentDate; // DONT WORRY ! IT'S NORMAL
	document.getElementById("date").innerHTML =  months[currentTime.getMonth()];
	}

if (currentTime.getTime() - updateTimer >= updateWeatherEvery) {
	if (updateTimer == 0) {
		if (gps == true) { UpdateLocation(); } else { validateWeatherLocation(escape(locale).replace(/^%u/g, "%"), setPostal); }
		} else {
		weatherRefresherTemp(zip);
		}
	updateTimer = currentTime.getTime();
	}

}
 
function init(){

document.getElementById("city").className= TextColor;
document.getElementById("city").innerHTML="Loading...";

if (SecDisplay == false) { document.getElementById("second").style.display='none';}

updateClock();
setInterval(updateClock, 1000);

}




function setPostal(obj){
	if (obj.error == false){
		if(obj.cities.length > 0) {
			postal = escape(obj.cities[0].zip).replace(/^%u/g, "%")
			convertWoeid();
			}
			else
			{
			document.getElementById("city").innerHTML="Locale ?!";
			}
		}
		else
		{
		document.getElementById("city").innerHTML="Locale ?!";
		setTimeout('validateWeatherLocation(escape(locale).replace(/^%u/g, "%"), setPostal)', Math.round(1000*60*5));
		}
}

function weatherRefresherTemp(zip){
	fetchWeatherData(dealWithWeather, zip);
}

function validateWeatherLocation (location, callback) {
	var obj = {error:false, errorString:null, cities: new Array};
	obj.cities[0] = {zip: location};
	callback (obj);
}

function dealWithWeather(obj){
	if (obj.error == false){
		document.getElementById("city").className= TextColor;
		document.getElementById("city").innerHTML= obj.city;
		document.getElementById("desc").innerHTML = obj.description;
		document.getElementById("temp").innerHTML = obj.temp + "\u00B0";
		document.getElementById("hightemp").innerHTML = "H: " + obj.todayhigh + "\u00B0";

		document.getElementById("lowtemp").innerHTML = "L: " + obj.todaylow  + "\u00B0";

		if ( gps == true) {
		document.getElementById("coordinates").className = "TextColorGrey";
		document.getElementById("coordinates").innerHTML = " [" + textLat + " " + textLong + "]";
		} else {
		document.getElementById("coordinates").innerHTML = " ";
		}

		switch (lang) {
		case "fr":
			translatedesc=obj.description.toLowerCase();
			if (translatedesc=='sunny') { document.getElementById("desc").innerHTML='Ensoleill&eacute;'; }
			if (translatedesc=='drizzle') { document.getElementById("desc").innerHTML='Bruine'; }
			if (translatedesc=='heavy snow') { document.getElementById("desc").innerHTML='Fortes chutes de neige'; }
			if (translatedesc=='heavy rain') { document.getElementById("desc").innerHTML='Fortes averses'; }
			if (translatedesc=='rain and snow') { document.getElementById("desc").innerHTML='Pluie et neige'; }
			if (translatedesc=='mixed rain and snow') { document.getElementById("desc").innerHTML='Pluie et neige m&eacute;l&eacute;es'; }
			if (translatedesc=='fair') { document.getElementById("desc").innerHTML='Ciel d&eacute;gag&eacute;';    }
			if (translatedesc=='mostly sunny') { document.getElementById("desc").innerHTML='Quelques nuages';	  }
			if (translatedesc=='partly sunny') { document.getElementById("desc").innerHTML='Partiellement nuageux';   }
			if (translatedesc=='intermittent clouds') { document.getElementById("desc").innerHTML='Nuages &eacute;parses';	 }
			if (translatedesc=='hazy sunshine') { document.getElementById("desc").innerHTML='L&eacute;g&egrave;rement voil&eacute;';	}
			if (translatedesc=='haze') { document.getElementById("desc").innerHTML='Brume'; }
			if (translatedesc=='mostly cloudy') { document.getElementById("desc").innerHTML='Tr&egrave;s nuageux';	 }
			if (translatedesc=='cloudy') { document.getElementById("desc").innerHTML='Nuageux';    }
			if (translatedesc=='fog') { document.getElementById("desc").innerHTML='Brouillard';	  }
			if (translatedesc=='showers') { document.getElementById("desc").innerHTML='Averses';	}
			if (translatedesc=='partly sunny with showers') { document.getElementById("desc").innerHTML='Soleil et averses';    }
			if (translatedesc=='thunderstorms') { document.getElementById("desc").innerHTML='Orages';    }
			if (translatedesc=='thunderstorm') { document.getElementById("desc").innerHTML='Orage';    }
			if (translatedesc=='mostly cloudy with thunder showers') { document.getElementById("desc").innerHTML='Tr&egrave;s nuageux et fortes averses';	  }
			if (translatedesc=='partly sunny with thunder showers') { document.getElementById("desc").innerHTML='Soleil et fortes averses';    }
			if (translatedesc=='light rain') { document.getElementById("desc").innerHTML='L&eacute;g&egrave;re pluie';	  }
			if (translatedesc=='rain') { document.getElementById("desc").innerHTML='Pluie';    }
			if (translatedesc=='flurries') { document.getElementById("desc").innerHTML='Averses de neige';	}
			if (translatedesc=='mostly cloudy with flurries') { document.getElementById("desc").innerHTML='Tr&egrave;s nuageux avec neige';   }
			if (translatedesc=='partly sunny with flurries') { document.getElementById("desc").innerHTML='Soleil et averses de neige';    }
			if (translatedesc=='snow flurries') { document.getElementById("desc").innerHTML='Averses de neige';    }
			if (translatedesc=='snow showers') { document.getElementById("desc").innerHTML='Averses de neige';    }
			if (translatedesc=='snow') { document.getElementById("desc").innerHTML='Neige';    }
			if (translatedesc=='mostly cloudy with snow') { document.getElementById("desc").innerHTML='Tr&egrave;s nuageux et neige';    }
			if (translatedesc=='ice') { document.getElementById("desc").innerHTML='Glace';	}
			if (translatedesc=='sleet') { document.getElementById("desc").innerHTML='Verglas';    }
			if (translatedesc=='freezing rain') { document.getElementById("desc").innerHTML='Pluie vergla&ccedil;ante';	 }
			if (translatedesc=='rain and snow mixed') { document.getElementById("desc").innerHTML='Pluie et neige m&eacute;l&eacute;es';	}
			if (translatedesc=='hot') { document.getElementById("desc").innerHTML='Chaud';	  }
			if (translatedesc=='cold') { document.getElementById("desc").innerHTML='Froid';   }
			if (translatedesc=='windy') { document.getElementById("desc").innerHTML='Vent';    }
			if (translatedesc=='clear') { document.getElementById("desc").innerHTML='Clair';    }
			if (translatedesc=='mostly clear') { document.getElementById("desc").innerHTML='Tr&egrave;s clair';	}
			if (translatedesc=='partly cloudy') { document.getElementById("desc").innerHTML='Partiellement nuageux';	 }
			if (translatedesc=='hazy') { document.getElementById("desc").innerHTML='Brume';    }
			if (translatedesc=='partly cloudy with showers') { document.getElementById("desc").innerHTML='Partiellement nuageux et averses';	}
			if (translatedesc=='mostly cloudy with showers') { document.getElementById("desc").innerHTML='Tr&egrave;s nuageux et averses';	  }
			if (translatedesc=='party cloudy with thunder showers') { document.getElementById("desc").innerHTML='Partiellement nuageux et fortes averses';	 }
			if (translatedesc=='foggy') { document.getElementById("desc").innerHTML='Brouillard';	 }
			if (translatedesc=='light snow') { document.getElementById("desc").innerHTML='Flocons de neige'; }
			if (translatedesc=='light snow showers') { document.getElementById("desc").innerHTML='L&eacute;g&egrave;res chutes de neige'; } 
			if (translatedesc=='rain shower') { document.getElementById("desc").innerHTML='Averses';    }
			if (translatedesc=='light drizzle') { document.getElementById("desc").innerHTML='L&eacute;g&egrave;re bruine';	  }
			if (translatedesc=='mixed rain and sleet') { document.getElementById("desc").innerHTML='Pluie et verglas';    }
			if (translatedesc=='mixed snow and sleet') { document.getElementById("desc").innerHTML='Neige et verglas';    }
			if (translatedesc=='severe thunderstorms') { document.getElementById("desc").innerHTML='Gros orages';	 }
			if (translatedesc=='hurricane') { document.getElementById("desc").innerHTML='Ouragan';	  }
			if (translatedesc=='tropical storm') { document.getElementById("desc").innerHTML='Orage tropical';    }
			if (translatedesc=='tornado') { document.getElementById("desc").innerHTML='Tornade';	}
			if (translatedesc=='freezing drizzle') { document.getElementById("desc").innerHTML='Buine vergla&ccedil;ante';	  }
			if (translatedesc=='blowing snow') { document.getElementById("desc").innerHTML='Rafales de neige'; }
			if (translatedesc=='hail') { document.getElementById("desc").innerHTML='Gr&ecirc;le'; }
			if (translatedesc=='dust') { document.getElementById("desc").innerHTML='Poussi&eacute;reux';	}
			if (translatedesc=='somky') { document.getElementById("desc").innerHTML='Brumeux';    }
			if (translatedesc=='blustery') { document.getElementById("desc").innerHTML='Temp&ecirc;te';    }
			if (translatedesc=='mixed rain and hail') { document.getElementById("desc").innerHTML='Pluie et Gr&ecirc;le m&eacute;l&eacute;es';    }
			if (translatedesc=='isolated thunderstorms') { document.getElementById("desc").innerHTML='Orages isol&eacute;s';    }
			if (translatedesc=='isolated thundershowers') { document.getElementById("desc").innerHTML='Averses isol&eacute;s';    }
			if (translatedesc=='scattered thunderstorms') { document.getElementById("desc").innerHTML='Orages &eacute;parses';    }
			if (translatedesc=='scattered showers') { document.getElementById("desc").innerHTML='Averses &eacute;parses';	 }
			if (translatedesc=='scattered snow showers') { document.getElementById("desc").innerHTML='Chutes de neige &eacute;parses';    }
			if (translatedesc=='light rain with thunder') { document.getElementById("desc").innerHTML='Pluie l&eacute;g&egrave;re et &eacute;clairs';    }
			if (translatedesc=='not available') { document.getElementById("desc").innerHTML='Non disponible';    }
			if (translatedesc=='drifting snow/windy') { document.getElementById("desc").innerHTML='Neige poudreuse et vent';    }
			if (translatedesc=='light rain shower') { document.getElementById("desc").innerHTML='L&eacute;g&egrave;re averse'; }
			if (translatedesc=='thunder') { document.getElementById("desc").innerHTML='Tonnerre'; }
			if (translatedesc=='mostly cloudy/windy') { document.getElementById("desc").innerHTML='Tr&egrave;s nuageux et vent'; }
			if (translatedesc=='sandstorm') { document.getElementById("desc").innerHTML='Temp&ecirc;te de sable'; }
			if (translatedesc=='squalls/windy') { document.getElementById("desc").innerHTML='Rafales de vent'; }
			if (translatedesc=='sand') { document.getElementById("desc").innerHTML='Sable'; }
			if (translatedesc=='sandstorm/windy') { document.getElementById("desc").innerHTML='Temp&ecirc;te de sable et vent'; }
			if (translatedesc=='squalls') { document.getElementById("desc").innerHTML='Rafales'; }
		break;
		case "de":
			translatedesc=obj.description.toLowerCase();
			if (translatedesc=='tornado') { document.getElementById("desc").innerHTML='Tornado!'; }
			if (translatedesc=='tropical storm') { document.getElementById("desc").innerHTML='Tropischer Sturm'; }
			if (translatedesc=='hurricane') { document.getElementById("desc").innerHTML='Wirbelsturm'; }
			if (translatedesc=='severe thunderstorms') { document.getElementById("desc").innerHTML='Schwere Gewitter'; }
			if (translatedesc=='thunderstorms') { document.getElementById("desc").innerHTML='Gewitter'; }
			if (translatedesc=='mixed rain and snow') { document.getElementById("desc").innerHTML='Regen und Schnee'; }
			if (translatedesc=='mixed rain and sleet') { document.getElementById("desc").innerHTML='Graupelschauer'; }
			if (translatedesc=='mixed snow and sleet') { document.getElementById("desc").innerHTML='Schneeregen'; }
			if (translatedesc=='freezing drizzle') { document.getElementById("desc").innerHTML='Gefrierender Nieselregen'; }
			if (translatedesc=='drizzle') { document.getElementById("desc").innerHTML='Nieselregen'; }
			if (translatedesc=='freezing rain') { document.getElementById("desc").innerHTML='Gefrierender Regen'; }
			if (translatedesc=='showers') { document.getElementById("desc").innerHTML='Schauer'; }
			if (translatedesc=='snow flurries') { document.getElementById("desc").innerHTML='Schneegest&ouml;ber'; }
			if (translatedesc=='light snow showers') { document.getElementById("desc").innerHTML='Leichte Schneeschauer'; }
			if (translatedesc=='light snow grains') { document.getElementById("desc").innerHTML='Leichte Schneeschauer'; }
			if (translatedesc=='blowing snow') { document.getElementById("desc").innerHTML='Schneetreiben'; }
			if (translatedesc=='snow') { document.getElementById("desc").innerHTML='Schnee'; }
			if (translatedesc=='hail') { document.getElementById("desc").innerHTML='Hagel'; }
			if (translatedesc=='sleet') { document.getElementById("desc").innerHTML='Schneeregen'; }
			if (translatedesc=='dust') { document.getElementById("desc").innerHTML='Staubig'; }
			if (translatedesc=='foggy') { document.getElementById("desc").innerHTML='Nebelig'; }
			if (translatedesc=='haze') { document.getElementById("desc").innerHTML='Dunstschleier'; }
			if (translatedesc=='smoky') { document.getElementById("desc").innerHTML='Dunstig'; }
			if (translatedesc=='blustery') { document.getElementById("desc").innerHTML='St&uuml;rmisch'; }
			if (translatedesc=='windy') { document.getElementById("desc").innerHTML='Windig'; }
			if (translatedesc=='cold') { document.getElementById("desc").innerHTML='Kalt'; }
			if (translatedesc=='cloudy') { document.getElementById("desc").innerHTML='Bew&ouml;lkt'; }
			if (translatedesc=='mostly cloudy') { document.getElementById("desc").innerHTML='Meist Bew&ouml;lkt'; }
			if (translatedesc=='partly cloudy') { document.getElementById("desc").innerHTML='Teilweise Bew&ouml;lkt'; }
			if (translatedesc=='clear') { document.getElementById("desc").innerHTML='Klar'; }
			if (translatedesc=='sunny') { document.getElementById("desc").innerHTML='Sonnig'; }
			if (translatedesc=='fair') { document.getElementById("desc").innerHTML='Heiter'; }
			if (translatedesc=='mixed rain and hail') { document.getElementById("desc").innerHTML='Regen und Hagel'; }
			if (translatedesc=='hot') { document.getElementById("desc").innerHTML='Heiss'; }
			if (translatedesc=='isolated thunderstorms') { document.getElementById("desc").innerHTML='&Ouml;rtliche Gewitter'; }
			if (translatedesc=='scattered thunderstorms') { document.getElementById("desc").innerHTML='Vereinzelte Gewitter'; }
			if (translatedesc=='scattered showers') { document.getElementById("desc").innerHTML='Vereinzelte Schauer'; }
			if (translatedesc=='heavy snow') { document.getElementById("desc").innerHTML='Starker Schneefall'; }
			if (translatedesc=='scattered snow showers') { document.getElementById("desc").innerHTML='Vereinzelte Schneeschauer'; }
			if (translatedesc=='partly cloudy') { document.getElementById("desc").innerHTML='Teilweise Bew&ouml;lkt'; }
			if (translatedesc=='thundershowers') { document.getElementById("desc").innerHTML='Gewitter'; }
			if (translatedesc=='snow showers') { document.getElementById("desc").innerHTML='Scheeschauer'; }
			if (translatedesc=='isolated thundershowers') { document.getElementById("desc").innerHTML='Ouml;rtliche Gewitterschauer'; }
			if (translatedesc=='light rain shower') { document.getElementById("desc").innerHTML='Leichte Regenschauer'; }
			if (translatedesc=='not available') { document.getElementById("desc").innerHTML='nicht verfuegbar'; }
			if (translatedesc=='showers in the vicinity') { document.getElementById("desc").innerHTML='Schauer'; }
			if (translatedesc=='partly sunny') { document.getElementById("desc").innerHTML='Teilweise Sonnig'; }
			if (translatedesc=='ground fog') { document.getElementById("desc").innerHTML='Bodennebel'; }
			if (translatedesc=='light drizzle') { document.getElementById("desc").innerHTML='Leichter Nieselregen'; }
			if (translatedesc=='light rain') { document.getElementById("desc").innerHTML='Leichter Regen'; }
			if (translatedesc=='mist') { document.getElementById("desc").innerHTML='Nebel'; }
			if (translatedesc=='fog') { document.getElementById("desc").innerHTML='Nebel'; }
			if (translatedesc=='rain') { document.getElementById("desc").innerHTML='Regen'; }
			if (translatedesc=='rain shower') { document.getElementById("desc").innerHTML='Regenschauer'; }
			if (translatedesc=='severe thunderstorm/windy') { document.getElementById("desc").innerHTML='Schwere Gewitter/Windig'; }
		break;
		case "sp":
			translatedesc=obj.description.toLowerCase();
			if (translatedesc=='sunny') { document.getElementById("desc").innerHTML='Soleado'; }
			if (translatedesc=='drizzle') { document.getElementById("desc").innerHTML='Llovizna'; }
			if (translatedesc=='heavy snow') { document.getElementById("desc").innerHTML='Nieve fuerte'; }
			if (translatedesc=='heavy rain') { document.getElementById("desc").innerHTML='Luvia fuerte'; }
			if (translatedesc=='rain and snow') { document.getElementById("desc").innerHTML='Lluvia y nieve'; }
			if (translatedesc=='mixed rain and snow') { document.getElementById("desc").innerHTML='Mezcla de lluvia y nieve'; }
			if (translatedesc=='fair') { document.getElementById("desc").innerHTML='Despejado';    }
			if (translatedesc=='mostly sunny') { document.getElementById("desc").innerHTML='Mayormente soleado';	  }
			if (translatedesc=='partly sunny') { document.getElementById("desc").innerHTML='Parcialmente soleado';	 }
			if (translatedesc=='intermittent clouds') { document.getElementById("desc").innerHTML='Intermitente nublado';	 }
			if (translatedesc=='hazy sunshine') { document.getElementById("desc").innerHTML='Sol brumoso';	}
			if (translatedesc=='haze') { document.getElementById("desc").innerHTML='Bruma'; }
			if (translatedesc=='mostly cloudy') { document.getElementById("desc").innerHTML='Mayormente nublado';	 }
			if (translatedesc=='cloudy') { document.getElementById("desc").innerHTML='Nublado';    }
			if (translatedesc=='fog') { document.getElementById("desc").innerHTML='Niebla';   }
			if (translatedesc=='showers') { document.getElementById("desc").innerHTML='Chubascos';	}
			if (translatedesc=='partly sunny with showers') { document.getElementById("desc").innerHTML='Parcialmente soleado con chubascos';    }
			if (translatedesc=='thunderstorms') { document.getElementById("desc").innerHTML='Tormentas electricas';    }
			if (translatedesc=='thunderstorm') { document.getElementById("desc").innerHTML='Tormenta electrica';	}
			if (translatedesc=='mostly cloudy with thunder showers') { document.getElementById("desc").innerHTML='Mayormente nublado con tormentas de chubascos';	  }
			if (translatedesc=='partly sunny with thunder showers') { document.getElementById("desc").innerHTML='Parcialmente soleado con tormentas de chubascos';	  }
			if (translatedesc=='light rain') { document.getElementById("desc").innerHTML='Lluvia ligera';	  }
			if (translatedesc=='rain') { document.getElementById("desc").innerHTML='Lluvia';    }
			if (translatedesc=='flurries') { document.getElementById("desc").innerHTML='Rafagas';	}
			if (translatedesc=='mostly cloudy with flurries') { document.getElementById("desc").innerHTML='Mayormente nublado con rafagas';   }
			if (translatedesc=='partly sunny with flurries') { document.getElementById("desc").innerHTML='Parcialmente soleado con rafagas';    }
			if (translatedesc=='snow flurries') { document.getElementById("desc").innerHTML='Rafagas de nieve';    }
			if (translatedesc=='snow showers') { document.getElementById("desc").innerHTML='Precipitaciones de nieve';    }
			if (translatedesc=='snow') { document.getElementById("desc").innerHTML='Nieve';    }
			if (translatedesc=='mostly cloudy with snow') { document.getElementById("desc").innerHTML='Mayormente nublado con nieve';    }
			if (translatedesc=='ice') { document.getElementById("desc").innerHTML='Hielo';	}
			if (translatedesc=='sleet') { document.getElementById("desc").innerHTML='Aguanieve';	}
			if (translatedesc=='freezing rain') { document.getElementById("desc").innerHTML='Lluvia bajo cero';	 }
			if (translatedesc=='rain and snow mixed') { document.getElementById("desc").innerHTML='Mezcla de lluvia y nieve';	}
			if (translatedesc=='hot') { document.getElementById("desc").innerHTML='Caluroso';	  }
			if (translatedesc=='cold') { document.getElementById("desc").innerHTML='Frio';	 }
			if (translatedesc=='windy') { document.getElementById("desc").innerHTML='Vientoso';    }
			if (translatedesc=='clear') { document.getElementById("desc").innerHTML='Despejado';	}
			if (translatedesc=='mostly clear') { document.getElementById("desc").innerHTML='Mayormente despejado';	}
			if (translatedesc=='partly cloudy') { document.getElementById("desc").innerHTML='Parcialmente despejado';	 }
			if (translatedesc=='hazy') { document.getElementById("desc").innerHTML='Bruma';    }
			if (translatedesc=='partly cloudy with showers') { document.getElementById("desc").innerHTML='Parcialmente nublado con chubascos';	}
			if (translatedesc=='mostly cloudy with showers') { document.getElementById("desc").innerHTML='Mayormente nublado con chubascos';	  }
			if (translatedesc=='party cloudy with thunder showers') { document.getElementById("desc").innerHTML='Parcialmente nublado con tormentas de chubascos';	 }
			if (translatedesc=='foggy') { document.getElementById("desc").innerHTML='Neblina';	 }
			if (translatedesc=='light snow') { document.getElementById("desc").innerHTML='Nieve ligera'; }
			if (translatedesc=='light snow showers') { document.getElementById("desc").innerHTML='Ligeras precipitaciones de nieve'; }	 
			if (translatedesc=='rain shower') { document.getElementById("desc").innerHTML='Precipitaciones de lluvia';    }
			if (translatedesc=='drizzle') { document.getElementById("desc").innerHTML='Bruma';    }
			if (translatedesc=='mixed rain and sleet') { document.getElementById("desc").innerHTML='Mezcla de lluvia y aguanieve';	  }
			if (translatedesc=='mixed snow and sleet') { document.getElementById("desc").innerHTML='Mezcla de nieve y aguanieve';	 }
			if (translatedesc=='severe thunderstorms') { document.getElementById("desc").innerHTML='Tormentas electricas severas';	 }
			if (translatedesc=='hurricane') { document.getElementById("desc").innerHTML='Huracan';	  }
			if (translatedesc=='tropical storm') { document.getElementById("desc").innerHTML='Tormenta tropical';	 }
			if (translatedesc=='tornado') { document.getElementById("desc").innerHTML='Tornado';	}
			if (translatedesc=='freezing drizzle') { document.getElementById("desc").innerHTML='Llovizna helada';	  }
			if (translatedesc=='blowing snow') { document.getElementById("desc").innerHTML='Viento y nieve'; }
			if (translatedesc=='hail') { document.getElementById("desc").innerHTML='Granizo'; }
			if (translatedesc=='dust') { document.getElementById("desc").innerHTML='Polvareda';	}
			if (translatedesc=='somky') { document.getElementById("desc").innerHTML='Humeado';    }
			if (translatedesc=='blustery') { document.getElementById("desc").innerHTML='Tempestuoso';    }
			if (translatedesc=='mixed rain and hail') { document.getElementById("desc").innerHTML='Mezcla de lluvia y granizo';    }
			if (translatedesc=='isolated thunderstorms') { document.getElementById("desc").innerHTML='Tormentas electricas aisladas';    }
			if (translatedesc=='isolated thundershowers') { document.getElementById("desc").innerHTML='Tormentas aisladas';    }
			if (translatedesc=='scattered thunderstorms') { document.getElementById("desc").innerHTML='Tormentas electricas dispersas';    }
			if (translatedesc=='scattered showers') { document.getElementById("desc").innerHTML='Chubascos dispersos';	 }
			if (translatedesc=='scattered snow showers') { document.getElementById("desc").innerHTML='Precipitaciones de nieve dispersas';	  }
			if (translatedesc=='light rain with thunder') { document.getElementById("desc").innerHTML='LLuvia y tormenta ligera';	 }
			if (translatedesc=='not available') { document.getElementById("desc").innerHTML='No disponible';    }
			if (translatedesc=='drifting snow/windy') { document.getElementById("desc").innerHTML='Acumulacion de nieve y viento';	  }
			if (translatedesc=='light rain shower') { document.getElementById("desc").innerHTML='Precipitaciones de lluvia ligera';   }
			if (translatedesc=='thunder') { document.getElementById("desc").innerHTML='Truenos'; }
			if (translatedesc=='mostly cloudy/windy') { document.getElementById("desc").innerHTML='Mayormente nublado y ventoso'; }
			if (translatedesc=='sandstorm') { document.getElementById("desc").innerHTML='Tormentas de arena'; }
			if (translatedesc=='squalls/windy') { document.getElementById("desc").innerHTML='Chubascos y viento'; }
			if (translatedesc=='sand') { document.getElementById("desc").innerHTML='Arena'; }
			if (translatedesc=='sandstorm/windy') { document.getElementById("desc").innerHTML='Tormentas de arena y ventoso'; }
		break;
		case "it":
			translatedesc=obj.description.toLowerCase();
			if (translatedesc=='sunny') { document.getElementById("desc").innerHTML='Soleggiato'; }
			if (translatedesc=='drizzle') { document.getElementById("desc").innerHTML='Pioggerella'; }
			if (translatedesc=='heavy snow') { document.getElementById("desc").innerHTML='Forti nevicate'; }
			if (translatedesc=='heavy rain') { document.getElementById("desc").innerHTML='Forti piogge'; }
			if (translatedesc=='rain and snow') { document.getElementById("desc").innerHTML='Vevischio'; }
			if (translatedesc=='mixed rain and snow') { document.getElementById("desc").innerHTML='Misto pioggia e neve'; }
			if (translatedesc=='fair') { document.getElementById("desc").innerHTML='Sereno';    }
			if (translatedesc=='mostly sunny') { document.getElementById("desc").innerHTML='Molto soleggiato';	  }
			if (translatedesc=='partly sunny') { document.getElementById("desc").innerHTML='Parzialmente soleggiato';   }
			if (translatedesc=='intermittent clouds') { document.getElementById("desc").innerHTML='Nuvoloso a tratti';	 }
			if (translatedesc=='hazy sunshine') { document.getElementById("desc").innerHTML='Sole coperto'; }
			if (translatedesc=='haze') { document.getElementById("desc").innerHTML='Nebbia'; }
			if (translatedesc=='mostly cloudy') { document.getElementById("desc").innerHTML='Molto nuvoloso';	 }
			if (translatedesc=='cloudy') { document.getElementById("desc").innerHTML='Nuvoloso';	}
			if (translatedesc=='fog') { document.getElementById("desc").innerHTML='Nebbia';   }
			if (translatedesc=='showers') { document.getElementById("desc").innerHTML='Diluvio';	}
			if (translatedesc=='partly sunny with showers') { document.getElementById("desc").innerHTML='Soleggiato con pioggia';	 }
			if (translatedesc=='thunderstorms') { document.getElementById("desc").innerHTML='Fulmini';    }
			if (translatedesc=='thunderstorm') { document.getElementById("desc").innerHTML='Tuoni';    }
			if (translatedesc=='mostly cloudy with thunder showers') { document.getElementById("desc").innerHTML='Molto Nuvoloso con pioggia e fulmini';	  }
			if (translatedesc=='partly sunny with thunder showers') { document.getElementById("desc").innerHTML='Possibili Piogge';    }
			if (translatedesc=='light rain') { document.getElementById("desc").innerHTML='Pioggia leggera';   }
			if (translatedesc=='rain') { document.getElementById("desc").innerHTML='Pioggia';    }
			if (translatedesc=='flurries') { document.getElementById("desc").innerHTML='Nevischio'; }
			if (translatedesc=='mostly cloudy with flurries') { document.getElementById("desc").innerHTML='Nuvoloso con nevischio';   }
			if (translatedesc=='partly sunny with flurries') { document.getElementById("desc").innerHTML='Parzialmente soleggiato con neve';    }
			if (translatedesc=='snow flurries') { document.getElementById("desc").innerHTML='Raffiche di neve';    }
			if (translatedesc=='snow showers') { document.getElementById("desc").innerHTML='Precipitazioni nevose';    }
			if (translatedesc=='snow') { document.getElementById("desc").innerHTML='Neve';	  }
			if (translatedesc=='mostly cloudy with snow') { document.getElementById("desc").innerHTML='Molto nuvoloso con neve';	}
			if (translatedesc=='ice') { document.getElementById("desc").innerHTML='Ghiaccio';	}
			if (translatedesc=='sleet') { document.getElementById("desc").innerHTML='Nevischio';	}
			if (translatedesc=='freezing rain') { document.getElementById("desc").innerHTML='Grandine';	 }
			if (translatedesc=='rain and snow mixed') { document.getElementById("desc").innerHTML='Pioggia e neve'; }
			if (translatedesc=='hot') { document.getElementById("desc").innerHTML='Caldo';	  }
			if (translatedesc=='cold') { document.getElementById("desc").innerHTML='Freddo';   }
			if (translatedesc=='windy') { document.getElementById("desc").innerHTML='Ventoso';    }
			if (translatedesc=='clear') { document.getElementById("desc").innerHTML='Sereno';    }
			if (translatedesc=='mostly clear') { document.getElementById("desc").innerHTML='Molto sereno';	}
			if (translatedesc=='partly cloudy') { document.getElementById("desc").innerHTML='Parzialmente nuvoloso';	 }
			if (translatedesc=='hazy') { document.getElementById("desc").innerHTML='Velato';    }
			if (translatedesc=='partly cloudy with showers') { document.getElementById("desc").innerHTML='Cielo velato';	}
			if (translatedesc=='mostly cloudy with showers') { document.getElementById("desc").innerHTML='Nuvoloso a tratti';	  }
			if (translatedesc=='party cloudy with thunder showers') { document.getElementById("desc").innerHTML='Parzialmente nuvoloso con raffiche';	 }
			if (translatedesc=='foggy') { document.getElementById("desc").innerHTML='Nebbiolina';	 }
			if (translatedesc=='light snow') { document.getElementById("desc").innerHTML='Neve leggiera'; }
			if (translatedesc=='light snow showers') { document.getElementById("desc").innerHTML='Poca neve'; }	  
			if (translatedesc=='rain shower') { document.getElementById("desc").innerHTML='Forti precipitazioni';	 }
			if (translatedesc=='drizzle') { document.getElementById("desc").innerHTML='Freddino';	 }
			if (translatedesc=='mixed rain and sleet') { document.getElementById("desc").innerHTML='Misto pioggia e nevischio';    }
			if (translatedesc=='mixed snow and sleet') { document.getElementById("desc").innerHTML='Misto neve e nevischio';    }
			if (translatedesc=='severe thunderstorms') { document.getElementById("desc").innerHTML='Tuoni e fulmini';	 }
			if (translatedesc=='hurricane') { document.getElementById("desc").innerHTML='Uragano';	  }
			if (translatedesc=='tropical storm') { document.getElementById("desc").innerHTML='Tempesta tropicale';	  }
			if (translatedesc=='tornado') { document.getElementById("desc").innerHTML='Tornado';	}
			if (translatedesc=='freezing drizzle') { document.getElementById("desc").innerHTML='Grandine';	  }
			if (translatedesc=='blowing snow') { document.getElementById("desc").innerHTML='Vento e neve'; }
			if (translatedesc=='hail') { document.getElementById("desc").innerHTML='Grandine'; }
			if (translatedesc=='dust') { document.getElementById("desc").innerHTML='Polvere';	}
			if (translatedesc=='somky') { document.getElementById("desc").innerHTML='Humeado';    }
			if (translatedesc=='blustery') { document.getElementById("desc").innerHTML='Tempesa';	 }
			if (translatedesc=='mixed rain and hail') { document.getElementById("desc").innerHTML='misto neve e grandine';	  }
			if (translatedesc=='isolated thunderstorms') { document.getElementById("desc").innerHTML='Fulmini isolati';    }
			if (translatedesc=='isolated thundershowers') { document.getElementById("desc").innerHTML='Temporali isolati';	  }
			if (translatedesc=='scattered thunderstorms') { document.getElementById("desc").innerHTML='Tempesta di fulmini';    }
			if (translatedesc=='scattered showers') { document.getElementById("desc").innerHTML='Tempesta di pioggia';	 }
			if (translatedesc=='scattered snow showers') { document.getElementById("desc").innerHTML='Neve sparsa';    }
			if (translatedesc=='light rain with thunder') { document.getElementById("desc").innerHTML='Pioggia leggera con fulmini';    }
			if (translatedesc=='not available') { document.getElementById("desc").innerHTML='No disponible';    }
			if (translatedesc=='drifting snow/windy') { document.getElementById("desc").innerHTML='Troppa neve';	}
			if (translatedesc=='light rain shower') { document.getElementById("desc").innerHTML='Piccole precipitazioni';	  }
			if (translatedesc=='thunder') { document.getElementById("desc").innerHTML='Tuoni'; }
			if (translatedesc=='mostly cloudy/windy') { document.getElementById("desc").innerHTML='Molto nuvoloso con vento'; }
			if (translatedesc=='sandstorm') { document.getElementById("desc").innerHTML='Tormenta'; }
			if (translatedesc=='squalls/windy') { document.getElementById("desc").innerHTML='Pioggia e vento'; }
			if (translatedesc=='sand') { document.getElementById("desc").innerHTML='Arena'; }
			if (translatedesc=='sandstorm/windy') { document.getElementById("desc").innerHTML='Tormenta ventosa'; }
		break;
		default:		       
			document.getElementById("desc").innerHTML=obj.description;
		break;
		}
		
     // WEATHER CONDITION OBVIOUSLY
		document.getElementById("weathericon").src="YahooWeatherIcons/" + obj.icon +".png"; 
		
	}
	else
	{
	document.getElementById("city").innerHTML = "Internet ?!";
	}
}

function findChild (element, nodeName) {
	var child;
	for (child = element.firstChild; child != null; child = child.nextSibling)
	{
		if (child.nodeName == nodeName)
			return child;
	}
	return null;
}

function convertWoeid () {
		var url = "http://weather.yahooapis.com/forecastrss?w="+postal+"&u=f";
		$.get(url, function(data) {
		zip = $(data).find('guid').text().split('_')[0];
		weatherRefresherTemp(zip);
		});
}

// Get data with woeid (no GPS)
function fetchWeatherData (callback, zip) {
	var url="http://xml.weather.yahoo.com/forecastrss/" + zip + "_" + tempUnit + ".xml";
	var xml_request = new XMLHttpRequest();
	var requestTimer = setTimeout(function() {
	xml_request.abort();
	if (xmldata == false) { callback ({error:true}); } else {
	document.getElementById("coordinates").style.color = "red"; 
	document.getElementById("coordinates").innerHTML = "[Offline]"; }
    }, 10000);
	xml_request.onload = function(e) {
	clearTimeout(requestTimer);
	xml_loaded(e, xml_request, callback);
	}
	xml_request.overrideMimeType("text/xml");
	xml_request.open("GET", url);
	xml_request.setRequestHeader("Cache-Control", "no-cache");
	xml_request.send(null);
	return xml_request;
}

function xml_loaded (event, request, callback) {
	if (request.responseXML)
	{
		var obj = {error:false, errorString:null};
		xmldata = true;
		var effectiveRoot = findChild(findChild(request.responseXML, "rss"), "channel");
		if (gps == false) {
		if (city == "") { obj.city = findChild(effectiveRoot, "yweather:location").getAttribute("city"); }
		else { obj.city = city }
		} else { obj.city = city; }
		obj.humidity = findChild(effectiveRoot, "yweather:atmosphere").getAttribute("humidity");
		obj.windunit = findChild(effectiveRoot, "yweather:units").getAttribute("speed");	       
		obj.winddir = findChild(effectiveRoot, "yweather:wind").getAttribute("direction");
		obj.windspeed = findChild(effectiveRoot, "yweather:wind").getAttribute("speed");       
		obj.visibility = findChild(effectiveRoot, "yweather:atmosphere").getAttribute("visibility");	
		obj.visibilityunit = findChild(effectiveRoot, "yweather:units").getAttribute("distance");
		obj.sunrise = findChild(effectiveRoot, "yweather:astronomy").getAttribute("sunrise");
		obj.sunset = findChild(effectiveRoot, "yweather:astronomy").getAttribute("sunset");
		obj.chill = findChild(effectiveRoot, "yweather:wind").getAttribute("chill");
		obj.realFeel = findChild(effectiveRoot, "yweather:wind").getAttribute("chill");
		var conditionTag = findChild(findChild(effectiveRoot, "item"), "yweather:condition");
		obj.temp = conditionTag.getAttribute("temp");
		obj.icon = conditionTag.getAttribute("code");
		obj.description = conditionTag.getAttribute("text");
		var forecast = findChild(findChild(effectiveRoot, "item"), "yweather:forecast");
		obj.todaylow = forecast.getAttribute("low");
		obj.todayhigh = forecast.getAttribute("high");
		if (obj.description == "Unknown") {
			obj.description = forecast.getAttribute("text");
			obj.icon = forecast.getAttribute("code");
		}
		if (obj.icon == 3200) obj.icon = 48;
			    
		
		callback (obj); 
	}
	else
	{
		callback ({error:true, errorString:"XML request failed. no responseXML"});
	}
}

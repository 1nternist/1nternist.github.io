#!/bin/sh
#
# Rasticrac v3.1.6 (june 2014)
#
# Rapid Advanced Secure Thorough Intelligent Gaulish Nuclear Acclaimed Cracker
# Rapide Avancé Securisé Tout-terrain Intelligent Gaulois Nucléaire Approfondi Craqueur
#
#
# The truth is I never left you. I kept my promise.
#
# Je serai là, toujours pour toi, car je resterai ta meilleure amie.
#
#
# Home/Help/Donate: https://twitter.com/iRastignac
#


# ======
# Please, customize the script first!
# Choices are:

# - Default language (US:english, FR:french, ES:spanish, DE:german, IT:italian).
 RClang="US"
#RClang="FR1"
#RClang="FR2"
#RClang="ES1"
#RClang="ES2"
#RClang="DE1"
#RClang="DE2"
#RClang="IT1"
#RClang="IT2"

# - Default CrackerName (or "Anonymous").
RCcracker="Anonymous"

# - Should "extra details" appear in Ipa name? (ie: "iPad / 3GS / etc") (You can hate them)
RCextras="YES"

# - Display graphical progress bars? (based on number and/or size of apps) ("by size" is slower)
RCbarNum="YES"
RCbarSize="YES"

# - Should display be verbose? (verbose is slower and messier)
RCverbose="NO"

# - Should script talk to you? (it only speaks english, only with iOS4+, only with "speak" tool from Cydia)
RCspeak="YES"

# - Should artist's name be used in filename?
RCartistfrommeta="YES"

# - Should itemId be used in filename?
RCitemId="NO"

# - Should menu display 'real name' of apps? (slower, slower, and strange sort order)
RCrealnamemenu="NO"

# - Default compression level is blank (aka "-6"), and is the best speed/size ratio.
# - Recommended. Upload/download/storage will be good.
 RCcompression=""
# - Maximum compression ("-9") (also "-8" or "-7") is very very slow, but size is the best.
# - If your iDevice is fast, if you're not in a hurry, if size matters. Best upload/download/storage.
#RCcompression="-9"
# - Minimum compression ("-2") (also "-3" to "-5") is way faster, but size is way worse.
# - Upload/download/storage will be worse. (CrackTM and Clutch and newest Crackulous use "-2").
# - With "-2", RC will be as fast as the others.
#RCcompression="-2"
# - Don't use "-1" (sloppy) or "-0" (store), as size will be horrible, and all will suffer. Avoid.

# - Should I generate fake MetaData or not?
#   (Some people hate them, some love them, some protections check them, you should really keep them)
RCmetadata="YES"

# - Should I try LamestPatchest on the executable?
#   (It won't work 100%, but sometimes it really helps) (and now it's very very fast) (you should keep it)
RClamestpatchest="YES"

# - What menu dots do you prefer?
 RCdots=".............................."
#RCdots="------------------------------"
#RCdots="                              "
#RCdots="______________________________"

# Progress bar display
RCxxx="====="
RCsss="-----"

# Various
readonly cami="/var/mobile/Library/Caches/com.apple.mobile.installation.plist"
readonly lsd="/tmp/lsd.tmp"
readonly RCversion="316"

# DEBUG ONLY: - Force the "this script is running inside a GUI" check?
RCinaGUI="NEVER"
# DEBUG ONLY: - Check only (all tested but Ipa not created)
RCcheck="NEVER"

# Thanks you for testing.
# ======



# ======
function SelectLanguage
{
# Language US
if [ $RClang = "US" ]; then
	MsgAltMeth="Using alternative dumping method"
	MsgAnaAppl="Analyzing application"
	MsgAppLoca="Locating"
	MsgBadChoi="Bad choice"
	MsgBldMenu="Building menu..."
	MsgBrzMode="Berzerk mode: cracking ALL"
	MsgCntFind="Cannot find"
	MsgCopExec="and copying executable"
	MsgCreDire="Creating directories"
	MsgDmpUncr="Dumping unencrypted data from application"
	MsgIpaInco="Incomplete .ipa"
	MsgDskFull="Disk full"
	MsgEraMemo="Erasing memory file"
	MsgInsCydi="Install from Cydia"
	MsgIpaDone="Done as"
	MsgMnuEmpt="empty"
	MsgMarDone="Marking all apps done"
	MsgPatCryp="Locating and patching CryptID"
	MsgRemTemp="Removing temporary files"
	MsgRepData="and replacing encrypted data"
	MsgSizUnit="B"
	MsgUnaLoca="Unable to locate"
	MsgVrfDump="Verifying dump"
	MsgWrgChoi="Wrong choice"
	MsgWarning="Warning"
	MsgWrnMeta="iTunesMetadata format changed"
	MsgYouChoi="Your choices"
	MsgZipStep="Compressing the .ipa (step"
	MsgComBoth="Combining both parts into a fat binary"
	MsgSgnAppl="Signing the application"
	MsgCopArtw="Copying Artwork"
	MsgFakMeta="and faking MetaData"
	MsgNotMeta="and no MetaData"
	MsgFoundIt="Found"
	MsgWasAskd="Asked"
	MsgErrrors="Errors"
	MsgBrzNoth="nothing"
	MsgMrkDone="Mark all done                 "
	MskZroDone="Reset done list               "
fi

# Language FR1 or FR2
if [ $RClang = "FR1" -o $RClang = "FR2" ]; then
	MsgAnaAppl="Analyse d'application"
	MsgAppLoca="Recherche"
	MsgBldMenu="Construction du menu..."
	MsgBrzMode="Mode Berzerk: on craque TOUT"
	MsgCntFind="Introuvable:"
	MsgDskFull="Disque plein"
	MsgInsCydi="Installer avec Cydia"
	MsgMnuEmpt="vide"
	MsgRemTemp="Effacement fichiers temporaires"
	MsgSizUnit="o"
	MsgUnaLoca="Impossible de trouver"
	MsgWrgChoi="Mauvais choix"
	MsgWarning="Attention"
	MsgWrnMeta="nouveau format d'iTunesMetadata"
	MsgYouChoi="Votre choix"
	MsgComBoth="Consolidation des deux sections binaires"
	MsgSgnAppl="Signature de l'application"
	MsgCopArtw="Copie de l'Artwork"
	MsgFakMeta="et fausses MetaData"
	MsgNotMeta="et pas de MetaData"
	MsgWasAskd="Voulu"
	MsgErrrors="Erreurs"
	MsgBrzNoth="rien"
	MsgMrkDone="Tout marquer fait             "
	MskZroDone="Effacer liste fait            "
fi
# Language FR1 (ascii)
if [ $RClang = "FR1" ]; then
	MsgAltMeth="$( echo -ne "M\0351thode alternative de dumping" )"
	MsgBadChoi="$( echo -ne "Choix erron\0351" )"
	MsgCopExec="$( echo -ne "& copie de l'ex\0351cutable" )"
	MsgCreDire="$( echo -ne "Cr\0351ation r\0351pertoires" )"
	MsgDmpUncr="$( echo -ne "Extraction des donn\0351es d\0351crypt\0351es de l'appli" )"
	MsgIpaInco="$( echo -ne "Ipa incompl\0350te" )"
	MsgEraMemo="$( echo -ne "Effacement fichier m\0351moire" )"
	MsgIpaDone="$( echo -ne "R\0351sultat:" )"
	MsgMarDone="$( echo -ne "Toutes les apps sont marqu\0351es comme trait\0351es" )"
	MsgPatCryp="$( echo -ne "Localisation et \0351crasement du CryptID" )"
	MsgRepData="$( echo -ne "et remplacement par d\0351crypt\0351es" )"
	MsgVrfDump="$( echo -ne "V\0351rif donn\0351es" )"
	MsgZipStep="$( echo -ne "Compression de l'ipa (\0351tape" )"
	MsgFoundIt="$( echo -ne "Trouv\0351" )"
fi
# Language FR2 (utf8)
if [ $RClang = "FR2" ]; then
	MsgAltMeth="$( echo -ne "M\0303\0251thode alternative de dumping" )"
	MsgBadChoi="$( echo -ne "Choix erron\0303\0251" )"
	MsgCopExec="$( echo -ne "& copie de l'ex\0303\0251cutable" )"
	MsgCreDire="$( echo -ne "Cr\0303\0251ation r\0303\0251pertoires" )"
	MsgDmpUncr="$( echo -ne "Extraction des donn\0303\0251es d\0303\0251crypt\0303\0251es de l'appli" )"
	MsgIpaInco="$( echo -ne "Ipa incompl\0303\0250te" )"
	MsgEraMemo="$( echo -ne "Effacement fichier m\0303\0251moire" )"
	MsgIpaDone="$( echo -ne "R\0303\0251sultat:" )"
	MsgMarDone="$( echo -ne "Toutes les apps sont marqu\0303\0251es comme trait\0303\0251es" )"
	MsgPatCryp="$( echo -ne "Localisation et \0303\0251crasement du CryptID" )"
	MsgRepData="$( echo -ne "et remplacement par d\0303\0251crypt\0303\0251es" )"
	MsgVrfDump="$( echo -ne "V\0303\0251rif donn\0303\0251es" )"
	MsgZipStep="$( echo -ne "Compression de l'ipa (\0303\0251tape" )"
	MsgFoundIt="$( echo -ne "Trouv\0303\0251" )"
fi


# Language ES1 or ES2
if [ $RClang = "ES1" -o $RClang = "ES2" ]; then
	MsgBrzMode="Modo Berzerk: crackando TODO"
	MsgCntFind="No encontro"
	MsgCopExec="y copiando ejecutable"
	MsgCreDire="Creando directorios"
	MsgEraMemo="Borrado memoria archivo"
	MsgInsCydi="Instalarlo desde Cydia"
	MsgIpaDone="Done as"
	MsgMarDone="Marcando todas aplicaciones como 'hecho'"
	MsgPatCryp="Locating y patching CryptID"
	MsgRemTemp="Borrando archivos temporales"
	MsgRepData="y reemplazando datos cifrados"
	MsgSizUnit="B"
	MsgUnaLoca="Incapaz de ubicar"
	MsgWarning="Warning"
	MsgWrnMeta="iTunesMetadata formato cambiado"
	MsgCopArtw="Copiando Artwork"
	MsgFakMeta="y fingiendo MetaData"
	MsgNotMeta="y no MetaData"
	MsgFoundIt="Found"
	MsgWasAskd="Asked"
	MsgErrrors="Errores"
	MsgBrzNoth="nada"
	MsgMrkDone="Marcar todas hechas           "
	MskZroDone="Vaciar lista hechas           "
fi
# Language ES1 (ascii)
if [ $RClang = "ES1" ]; then
	MsgAltMeth="$( echo -ne "Usando m\0351todo alternativo de dumping" )"
	MsgAnaAppl="$( echo -ne "Analizando aplicaci\0363n" )"
	MsgAppLoca="$( echo -ne "Ubicaci\0363n" )"
	MsgBadChoi="$( echo -ne "Mala elecci\0363n" )"
	MsgBldMenu="$( echo -ne "Construyendo men\0372..." )"
	MsgDmpUncr="$( echo -ne "Dumping decifrados datos de la aplicaci\0363n" )"
	MsgIpaInco="$( echo -ne "\0241 Incompleta .ipa" )"
	MsgDskFull="$( echo -ne "\0277 Disco lleno" )"
	MsgMnuEmpt="$( echo -ne "vac\0355o" )"
	MsgVrfDump="$( echo -ne "Verificaci\0363n" )"
	MsgWrgChoi="$( echo -ne "Opci\0363n incorrecta" )"
	MsgYouChoi="$( echo -ne "\0277 Su elecci\0363" )"
	MsgZipStep="$( echo -ne "Compresi\0363n de .ipa (paso" )"
	MsgComBoth="$( echo -ne "Combinaci\0363n dos partes en fat binary" )"
	MsgSgnAppl="$( echo -ne "Firma de la aplicaci\0363n" )"
fi
# Language ES2 (utf8)
if [ $RClang = "ES2" ]; then
	MsgAltMeth="$( echo -ne "Usando m\0303\0251todo alternativo de dumping" )"
	MsgAnaAppl="$( echo -ne "Analizando aplicaci\0303\0263n" )"
	MsgAppLoca="$( echo -ne "Ubicaci\0303\0263n" )"
	MsgBadChoi="$( echo -ne "Mala elecci\0303\0263n" )"
	MsgBldMenu="$( echo -ne "Construyendo men\0303\0272..." )"
	MsgDmpUncr="$( echo -ne "Dumping decifrados datos de la aplicaci\0303\0263n" )"
	MsgIpaInco="$( echo -ne "\0302\0241 Incompleta .ipa" )"
	MsgDskFull="$( echo -ne "\0302\0277 Disco lleno" )"
	MsgMnuEmpt="$( echo -ne "vac\0303\0255o" )"
	MsgVrfDump="$( echo -ne "Verificaci\0303\0263n" )"
	MsgWrgChoi="$( echo -ne "Opci\0303\0263n incorrecta" )"
	MsgYouChoi="$( echo -ne "\0302\0277 Su elecci\0303\0263" )"
	MsgZipStep="$( echo -ne "Compresi\0303\0263n de .ipa (paso" )"
	MsgComBoth="$( echo -ne "Combinaci\0303\0263n dos partes en fat binary" )"
	MsgSgnAppl="$( echo -ne "Firma de la aplicaci\0303\0263n" )"
fi

# Language DE1 or DE2. Translation by Ushnak.
if [ $RClang = "DE1" -o $RClang = "DE2" ]; then
	MsgAltMeth="Alternative Methode zum Dumpen"
	MsgAnaAppl="Analyse der App"
	MsgAppLoca="Suche"
	MsgBrzMode="Berzerker Modus: ALLES wird gecrackt"
	MsgCntFind="Nicht aufzufinden:"
	MsgCopExec="Kopieren der Executable"
	MsgCreDire="Erstellen der Ordner"
	MsgDskFull="Kein Speicher mehr"
	MsgInsCydi="Installieren mit Cydia"
	MsgIpaDone="Fertig"
	MsgMnuEmpt="leer"
	MsgMarDone="Alle Apps als gecrackt markieren"
	MsgPatCryp="Aufinden und patchen der CryptID"
	MsgSizUnit="B"
	MsgWrgChoi="Schlechte Wahl"
	MsgWarning="Warnung"
	MsgYouChoi="Ihre Wahl"
	MsgZipStep="Kompression der .ipa (Schritt"
	MsgSgnAppl="Signieren der App"
	MsgCopArtw="Kopieren des Artworks"
	MsgFakMeta="und der falschen MetaData"
	MsgNotMeta="und keine MetaData"
	MsgFoundIt="Gefunden"
	MsgWasAskd="Angefragt"
	MsgErrrors="Fehler"
	MsgBrzNoth="Nichts"
fi
# Language DE1 (ascii). Translation by Ushnak.
if [ $RClang = "DE1" ]; then
	MsgBadChoi="$( echo -ne "Ung\0374ltige Wahl" )"
	MsgBldMenu="$( echo -ne "Aufbau des Men\0374s..." )"
	MsgDmpUncr="$( echo -ne "Dumping von unverschl\0374sselten Daten der App" )"
	MsgIpaInco="$( echo -ne "Unvollst\0344ndige .ipa" )"
	MsgEraMemo="$( echo -ne "L\0366schen des Zwischenspeichers" )"
	MsgRemTemp="$( echo -ne "L\0366schen des Speichers" )"
	MsgRepData="$( echo -ne "und Austausch der verschl\0374sselten Daten" )"
	MsgUnaLoca="$( echo -ne "Unm\0366glich zu Finden" )"
	MsgVrfDump="$( echo -ne "\0334perpr\0374fen des Dumps" )"
	MsgWrnMeta="$( echo -ne "Das Format der iTunesMetaData wurde ge\0344ndert" )"
	MsgComBoth="$( echo -ne "Zusammensetzung der zwei Bin\0344rdateien" )"
	MsgMrkDone="$( echo -ne "Alles als angew\0344hlt           " )"
	MskZroDone="$( echo -ne "Liste der angew\0344hlten l\0366schen " )"
fi
# Language DE2 (utf8). Translation by Ushnak.
if [ $RClang = "DE2" ]; then
	MsgBadChoi="$( echo -ne "Ung\0303\0274ltige Wahl" )"
	MsgBldMenu="$( echo -ne "Aufbau des Men\0303\0274s..." )"
	MsgDmpUncr="$( echo -ne "Dumping von unverschl\0303\0274sselten Daten der App" )"
	MsgIpaInco="$( echo -ne "Unvollst\0303\0244ndige .ipa" )"
	MsgEraMemo="$( echo -ne "L\0303\0266schen des Zwischenspeichers" )"
	MsgRemTemp="$( echo -ne "L\0303\0266schen des Speichers" )"
	MsgRepData="$( echo -ne "und Austausch der verschl\0303\0274sselten Daten" )"
	MsgUnaLoca="$( echo -ne "Unm\0303\0266glich zu Finden" )"
	MsgVrfDump="$( echo -ne "\0303\0234perpr\0303\0274fen des Dumps" )"
	MsgWrnMeta="$( echo -ne "Das Format der iTunesMetaData wurde ge\0303\0244ndert" )"
	MsgComBoth="$( echo -ne "Zusammensetzung der zwei Bin\0303\0244rdateien" )"
	MsgMrkDone="$( echo -ne "Alles als angew\0303\0244hlt           " )"
	MskZroDone="$( echo -ne "Liste der angew\0303\0244hlten l\0303\0266schen " )"
fi

# Language IT1 and IT2. Translation by Wfede21.
if [ $RClang = "IT1" -o $RClang = "IT2" ]; then
	MsgAltMeth="Metodo alternativo di dump"
	MsgAnaAppl="Analisi applicazione"
	MsgAppLoca="Localizzo"
	MsgBadChoi="Scelta sbagliata"
	MsgBldMenu="Costruisco il menu..."
	MsgCntFind="Impossibile trovare"
	MsgCopExec="e copio l'eseguibile"
	MsgCreDire="Creo le cartelle"
	MsgDmpUncr="Dump dei dati non criptati dall'applicazione"
	MsgIpaInco=".ipa non completa"
	MsgDskFull="Memoria piena"
	MsgEraMemo="Cancellando file di memoria"
	MsgInsCydi="Installa da Cydia"
	MsgIpaDone="Fatto come"
	MsgMnuEmpt="vuoto"
	MsgMarDone="Tutte le app craccate"
	MsgPatCryp="Trovo e sistemo il CryptID"
	MsgRemTemp="Rimozione file temporanei"
	MsgRepData="e sostituisco i dati criptati"
	MsgSizUnit="B"
	MsgUnaLoca="Impossibile trovare"
	MsgVrfDump="Controllo dump"
	MsgWrgChoi="Scelta sbagliata"
	MsgWarning="Attenzione"
	MsgWrnMeta="formato iTunesMetadata cambiato"
	MsgYouChoi="La tua scelta"
	MsgZipStep="Compressione .ipa (passo"
	MsgComBoth="Combino le parti in uno"
	MsgSgnAppl="Signing the application"
	MsgCopArtw="Copia di Artwork"
	MsgFakMeta="e falsifico MetaData"
	MsgNotMeta="e niente MetaData"
	MsgFoundIt="Trovato"
	MsgWasAskd="Chiesto"
	MsgErrrors="Errore"
	MsgBrzNoth="niente"
	MsgMrkDone="Segna come tutte craccate     "
	MskZroDone="Azzera lista app craccate     "
fi
# Language IT1 (ascii). Translation by Wfede21.
if [ $RClang = "IT1" ]; then
	MsgBrzMode="$( echo -ne "Modalit\0340 Berzerk: crack di tutte le app" )"
fi
# Language IT2 (utf8). Translation by Wfede21.
if [ $RClang = "IT2" ]; then
	MsgBrzMode="$( echo -ne "Modalit\0303\0240 Berzerk: crack di tutte le app" )"
fi
}



# ======
function UnicodeToHuman
{
# Convert from unicode to human, and remove unwanted chars
human=$(echo -n "$unicode" | sed -e "s: :_:g" | od -c -A n -v --width=999 | sed \
	-e 's:+:Plus:g' \
	-e 's:302.240:_:g' \
	-e 's:302.251:_:g' \
	-e 's:302.256:_:g' \
	-e 's:302.260:Degree:g' \
	-e "s:302.264:':g" \
	-e 's:303.201:A:g' \
	-e 's:303.207:C:g' \
	-e 's:303.211:E:g' \
	-e 's:303.216:I:g' \
	-e 's:303.224:O:g' \
	-e 's:303.234:U:g' \
	-e 's:303.237:B:g' \
	-e 's:303.240:a:g' \
	-e 's:303.241:a:g' \
	-e 's:303.242:a:g' \
	-e 's:303.245:a:g' \
	-e 's:303.247:c:g' \
	-e 's:303.250:e:g' \
	-e 's:303.251:e:g' \
	-e 's:303.252:e:g' \
	-e 's:303.253:e:g' \
	-e 's:303.255:i:g' \
	-e 's:303.256:i:g' \
	-e 's:303.257:i:g' \
	-e 's:303.263:o:g' \
	-e 's:303.264:o:g' \
	-e 's:303.266:o:g' \
	-e 's:303.270:o:g' \
	-e 's:303.271:u:g' \
	-e 's:303.273:u:g' \
	-e 's:303.274:u:g' \
	-e 's:304.237:g:g' \
	-e 's:304.261:i:g' \
	-e 's:305.215:o:g' \
	-e 's:305.223:oe:g' \
	-e 's:312.236:k:g' \
	-e 's:316.251:Omega:g' \
	-e 's:342.200.223:-:g' \
	-e 's:342.200.224:-:g' \
	-e "s:342.200.230:':g" \
	-e "s:342.200.231:':g" \
	-e 's:342.200.242:-:g' \
	-e 's:342.200.246:...:g' \
	-e 's:342.202.254:EUR:g' \
	-e 's:342.204.242:_:g' \
	-e 's:342.210.236:Infinity:g' \
	-e 's:342.213.205:.:g' \
	-e 's:342.226.272:_:g' \
	-e 's:342.227.217:-:g' \
	-e 's:342.230.205:_:g' \
	-e 's:342.231.253:_:g' \
	-e 's:342.235.222:_:g' \
	-e 's:347.246.205:_:g' \
	| tr -cd "[:alnum:][_'.][-]" | sed -e "s:_: :g" | sed -e "s:  : :g" )
# Todo: future enhancements
# Help wanted for unknown or other unicodes
}



# ======
function DisplayBars
{
ProgressPct=""
if [ $RCbarNum = "YES" ]; then
	ProgressXXX=$(( $BarCols * $ProgressDone / $ProgressTarget ))
	ProgressSSS=$(( $BarCols - $ProgressXXX ))
	ProgressPct=$(( 100 * $ProgressDone / $ProgressTarget ))
	echo "[${escGreen}${RCxxx:0:$ProgressXXX}${escBlue}${RCsss:0:$ProgressSSS}${escReset}] $ProgressPct%"
fi
if [ $RCbarSize = "YES" ]; then
	ProgressXXX=$(( $BarCols * $ProgressDoneSize / $ProgressTargetSize ))
	ProgressSSS=$(( $BarCols - $ProgressXXX ))
	ProgressPct=$(( 100 * $ProgressDoneSize / $ProgressTargetSize ))
	echo "[${escCyan}${RCxxx:0:$ProgressXXX}${escBlue}${RCsss:0:$ProgressSSS}${escReset}] $ProgressPct%"
fi

if [ ! -z "$ProgressPct" -a $RCspeak = "YES" ]; then
	su mobile -c "speak $ProgressPct %" &
fi
}



# ======
# Begin Core Function
function CoreFunction
{
AppInput=$1

# Cracker's name and credits
CrackerName=$2
CreditFile=$3
if [ ! "$CrackerName" ]; then
	CrackerName="$RCcracker"
fi
if [ ! "$CreditFile" ]; then
	CreditFile="$CrackerName"
fi

# Script has app's full directory path as input (ie: called from GUI)
if [ -d "$AppInput" ]; then
	tempLoc=$AppInput
	# Script is called by RemoteRasticrac from "/tmp/"
	if [ "${AppInput:0:5}" = "/tmp/" ]; then
		RCremote="YES"
		# Compression must be "low" on the iDevice; "high" recompression will be done later by the PC
		RCcompression="-2"
	fi
else
	# Script has app's name as input
	echo "$MsgAppLoca '$AppInput'"
	# Escape the "*" as ".*"
	AppGrep=$(echo "/$AppInput\.app" | sed "s:\*:\.\*:g")
	if [ -e $lsd ]; then
		tempLoc=$(grep -i "$AppGrep" $lsd)
	else
		tempLoc=""
	fi
	if [ -z "$tempLoc" ]; then
		echo "$MsgUnaLoca '$AppInput'"
		rm -f $lsd
		return 1
	fi
	AppCount=$(echo "$tempLoc" | wc -l)
	if [ $AppCount -gt 1 ]; then
		echo "$MsgFoundIt $AppCount installation directories:"
		echo "$tempLoc"
		rm -f $lsd
		return 1
	fi
fi

# The app has been found
MenuFound=$(($MenuFound + 1))
AppPath=$(dirname "$tempLoc")
AppName=$(basename "$tempLoc")
echo -n "${Meter4}${escCyan}$MsgFoundIt ${escReset}'$(echo $AppName | sed "s:\\.app::")': "

if [ ! -d "$AppPath" ]; then
	echo "$MsgUnaLoca original installation directory"
	return 1
fi
if [ ! -d "$AppPath/$AppName" ]; then
	echo "$MsgUnaLoca .app directory"
	return 1
fi
AppExec=$(plutil -key CFBundleExecutable "$tempLoc/Info.plist" 2> /dev/null)
if [ ! -e "$AppPath/$AppName/$AppExec" ]; then
	echo "$MsgUnaLoca executable"
	return 1
fi
# Get the name from MetaData
AppDisplayName=$(plutil -key itemName "$AppPath/iTunesMetadata.plist" 2> /dev/null)
# No alphanum characters at all?
AppDisplayNameAlpha=$(echo -n "$AppDisplayName" | tr -cd "[:alnum:]")
if [ "$AppDisplayNameAlpha" = "" ]; then
	#echo "${Meter5}$MsgWarning: non-alpha name!"
	AppDisplayName=""
fi
# Get the name from InfoPlist or from executable name
if [ "$AppDisplayName" = "" ]; then
	AppDisplayName=$(plutil -key CFBundleDisplayName "$tempLoc/Info.plist" 2> /dev/null)
	AppDisplayNameAlpha=$(echo -n "$AppDisplayName" | tr -cd "[:alnum:]")
	if [ "$AppDisplayNameAlpha" = "" ]; then
		AppDisplayName=$(plutil -key CFBundleName "$tempLoc/Info.plist" 2> /dev/null)
		AppDisplayNameAlpha=$(echo -n "$AppDisplayName" | tr -cd "[:alnum:]")
		if [ "$AppDisplayNameAlpha" = "" ]; then
			AppDisplayName=$AppExec
			#AppDisplayNameAlpha=$(echo -n "$AppDisplayName" | tr -cd "[:alnum:]")
			#if [ "$AppDisplayNameAlpha" = "" ]; then
			#	echo "${Meter5}$MsgWarning: too exotic name!"
			#fi
		fi
	fi
fi

# Convert AppName from unicode to human
unicode=$AppDisplayName
UnicodeToHuman
AppDisplayName=$human

# Get the artist name from MetaData
if [ $RCartistfrommeta = "YES" ]; then
	artistName=$(plutil -key artistName "$AppPath/iTunesMetadata.plist" 2> /dev/null)
	artistNameAlpha=$(echo -n "$artistName" | tr -cd "[:alnum:]")
	# At least some alphanum inside?
	if [ "$artistNameAlpha" != "" ]; then
		# Convert from unicode to human
		unicode=$artistName
		UnicodeToHuman
		AppDisplayName="$AppDisplayName [$human]"
	fi
fi

# Show the real human name of the app
echo "${Meter6}$AppDisplayName"

# Dealing with version numbers
AppVer=$(plutil -key CFBundleVersion "$tempLoc/Info.plist" 2> /dev/null | tr -d "\n\r")
AppShortVer=$(plutil -key CFBundleShortVersionString "$tempLoc/Info.plist" 2> /dev/null | tr -d "\n\r")
if [ ! "$AppShortVer" = "" ]; then
	if [ ! "$AppShortVer" = "$AppVer" ]; then
		AppVer="$AppShortVer v$AppVer"
	fi
fi
MinOS=$(plutil -key MinimumOSVersion "$tempLoc/Info.plist" 2> /dev/null | tr -d ".")
if [ "$MinOS" = "" ]; then
	echo "${Meter7}${escYellow}$MsgWarning:${escReset} unable to get MinOS"
	MinOS="000"
fi

Patched=""
Extras=""
ExtrasMatos=""
ExtrasAslr=""

# Does it need at least an iPhone3GS?
Required=$(plutil -key 'UIRequiredDeviceCapabilities' "$tempLoc/Info.plist" 2> /dev/null)
if [ ! -z "$(echo "$Required" | grep -e "armv7" -e "opengles-2")" ]; then
	ExtrasMatos=" 3GS"
fi
# Does it need at least an iPhone4?
if [ ! -z "$(echo "$Required" | grep -e "front-facing-camera" -e "gyroscope")" ]; then
	ExtrasMatos=" iPhone4"
fi
# Does it need at least an iPhone4S?
if [ ! -z "$(echo "$Required" | grep -e "bluetooth-le")" ]; then
	ExtrasMatos=" iPhone4S"
fi

# Is it iPad compatible only? Or universal?
iPad=$(plutil -key 'UIDeviceFamily' "$tempLoc/Info.plist" 2> /dev/null)
if [ ! -z "$iPad" ]; then
	if [ -z "$(echo "$iPad" | grep -e "1")" ]; then
		ExtrasMatos=" iPad"
		# Does it need at least an iPad2?
		if [ ! -z "$(echo "$Required" | grep -e "video-camera")" ]; then
			ExtrasMatos=" iPad2"
		fi
	else
		if [ ! -z "$(echo "$iPad" | grep -e "2")" ]; then
			ExtrasMatos="$ExtrasMatos Univ"
		fi
	fi
fi

# Creating temporary directory
if [ $RCverbose = "YES" ]; then
	echo -n "${Meter10}$MsgCreDire "
fi
WorkDir="/tmp/RC-$(date +%Y%m%d-%H%M%S)"
NewAppDir="$HOME/Documents/Cracked"
if [ -e "$WorkDir" ]; then
	rm -rf "$WorkDir"
fi
mkdir -p "$WorkDir"
if [ ! -e "$NewAppDir" ]; then
	mkdir -p "$NewAppDir"
fi
mkdir -p "$WorkDir/$AppName"
if [ ! -d "$WorkDir" -o ! -d "$NewAppDir" -o ! -d "$WorkDir/$AppName" ]; then
	echo "failed! Directories not created"
	return 1
fi

# Copying executable (with attributes) to temporary space
if [ $RCverbose = "YES" ]; then
	echo "${Meter15}$MsgCopExec"
fi

foo=$( cp -p "$AppPath/$AppName/$AppExec" "$WorkDir/$AppName/" 2>&1> /dev/null )
if [ ! -e "$WorkDir/$AppName/$AppExec" ]; then
	echo "Unable to copy application files"
	rm -fr "$WorkDir"
	return 1
else
	# Disk full?
	if [ $(stat -c%s "$WorkDir/$AppName/$AppExec") != $(stat -c%s "$AppPath/$AppName/$AppExec") ]; then
		echo "${escRed}$MsgDskFull ?${escReset}"
		rm -fr "$WorkDir"
		return 1
	fi
fi

if [ $RCverbose = "YES" ]; then
	echo -n "${Meter20}$MsgAnaAppl: "
fi

# Initialize parts index and variables
PartIndex[6]=0
PartIndex[9]=0
PartIndex[11]=0
PartIndex[64]=0
HowManyDone=0
LastDoneType=0
LastNotDonePart=0

# Looking for fat's magic numbers (CafeBabe)
CafeBabeIsFat=$(dd bs=4 count=1 skip=0 if="$WorkDir/$AppName/$AppExec" 2> /dev/null | od -A n -t x1 -v | grep "ca fe ba be")

# Is executable FAT or THIN?
if [ ! "$CafeBabeIsFat" ]; then
	# "THIN" will be done as a "FATx1"
	if [ $RCverbose = "YES" ]; then
		echo "${Meter25}Thin Binary found"
	fi
	HowManyParts="01"
	# Get the thin's headers, then extract the details
	ThinBabe=$(dd bs=12 count=1 skip=0 if="$WorkDir/$AppName/$AppExec" 2> /dev/null | od -A n -t x1 -v | tr -d ' ','\n')
	# PartType can be 6, 9, 11 or 64
	PartType[1]=$(echo "0x${ThinBabe:14:2}" | awk --non-decimal-data '{print ($1)*64 }')
	if [ ${PartType[1]} = 0 ]; then
		PartType[1]=$(echo "0x${ThinBabe:16:2}" | awk --non-decimal-data '{print ($1)+0 }')
	fi
	PartData[1]="empty"
	PartIndex[${PartType[1]}]=1
	PartOffset[1]=1
	PartLogicalSize[1]=$(stat -c%s "$WorkDir/$AppName/$AppExec")
	PartPhysicalSize[1]=${PartLogicalSize[1]}
else
	# This is a FATx2 or FATx3 babe
	if [ $RCverbose = "YES" ]; then
		echo "${Meter25}Fat Binary found"
	fi

	# Get the fat's full headers, keep it, then extract the details
	foo=$(dd bs=4096 count=1 skip=0 if="$WorkDir/$AppName/$AppExec" of="$WorkDir/$AppName/CafeBabe.is.Fat" 2>&1> /dev/null)
	FullCafeBabe=$(cat "$WorkDir/$AppName/CafeBabe.is.Fat" | od -A n -t x1 -v | tr -d ' ','\n')

	# PartType can be 6, 9, 11 or 64
	PartType[1]=$(echo "0x${FullCafeBabe:16:2}" | awk --non-decimal-data '{print ($1)*64 }')
	if [ ${PartType[1]} = 0 ]; then
		PartType[1]=$(echo "0x${FullCafeBabe:30:2}" | awk --non-decimal-data '{print ($1)+0 }')
	fi
	PartData[1]=${FullCafeBabe:32:16}
	PartIndex[${PartType[1]}]=1

	PartType[2]=$(echo "0x${FullCafeBabe:56:2}" | awk --non-decimal-data '{print ($1)*64 }')
	if [ ${PartType[2]} = 0 ]; then
		PartType[2]=$(echo "0x${FullCafeBabe:70:2}" | awk --non-decimal-data '{print ($1)+0 }')
	fi
	PartData[2]=${FullCafeBabe:72:16}
	PartIndex[${PartType[2]}]=2

	# Part3 is perhaps empty, but we check it also
	PartType[3]=$(echo "0x${FullCafeBabe:96:2}" | awk --non-decimal-data '{print ($1)*64 }')
	if [ ${PartType[3]} = 0 ]; then
		PartType[3]=$(echo "0x${FullCafeBabe:110:2}" | awk --non-decimal-data '{print ($1)+0 }')
	fi

	PartOffset[1]=$(echo "0x${PartData[1]:0:8}" | awk --non-decimal-data '{print ($1)+1 }')
	PartLogicalSize[1]=$(echo "0x${PartData[1]:8:8}" | awk --non-decimal-data '{print ($1)+0 }')
	PartOffset[2]=$(echo "0x${PartData[2]:0:8}" | awk --non-decimal-data '{print ($1)+1 }')
	PartLogicalSize[2]=$(echo "0x${PartData[2]:8:8}" | awk --non-decimal-data '{print ($1)+0 }')

	# How many parts in FAT executable? Two or Three? Or?
	HowManyParts=${FullCafeBabe:14:2}

	# Rare "Bad Monsters" exist! When "MonsterX3 and iOStarget<7", they say "MonsterX2" in their header!
	if [ $HowManyParts = "02" -a ${PartType[3]} != 0 ]; then
		echo "${Meter25}${escRed}Note: Bad Monster found!${escReset} I'm scared!"
		###ExtrasAslr="$ExtrasAslr BAD"
		###HowManyParts="03"
		###foo=$(echo -ne "\x03" | dd bs=1 seek=7 conv=notrunc status=noxfer of="$WorkDir/$AppName/$AppExec" 2>&1> /dev/null)
		foo=$(cat /dev/zero | dd bs=1 seek=48 count=20 conv=notrunc status=noxfer of="$WorkDir/$AppName/CafeBabe.is.Fat" 2>&1> /dev/null)
		foo=$(cat /dev/zero | dd bs=1 seek=48 count=20 conv=notrunc status=noxfer of="$WorkDir/$AppName/$AppExec" 2>&1> /dev/null)
		echo "${Meter25}${escRed}Note: Bad Monster killed${escReset} for now"
	fi

	if [ $HowManyParts != "02" ]; then
		# More than three parts is impossible
		if [ $HowManyParts != "03" ]; then
			echo "${escRed}Monster x$HowManyParts is impossible!${escReset}"
			rm -fr "$WorkDir"
			return 1
		else
			# Three parts
			PartData[3]=${FullCafeBabe:112:16}
			PartOffset[3]=$(echo "0x${PartData[3]:0:8}" | awk --non-decimal-data '{print ($1)+1 }')
			PartLogicalSize[3]=$(echo "0x${PartData[3]:8:8}" | awk --non-decimal-data '{print ($1)+0 }')
			PartIndex[${PartType[3]}]=3
			echo "${Meter25}${escRed}Note: MonsterX$HowManyParts${escReset} (${PartType[1]} - ${PartType[2]} - ${PartType[3]})"
			###ExtrasAslr="$ExtrasAslr MONSTER"
		fi
	else
		# Two parts only. Forcing part3 to "empty"
		PartType[3]=0
		PartData[3]="Empty"
		PartOffset[3]=$(( 1 + $(stat -c%s "$WorkDir/$AppName/$AppExec") ))
		PartLogicalSize[3]=0
	fi

	# Computings
	PartPhysicalSize[1]=$(( ${PartOffset[2]} - ${PartOffset[1]} ))
	PartPhysicalSize[2]=$(( ${PartOffset[3]} - ${PartOffset[2]} ))
	PartPhysicalSize[3]=$(( 1 + $(stat -c%s "$WorkDir/$AppName/$AppExec") - ${PartOffset[3]} ))
fi

	# Display debug data
	if [ "$DebugMode" = "YES" ]; then
		echo "Idx: ${PartIndex[6]} ${PartIndex[9]} ${PartIndex[11]} ${PartIndex[64]}"
		echo "Off: ${PartOffset[1]}  ${PartOffset[2]}  ${PartOffset[3]}"
		echo "Lsz: ${PartLogicalSize[1]}  ${PartLogicalSize[2]}  ${PartLogicalSize[3]}"
		echo "Psz: ${PartPhysicalSize[1]}  ${PartPhysicalSize[2]}  ${PartPhysicalSize[3]}"
	fi

	# Copying some files
	mkdir "$WorkDir/$AppName/SC_Info"
	chmod 777 "$WorkDir/$AppName/SC_Info"
	cp -p "$AppPath/$AppName/SC_Info/$AppExec.sinf" "$WorkDir/$AppName/SC_Info/$AppExec.sinf"
	#chmod 777 "$WorkDir/$AppName/SC_Info/$AppExec.sinf"
	cp -p "$AppPath/$AppName/SC_Info/$AppExec.supp" "$WorkDir/$AppName/SC_Info/$AppExec.supp"
	#chmod 777 "$WorkDir/$AppName/SC_Info/$AppExec.supp"

	# Parts are done by descending type (because iOS always takes the "higher" first)
	for j in 64 11 9 6
	do
		WhichPart=${PartIndex[$j]}
		if [ $WhichPart = 0 ]; then
			if [ "$DebugMode" = "YES" ]; then
				echo "- No 'type $j' part found"
			fi
		# If a part of this type exists
		else
			if [ "$DebugMode" = "YES" ]; then
				echo "- The 'type $j' part is number $WhichPart"
			fi
			# If Cpu is not strong enough for this type of part
			if [ $j -gt $CPUType ]; then
				if [ "$DebugMode" = "YES" ]; then
					echo "  Can't do 'type $j' part with 'type $CPUType' cpu"
				fi
				LastNotDonePart=$WhichPart
			# If Cpu is strong enough for this type of part
			else
				if [ "$DebugMode" = "YES" ]; then
					echo "  Will do 'type $j' part with 'type $CPUType' cpu"
				fi
				if [ $RCverbose = "YES" ]; then
					echo "Cracking type$j part (#$WhichPart) on type$CPUType cpu"
				fi

				# iOS can't crack twice the same binary, so we will randomize its name before each call.
				RandRand=$RANDOM
				mv "$WorkDir/$AppName/$AppExec" "$WorkDir/$AppName/$RandRand$AppExec"
				mv "$WorkDir/$AppName/SC_Info/$AppExec.sinf" "$WorkDir/$AppName/SC_Info/$RandRand$AppExec.sinf"
				mv "$WorkDir/$AppName/SC_Info/$AppExec.supp" "$WorkDir/$AppName/SC_Info/$RandRand$AppExec.supp"

				# RastDecrypted/DumpDecrypted creates its output in "current directory", so we change it before the call
				cd "$WorkDir/$AppName"
				WorkAround="NO"
				if [ -e /usr/bin/logger ]; then
					logger -t RCdump "RCbegin {"
				fi
				foo=$(DYLD_INSERT_LIBRARIES=$RastDec "$WorkDir/$AppName/$RandRand$AppExec" mach-o decryption dumper 2>&1)
				RetRet=$?
				if [ $RetRet != 1 ]; then
					# 127=exec not found; 137=wrong iOS type; 133=dylib not loaded or incompatible executable
					echo "${Meter32}${escRed}Error:${escReset} RastDecrypted failed (${j}on$CPUType=$RetRet)"
					if [ "$DebugMode" = "YES" ]; then
						echo "${Meter32}${escYellow}DUMP ERROR:${escReset} << $foo >>" | tr -d '\n'
						echo "${Meter32}."
					fi
					if [ -e /usr/bin/logger ]; then
						echo "$foo" | logger -t RCdump
					fi
					# Dirty shame lame temp workaround!
					if [ "$j" = "$CPUType" ]; then
						echo "${Meter32}Note: dirty shame lame temp workaround! (${j}on$CPUType)"
						WorkAround="YES"
						LastNotDonePart=$WhichPart
						if [ -e "$WorkDir/$AppName/$RandRand$AppExec.decrypted" ]; then
							rm "$WorkDir/$AppName/$RandRand$AppExec.decrypted"
						fi
					else
						rm -fr "$WorkDir"
						return $RetRet
					fi
				fi
				if [ -e /usr/bin/logger ]; then
					logger -t RCdump "} RCend"
				fi

				if [ "$WorkAround" = "NO" ]; then
					# Does we have some output data?
					if [ ! -e "$WorkDir/$AppName/$RandRand$AppExec.decrypted" ]; then
						echo "${Meter32}${escRed}Error:${escReset} empty RastDecrypted (${j}on$CPUType)"
						rm -fr "$WorkDir"
						return 1
					fi
					# Is the file complete?
					if [ $(stat -c%s "$WorkDir/$AppName/$RandRand$AppExec.decrypted") != $(stat -c%s "$WorkDir/$AppName/$RandRand$AppExec") ]; then
						echo "${escRed}$MsgDskFull ?${escReset}"
						rm -fr "$WorkDir"
						return 1
					fi
					# Note that only one part has been decrypted! We extract it and we erase the output temp file
					foo=$( cat "$WorkDir/$AppName/$RandRand$AppExec.decrypted" | tail --bytes=+${PartOffset[$WhichPart]} | head --bytes=${PartLogicalSize[$WhichPart]} > "$WorkDir/$AppName/DumpedPart${PartType[$WhichPart]}" 2> /dev/null )
					rm "$WorkDir/$AppName/$RandRand$AppExec.decrypted"
					# Is the decrypted data complete?
					if [ $(stat -c%s "$WorkDir/$AppName/DumpedPart${PartType[$WhichPart]}") != ${PartLogicalSize[$WhichPart]} ]; then
						echo "${escRed}$MsgDskFull ?${escReset}"
						rm -fr "$WorkDir"
						return 1
					fi

					# Getting all executable's details
					Peter=$(otool -l "$WorkDir/$AppName/DumpedPart${PartType[$WhichPart]}")
					# (RIP)

					# Check if decrypted part is really decrypted
					if [ "$(echo "$Peter" | grep cryptid | awk '{print $2}')" != "0" ]; then
						echo "${Meter32}${escRed}Error:${escReset} RastDecrypted still crypted (${j}on$CPUType)"
						rm -fr "$WorkDir"
						return 1
					fi

					# Trying "LamestPatchest" to remove some security checks and some ads and some spies
					if [ $RClamestpatchest = "YES" ]; then
						if [ $RCverbose = "YES" ]; then
							echo -n "${Meter33}Trying LamestPatchest... "
						fi

	##					# Check executable's dump address. (Newest SDKs now always shift it).
	##					Pesky=$(echo "$Peter" | tr '\n' '\\' | sed -e 's:Load command:\nLoad command:g' | grep "cmd LC_SEGMENT" | grep "segname __TEXT" | tr '\\' '\n' | grep "vmaddr" | awk --non-decimal-data '{print ($2)+0 }')
	##					if [ $Pesky != 4096 ]; then
	##						if [ "$DebugMode" = "YES" ]; then
	##							echo "${Meter33}${escRed}$MsgWarning:${escReset} address shifting ($Pesky)"
	##						fi
	##					fi

						# Finding location of the "cstring" data block to be LamedPatched
						LPoff=$(echo "$Peter" | grep cstring -A4 | grep offset | awk '{print $2}')
						if [ ! "$LPoff" ]; then
							echo "${Meter33}${escYellow}$MsgWarning:${escReset} unable to find LPoff"
							rm -fr "$WorkDir"
							return 1
						else
							LPsize=$(echo "$Peter" | grep cstring -A4 | grep size | awk --non-decimal-data '{print ($2)+0 }')
							if [ ! "$LPsize" ]; then
								echo "${Meter33}${escYellow}$MsgWarning:${escReset} unable to find LPsize"
								rm -fr "$WorkDir"
								return 1
							fi
						fi
						###echo "$Pesky, $LPoff, $LPsize"

						# Dumping the data block to be LamedPatched
						foo=$( cat "$WorkDir/$AppName/DumpedPart${PartType[$WhichPart]}" | tail --bytes=+$(($LPoff + 1)) | head --bytes=$LPsize > "$WorkDir/LP.bin" 2> /dev/null )

						# Disk full?
						if [ $(stat -c%s "$WorkDir/LP.bin") != $LPsize ]; then
							echo "${escRed}$MsgDskFull ?${escReset}"
							rm -fr "$WorkDir"
							return 1
						fi

						# LamingPatching!
						sed --in-place=.BCK \
							-e 's=/Cydia\.app=/Czdjb\.bpp=g' \
							-e 's=/cydia=/czdjb=g' \
							-e 's=/SBSettings=/SBSfttjngs=g' \
							-e 's=/WinterBoard=/WjntfrBpbrd=g' \
							-e 's=ppa\.aidyC=ppb\.bjdzC=g' \
							-e 's=/private/var/lib/apt=/prjvbtf/vbr/ljb/bpt=g' \
							-e 's=/bin/mkdir=/bjn/mkdjr=g' \
							-e 's=/bin/bash=/bjn/bbsh=g' \
							-e 's=/usr/bin/ssh=/vsr/bjn/ssh=g' \
							-e 's=/usr/sbin/ssh=/vsr/sbjn/ssh=g' \
							-e 's=/Applicat\d0\d0\d0ions/dele\d0\d0\d0teme\.txt=/Bppljcbt\d0\d0\d0jpns/dflf\d0\d0\d0tfmf\.txt=g' \
							-e 's=/Appl\d0\d0\d0ications/C\d0\d0ydi\d0a\.app=/Bppl\d0\d0\d0jcbtjpns/C\d0\d0zdj\d0b\.bpp=g' \
							-e 's=ations/Cy\d0\d0\d0/Applic\d0pp\d0\d0dia.a=btjpns/Cz\d0\d0\d0/Bppljc\d0pp\d0\d0djb.b=g' \
							-e 's=ate/va\d0\d0/priv\d0\d0\d0pt/\d0b/a\d0r/li=btf/vb\d0\d0/prjv\d0\d0\d0pt/\d0b/b\d0r/lj=g' \
							-e 's=pinchmedia\.com=pjnchmfdjb\.cpm=g' \
							-e 's=admob\.com=bdmpb\.cpm=g' \
							-e 's=doubleclick\.net=dpvblfcljck\.nft=g' \
							-e 's=googlesyndication\.com=gppglfszndjcbtjpn\.cpm=g' \
							-e 's=flurry\.com=flvrrz\.cpm=g' \
							-e 's=qwapi\.com=qwbpj\.cpm=g' \
							-e 's=mobclix\.com=mpbcljx\.cpm=g' \
							-e 's=http://ad\.=http://bd_=g' \
							-e 's=http://ads\.=http://bds_=g' \
							-e 's=http://ads2\.=http://bds2_=g' \
							-e 's=http://ingameads\.=http://jngbmfbds_=g' \
							-e 's=adwhirl\.com=bdwhjrl\.cpm=g' \
							-e 's=vdopia\.com=vdppjb\.cpm=g' \
							-e 's=tapjoyads\.com=tbpjpzbds\.cpm=g' \
							-e 's=/Library/MobileSubstrate=/Ljbrbrz/MpbjlfSvbstrbtf=g' \
							"$WorkDir/LP.bin"

						#	"/Applications/mAdvLock.app"
						#	"/Applications/Icy\.app"
						#	"appads\.com"
						#	/System/Library/LaunchDaemons/com.ikey.bbot.plist
						#	/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist
						#	/usr/libexec/sftp-server
						#	/Applications/MxTube.app
						#	/Applications/IntelliScreen.app
						#	/Applications/FakeCarrier.app
						#	/Applications/blackra1n.app

						# Disk full?
						if [ ! -e "$WorkDir/LP.bin.BCK" ]; then
							echo "${escRed}$MsgDskFull ?${escReset}"
							rm -fr "$WorkDir"
							return 1
						else
							if [ $(stat -c%s "$WorkDir/LP.bin.BCK") != $(stat -c%s "$WorkDir/LP.bin") ]; then
								echo "${escRed}$MsgDskFull ?${escReset}"
								rm -fr "$WorkDir"
								return 1
							fi
						fi

						# Something patched or not?
						cmp --silent "$WorkDir/LP.bin.BCK" "$WorkDir/LP.bin"
						# Differences --> patched
						if [ "$?" != "0" ]; then
							if [ $RCverbose = "YES" ]; then
								echo "${Meter34}patched things"
							fi
							Patched=" LP"
							foo=$(dd seek=1 count=1 obs=$LPoff ibs=$LPsize conv=notrunc if="$WorkDir/LP.bin" of="$WorkDir/$AppName/DumpedPart${PartType[$WhichPart]}" 2>&1> /dev/null)
						else
							if [ $RCverbose = "YES" ]; then
								echo "${Meter34}found nothing"
							fi
						fi
						rm "$WorkDir/LP.bin.BCK"
						rm "$WorkDir/LP.bin"
					fi

					if [ $CPUType = "64" ]; then
						# Signing the application with 'ldid' (because 'ldone' can't do 64bits executable)
						if [ $RCverbose = "YES" ]; then
							echo "${Meter35}$MsgSgnAppl (ldid)"
						fi
						foo=$(ldid -s "$WorkDir/$AppName/DumpedPart${PartType[$WhichPart]}" 2>&1> /dev/null)
					else
						# Signing the application with 'ldone' (better than 'ldid')
						if [ $RCverbose = "YES" ]; then
							echo "${Meter35}$MsgSgnAppl"
						fi
						foo=$(ldone "$WorkDir/$AppName/DumpedPart${PartType[$WhichPart]}" -s 2>&1> /dev/null)
						# (( Because "ldone" is not perfect, each part should be signed alone here (and not the whole final binary) ))
					fi
				fi

				# Back to previous filenames (ready for next part)
				mv "$WorkDir/$AppName/$RandRand$AppExec" "$WorkDir/$AppName/$AppExec"
				mv "$WorkDir/$AppName/SC_Info/$RandRand$AppExec.sinf" "$WorkDir/$AppName/SC_Info/$AppExec.sinf"
				mv "$WorkDir/$AppName/SC_Info/$RandRand$AppExec.supp" "$WorkDir/$AppName/SC_Info/$AppExec.supp"
				# Preparing for next part (even if it doesn't exist)
				# Overwrite the PartType byte with a dummy value in the Fat Header (if it's a Fat binary). (Kinda "SwapSwapAttack style": this part won't be choosen again by iOS)
				if [ -e "$WorkDir/$AppName/CafeBabe.is.Fat" ]; then
					OffsetToPatch=$(( $WhichPart * 20 - 5 ))
					#DEBUG# echo "ByteTypeAttack $OffsetToPatch"
					foo=$(echo -n "z" | dd bs=1 seek=$OffsetToPatch conv=notrunc status=noxfer of="$WorkDir/$AppName/$AppExec" 2>&1> /dev/null)
				fi

				if [ "$WorkAround" = "NO" ]; then
					# This was the last success
					LastDoneType=$j
					# How many done with success
					HowManyDone=$(($HowManyDone + 1))
				fi

			fi
		fi
	done

	# Removing temp files
	rm "$WorkDir/$AppName/$AppExec"
	rm "$WorkDir/$AppName/SC_Info/$AppExec.sinf"
	rm "$WorkDir/$AppName/SC_Info/$AppExec.supp"
	rmdir "$WorkDir/$AppName/SC_Info"

	if [ "$DebugMode" = "YES" ]; then
		echo "__________ ( --> $HowManyDone )"
	fi

	# Zero part was done (because cpu is too old)
	if [ $HowManyDone = 0 ]; then
		echo "${Meter40}${escRed}Error:${escReset} can't do any part!"
		rm -fr "$WorkDir"
		return 1
	else
		# Only one part was done: force from fat/monster to thin
		if [ $HowManyDone = 1 ]; then
			if [ "$DebugMode" = "YES" ]; then
				echo "Will go 'thin' now"
			fi
			# Executable will now be thin. The only good part is the "LastDoneType one".
			mv "$WorkDir/$AppName/DumpedPart$LastDoneType" "$WorkDir/$AppName/$AppExec"
			CafeBabeIsFat=""
		else
			if [ "$DebugMode" = "YES" ]; then
				if [ $HowManyParts = "03" -a $HowManyDone != 3 ]; then
					echo "MonsterX03 will go X02. We will delete part number '$LastNotDonePart'"
				else
					echo "Full: $HowManyParts = $HowManyDone"
				fi
			fi
		fi
	fi

# CafeBabe is still fat. Now merging parts
if [ "$CafeBabeIsFat" ]; then
	# Is it a x3 Monster?
	if [ $HowManyParts = "03" ]; then
		# It won't be a full x3 Monsters?
		if [ $HowManyDone != 3 ]; then
			# We must convert it to MonsterX2
			echo "${Meter42}${escRed}Trying to tame the beast...${escReset} (${PartType[1]} - ${PartType[2]} - ${PartType[3]})"
			# Display debug data
			if [ "$DebugMode" = "YES" ]; then
				echo "${Meter42}1> ${FullCafeBabe:16:40}"
				echo "${Meter42}2> ${FullCafeBabe:56:40}"
				echo "${Meter42}3> ${FullCafeBabe:96:40}"
			fi

			# We will remove one of the three parts
			# Parts will be swapped so third part will be removed
			if [ $LastNotDonePart != 3 ]; then
				echo "${Meter43}Transfert... Autolargue... Retournement... ($LastNotDonePart)"
				OffsetToTransfer=$(( $LastNotDonePart * 20 - 12 ))
				foo=$(dd bs=1 seek=$OffsetToTransfer skip=48 count=20 conv=notrunc status=noxfer if="$WorkDir/$AppName/CafeBabe.is.Fat" of="$WorkDir/$AppName/CafeBabe.is.Fat" 2>&1> /dev/null)
			#else
				#DEBUG# echo "The ToRemovePart is already third"
			fi

			# Third part is now PartToRemove and will be removed. Only two parts now in headers.
			foo=$(echo -ne "\x02" | dd bs=1 seek=7 conv=notrunc status=noxfer of="$WorkDir/$AppName/CafeBabe.is.Fat" 2>&1> /dev/null)
			foo=$(cat /dev/zero | dd bs=1 seek=48 count=20 conv=notrunc status=noxfer of="$WorkDir/$AppName/CafeBabe.is.Fat" 2>&1> /dev/null)

			# Display debug data
			if [ "$DebugMode" = "YES" ]; then
				FullCafeBabe=$(cat "$WorkDir/$AppName/CafeBabe.is.Fat" | od -A n -t x1 -v | tr -d ' ','\n')
				echo "n> ${FullCafeBabe:14:2}"
				echo "1> ${FullCafeBabe:16:40}"
				echo "2> ${FullCafeBabe:56:40}"
				echo "3> ${FullCafeBabe:96:40}"
			fi
		else
			echo "${Meter44}${escYellow}Note:${escReset} Full x3 beast (${PartType[1]} - ${PartType[2]} - ${PartType[3]})"
		fi
	fi

	# Executable is rebuilt from scratch (headers+parts)
	rm -f "$WorkDir/$AppName/$AppExec"
	cp "$WorkDir/$AppName/CafeBabe.is.Fat" "$WorkDir/$AppName/$AppExec"
	chmod 777 "$WorkDir/$AppName/$AppExec"

	# Each done part is added to the Fat executable
	for j in 6 9 11 64
	do
		if [ -e "$WorkDir/$AppName/DumpedPart$j" ]; then
			#DEBUG# echo "Adding 'Type $j' Part"
			WhichPart=${PartIndex[$j]}
			foo=$(dd seek=1 count=1 obs=$(( ${PartOffset[$WhichPart]} - 1 )) ibs=${PartPhysicalSize[$WhichPart]} conv=notrunc if="$WorkDir/$AppName/DumpedPart$j" of="$WorkDir/$AppName/$AppExec" 2>&1> /dev/null)
			rm -f "$WorkDir/$AppName/DumpedPart$j"
		fi
	done
#else
	#DEBUG# echo "CafeBabe is Thin"
fi

# Dropping my girlfriend
if [ -e "$WorkDir/$AppName/CafeBabe.is.Fat" ]; then
	rm -f "$WorkDir/$AppName/CafeBabe.is.Fat"
fi

##	# Signing the application with 'ldone' (better than 'ldid')
##	if [ $RCverbose = "YES" ]; then
##		echo "${Meter64}$MsgSgnAppl"
##	fi
##	foo=$(ldone "$WorkDir/$AppName/$AppExec" -s 2>&1> /dev/null)

# Timestamp-back executable to defeat checks
touch -r "$AppPath/$AppName/$AppExec" "$WorkDir/$AppName/$AppExec"

# Adding date
DayToday="$( date +%Y-%m-%d )"

# Adding credits file
if [ ! "$CrackerName" = "Anonymous" ]; then
	if [ $RCverbose = "YES" ]; then
		echo "${Meter65}Adding Credits"
	fi
	echo "Cracked by $CrackerName ($DayToday)" > "$WorkDir/$AppName/$CreditFile"
	if [ ! -e "$AppPath/$AppName/$AppExec.crc" ]; then
		echo "CheckSum=$(echo -n "$CrackerName" | od -A n -t x1 -v | tr -d ' ','\n')" > "$WorkDir/$AppName/$AppExec.crc"
		touch -r "$AppPath/$AppName/$AppExec" "$WorkDir/$AppName/$AppExec.crc"
	fi
fi

# Building .ipa (step 1)
mkdir -p "$WorkDir/Payload"
if [ ! -e "$WorkDir/Payload" ]; then
	echo "Failed to create Payload directory"
	rm -fr "$WorkDir"
	return 1
fi
mv "$WorkDir/$AppName" "$WorkDir/Payload/"

if [ $RCverbose = "YES" ]; then
	echo -n "${Meter66}$MsgCopArtw "
fi
if [ -e "$AppPath/iTunesArtwork" ]; then
	cp -a "$AppPath/iTunesArtwork" "$WorkDir/"
	# Timestamp ArtWork to protect cracker
	touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/iTunesArtwork"
else
	echo "${Meter66}failed!"
fi

# Handling of CodeResources and friends. Timestamp them to protect cracker
cp -a "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/Info.plist"
mkdir "$WorkDir/Payload/$AppName/_CodeSignature"
cp "$AppPath/$AppName/_CodeSignature/CodeResources" "$WorkDir/Payload/$AppName/_CodeSignature/CodeResources"
touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/_CodeSignature/CodeResources"
if [ -e "$AppPath/$AppName/CodeResources" ]; then
	ln -s "_CodeSignature/CodeResources" "$WorkDir/Payload/$AppName/CodeResources"
	touch -h -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/CodeResources"
fi
if [ -e "$AppPath/$AppName/ResourceRules.plist" ]; then
	cp "$AppPath/$AppName/ResourceRules.plist" "$WorkDir/Payload/$AppName/ResourceRules.plist"
	touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/ResourceRules.plist"
fi

# Faking MetaData
if [ $RCverbose = "YES" ]; then
	if [ $RCmetadata = "YES" ]; then
		echo "${Meter69}$MsgFakMeta"
	else
		echo "${Meter69}$MsgNotMeta"
	fi
fi
if [ "$CrackerName" = "Anonymous" ]; then
	CrackedBy="piece.of.cake@apple.com"
else
	CrackedBy="$CrackerName@cracked.by"
	echo "${Patched}RC$CrackerName" | tr -cd "[:alnum:]" | tr "[A-Z][a-z][1-9]" "[1-9][a-z][A-Z]" > "$WorkDir/Payload/$AppName/_CodeSignature/ResourceRules"
	touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/_CodeSignature/ResourceRules"
fi

touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/_CodeSignature"

if [ -e "$AppPath/iTunesMetadata.plist" ]; then
	cp "$AppPath/iTunesMetadata.plist" "$WorkDir/iTunesMetadataSource.plist"
else
	echo "${Meter69}${escRed}Error:${escReset} problem with MetaData!"
	plutil -create "$WorkDir/iTunesMetadataSource.plist" 2>&1> /dev/null
fi

# Convert to pure text (if binary plist)
plutil -xml "$WorkDir/iTunesMetadataSource.plist" 2>&1> /dev/null
# Remove unwanted keys and subkeys
plutil -remove -key 'com.apple.iTunesStore.downloadInfo' "$WorkDir/iTunesMetadataSource.plist" 2>&1> /dev/null
plutil -remove -key 'asset-info' "$WorkDir/iTunesMetadataSource.plist" 2>&1> /dev/null
plutil -remove -key 'is-purchased-redownload' "$WorkDir/iTunesMetadataSource.plist" 2>&1> /dev/null
# Building lines
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$WorkDir/iTunesMetadata.plist"
echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> "$WorkDir/iTunesMetadata.plist"
echo "<plist version=\"1.0\">" >> "$WorkDir/iTunesMetadata.plist"
echo "<dict>" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>UIRequiredDeviceCapabilities</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</dict>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "\t<key>appleId</key>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "\t<string>$CrackedBy</string>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "\t<key>purchaseDate</key>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "\t<date>2014-05-05T05:05:05Z</date>" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>artistId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>artistName</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>bundleDisplayName</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>bundleShortVersionString</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>bundleVersion</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>buy-only</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>buyParams</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>copyright</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>drmVersionNumber</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>fileExtension</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>gameCenterEnabled</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>gameCenterEverEnabled</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 -m1 "<key>genre</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 -m1 "<key>genreId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>itemId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>itemName</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>kind</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>playlistArtistName</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>playlistName</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>price</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>priceDisplay</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>product-type</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>rating</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</dict>" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>releaseDate</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>s</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>software-type</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>softwareIcon57x57URL</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>softwareIconNeedsShine</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>softwareSupportedDeviceIds</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</array>" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>softwareVersionBundleId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>softwareVersionExternalIdentifier</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>softwareVersionExternalIdentifiers</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</array>" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>subgenres</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</array>" >> "$WorkDir/iTunesMetadata.plist"
# ???? <key>transitGeoFileURL</key><string>
grep -A1 "<key>vendorId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>versionRestrictions</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
echo "</dict>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "</plist>\n" >> "$WorkDir/iTunesMetadata.plist"
# Timestamp Metadata to protect cracker
touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/iTunesMetadata.plist"

if [ $RCitemId = "YES" ]; then
	Heidi="{$(grep -A1 "<key>itemId</key>" "$WorkDir/iTunesMetadataSource.plist" | grep "<integer>" | tr -d "\t" | sed -e 's:<integer>::g' -e 's:</integer>::g' )}."
else
	Heidi=""
fi

# Check for possible iTunesMetadata format changes
rm -f /tmp/diff.txt
diff "$WorkDir/iTunesMetadataSource.plist" "$WorkDir/iTunesMetadata.plist" > /tmp/diff.txt
rm -f "$WorkDir/iTunesMetadataSource.plist"
NewFields=$(wc -l /tmp/diff.txt | cut -f 1 -d " ")
if [ $NewFields -ne "11" -a $NewFields -ne "7" ]; then
	echo "${Meter70}${escYellow}$MsgWarning:${escReset} $MsgWrnMeta ?"
	#BEGIN DEBUG
	#echo "( $NewFields )"
	#cat /tmp/diff.txt
	#END DEBUG
fi
rm -f /tmp/diff.txt

# Don't want MetaData? Keeping a backup
if [ ! $RCmetadata = "YES" ]; then
	mv "$WorkDir/iTunesMetadata.plist" "$WorkDir/iTunesMetadata$RCmetadatafilename.plist"
fi

# Want Extras in filename?
if [ $RCextras = "YES" ]; then
	Extras="$ExtrasMatos$ExtrasAslr"
fi

# Building IPA name, adding AppVersion and MinOsVersion, adding CrackerName
if [ "$CrackerName" = "Anonymous" ]; then
	CrackedBy=""
	ZipComment="RC$RCversion ($DayToday) $Patched"
else
	CrackedBy="-$CrackerName"
	ZipComment="From $CrackerName with RC$RCversion ($DayToday) $Patched"
fi

# Cutting too long app name
AppDisplayName=${AppDisplayName:0:150}

 IPAName="$NewAppDir/$Heidi$AppDisplayName (v$AppVer$Extras$Patched os$MinOS)$CrackedBy.rc$RCversion.ipa"
#IPAName="$NewAppDir/$Heidi$(echo -n "$AppDisplayName" | tr " " ".")-v$AppVer$CrackedBy.rc$RCversion.ipa"

# When RemoteMode, remember the real IPA filename and use generic name instead.
if [ "$RCremote" = "YES" ]; then
	echo "$(basename "$IPAName")" > /tmp/REMOTEname.txt
	IPAName="/tmp/REMOTEout.zip"
fi

# If debug-check-only, don't create real Ipa but an empty proof file
if [ $RCcheck = "YES" ]; then
	#DEBUG# ls -l "$WorkDir/$AppName/$AppExec"
	printf -v CRC '%x' $(cksum "$WorkDir/Payload/$AppName/$AppExec" | cut -f 1 -d ' ')
	touch "$IPAName.$CRC.checked"
	echo "${Meter100}${escGreen}Check:${escReset} $AppDisplayName (v$AppVer$Extras$Patched os$MinOS)."
	rm -fr "$WorkDir"
	echo "$tempLoc" >> /var/mobile/.cracked.log
	MenuOK=$(($MenuOK + 1))
	return 0
fi

#DEBUG
#FreeSize=$(df -m "$NewAppDir/" | grep disk | awk '{print $4}')
#echo "${Meter74}Debug: free size on device    [$FreeSize M$MsgSizUnit]"
#DEBUG

# Size of first data to compress
FirstSize=$(du -m -s "$WorkDir" | cut -f 1)
echo "${Meter75}$MsgZipStep 1) [$FirstSize M$MsgSizUnit]"

# Timestamping
touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName"
touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload"

cd "$WorkDir"
rm -f "$IPAName"
rm -f "$IPAName.temp"
# Script version number in zip's comment
# Faster ipa thanks to smart files order (?)
ZipError=$( echo "$ZipComment" | zip $RCcompression -z -y -m -r "$IPAName.temp" "Payload/$AppName/Info.plist" iTunesMetadata$RCmetadatafilename.plist iTunesArtwork Payload 2>&1> /dev/null )
cd "$PwdPwd" 2>&1> /dev/null

if [ ! -z "$ZipError" ]; then
	echo "${Meter76}${escRed}ZipError${escReset}: \"$( echo "$ZipError" | tr -d "\t\n" )\""
fi

if [ ! -e "$IPAName.temp" ]; then
	echo "${escRed}Failed to compress the .ipa${escReset}"
	rm -fr "$WorkDir"
	return 1
fi

# RemoteRasticrac only does one zip step
if [ "$RCremote" != "YES" ]; then
	# Remember size of .ipa after step 1
	ZipSize=$(stat -c%s "$IPAName.temp")

	# Building .ipa (step 2)
	# Using a SymbolicLink pointing to App Directory
	ln -s "$AppPath/" "$WorkDir/Payload"

	#DEBUG
	#FreeSize=$(df -m "$NewAppDir/" | grep disk | awk '{print $4}')
	#echo "${Meter74}Debug: free size on device    [$FreeSize M$MsgSizUnit]"
	#DEBUG

	# Size of other data to compress
	SecondSize=$(du -m -s "$AppPath" | cut -f 1)
	echo "${Meter80}$MsgZipStep 2) [$(( $SecondSize - $FirstSize )) M$MsgSizUnit]"

	cd "$WorkDir"
	# Zip doesn't move/delete source, and excludes some unwanted files. Smart "-n" flag excludes already compact files.
	ZipError=$( zip $RCcompression -u -y -r -n .jpg:.JPG:.jpeg:.png:.PNG:.gif:.GIF:.Z:.gz:.zip:.zoo:.arc:.lzh:.rar:.arj:.mp3:.mp4:.m4a:.m4v:.ogg:.ogv:.avi:.flac:.aac \
		"$IPAName.temp" Payload/* -x Payload/iTunesArtwork Payload/iTunesMetadata.plist "Payload/StoreKit/*" "Payload/Documents/*" "Payload/Library/*" "Payload/tmp/*" "Payload/$AppName/$AppExec" "Payload/$AppName/SC_Info/*" "Payload/$AppName/_CodeSignature/*" "Payload/$AppName/CodeResources" "Payload/$AppName/ResourceRules.plist" "Payload/$AppName/Info.plist" 2>&1> /dev/null )
	## */

	if [ ! -z "$ZipError" ]; then
		echo "${Meter81}${escRed}ZipError${escReset}: \"$( echo "$ZipError" | tr -d "\t\n" )\""
	fi

	# It failed because disk is full (zip size after Part[2] is still the same)
	if [ $(stat -c%s "$IPAName.temp") -eq $ZipSize ]; then
		echo "${escRed}$MsgIpaInco ! $MsgDskFull ?${escReset}"
		rm -f "$IPAName.temp"
		rm -fr "$WorkDir"
		return 1
	fi
	# Removing SymbolicLink
	rm "$WorkDir/Payload"
	cd "$PwdPwd" 2>&1> /dev/null
fi

# Ipa final name
mv "$IPAName.temp" "$IPAName"

# Removing temporary directory
if [ $RCverbose = "YES" ]; then
	echo "${Meter98}$MsgRemTemp"
fi
rm -rf "$WorkDir"

# Cracked app is added into the already-cracked apps list
echo "$tempLoc" >> /var/mobile/.cracked.log

## Cracked app is added into Crackulous' cracked-apps-ready-to-upload list
## (Function now removed)
#p="/private/var/root/Documents/IPAStore.plist"
#if [ -e "$p" ]; then
#	#If Crackulous is running, we must close it first
#	Killous=$(ps -e | grep "/Applications/Crackulous" | grep -v "grep" | awk '{print $1}')
#	if [ "$Killous" ]; then
#		echo "${Meter99}$MsgWarning: killing Crackulous softly"
#		kill $Killous
#		sleep 1
#	fi
#	plutil -key "$IPAName" -type int -value "$(plutil -key 'itemId' "$AppPath/iTunesMetadata.plist" 2> /dev/null)" "$p" 2>&1> /dev/null
#fi

# Displaying finished Ipa details
ZipSize=$(du -m -s "$IPAName" | cut -f 1)
echo "${Meter100}${escGreen}$MsgIpaDone${escReset} \"$IPAName\" [$ZipSize M$MsgSizUnit]"

MenuOK=$(($MenuOK + 1))
}

# End Core Function
# ======




# ======
# Begin script main part

# Origin's directory
PwdPwd="$PWD"

# Select texts' language
SelectLanguage

# Votez Martine !
if [ ! -e /bin/ps ]; then
	echo "$MsgCntFind 'ps'. $MsgInsCydi: 'adv-cmds'"
	exit 1
fi

# Is this script running inside a GUI?
# (ie: parent process runs from "/Applications/xxx.app")
if [ ! "$(ps -e | grep "$PPID" | grep "/Applications/.*\.app/")" = "" ]; then
	RCinaGUI="YES"
fi

# Initialize progress meter labels (for GUI)
if [ $RCinaGUI = "YES" ]; then
	export TERM="xterm"
	for ((i=0;i<=100;i++)); do
		export Meter$i="$i% "
	done
else
	# Not in a GUI
#	clear
	echo ""

	# If output is not a terminal (ie: redirected to a file, etc), don't display colors/etc
	if [[ -t 1 ]]; then
		# Escape codes
		esc="$( echo -ne "\033" )"
		escReset="${esc}[0m"
		escUnder="${esc}[4m"
		escBlue="${esc}[34m"
		escGreen="${esc}[32m"
		escRed="${esc}[31m"
		escYellow="${esc}[33m"
		escPurple="${esc}[35m"
		escCyan="${esc}[36m"
	fi

	# Terminal misconfigured
	if [ -z "$TERM" ]; then
		echo "${escYellow}$MsgWarning:${escReset} your \$TERM is not set"
		export TERM="xterm"
	fi

	# MobileTermBackgrounder is used = problems
	if [ "$TERM" = "screen" ]; then
		#echo "${escYellow}$MsgWarning:${escReset} your \$TERM is 'screen'"
		export TERM="vt100"
	fi

	# Screen width
	if [ ! -e /usr/bin/tput ]; then
		echo "$MsgCntFind 'tput'"
		exit 1
	fi
	Cols=$(tput cols)

	# Progress bars full width
	BarCols=$(( $Cols - 8 ))
	while [ ${#RCxxx} -lt $BarCols ]
	do
		RCxxx="$RCxxx$RCxxx"
		RCsss="$RCsss$RCsss"
	done
fi

echo "${Meter0}*** ${escUnder}Rasticrac v3.1.6${escReset} ***"

if [ ! -e /usr/bin/basename ]; then
	echo "$MsgCntFind 'basename'. $MsgInsCydi: 'BigBoss Recommanded Tools'"
	exit 1
fi

if [ ! -e /usr/bin/plutil ]; then
	echo "$MsgCntFind 'plutil'. $MsgInsCydi: 'Erica Utils'"
	exit 1
fi

if [ ! -e /usr/bin/otool ]; then
	echo "$MsgCntFind 'otool'. $MsgInsCydi: 'Darwin CC Tools'"
	exit 1
fi

if [ ! -e /usr/bin/ldone ]; then
	echo "$MsgCntFind 'ldone'. $MsgInsCydi"
	exit 1
fi
if [ ! -x /usr/bin/ldone ]; then
	echo "Please 'chmod 777 /usr/bin/ldone'"
	exit 1
fi

if [ ! -e /bin/touch ]; then
	echo "$MsgCntFind 'touch'"
	exit 1
fi

if [ ! -e /usr/bin/zip ]; then
	echo "$MsgCntFind 'zip'"
	exit 1
fi

if [ ! -e /usr/sbin/sysctl ]; then
	echo "$MsgCntFind 'sysctl'"
	exit 1
fi

if [ ! -e /usr/bin/cut ]; then
	echo "$MsgCntFind 'cut'"
	exit 1
fi

if [ ! -e /usr/bin/awk ]; then
	echo "$MsgCntFind 'awk'. $MsgInsCydi: 'Gawk'"
	exit 1
fi

# Secret "debug" flag (can be first only)
if [ "$1" = "-debug" ]; then
	shift
	DebugMode="YES"
fi

# iDevice's type of CPU
CPUGenre=$(sysctl hw.cputype | awk '{print $2}')
CPUType=$(sysctl hw.cpusubtype | awk '{print $2}')

# iDevice's iOS version
iOSver=$(plutil -key ProductVersion /System/Library/CoreServices/SystemVersion.plist 2> /dev/null | tr -d ".")
if [ "$DebugMode" = "YES" ]; then
	echo "${Meter1}${escYellow}Note:${escReset} running iOS$iOSver on '$CPUType@$CPUGenre' cpu"
fi

# Convert compatible CpuType
if [ $CPUType = "10" ]; then
	CPUType="9"
fi
if [ $CPUGenre = "16777228" -a $CPUType = "1" ]; then
	CPUType="64"
	echo "${escRed}NOTE:${escReset} this Cpu only has experimental support!"
	echo "${escRed}NOTE:${escReset} all IPAs must be tested!"
fi
# Test if Cpu is known and handled yet
if [ $CPUType != "6" -a $CPUType != "9" -a $CPUType != "11" -a $CPUType != "64" ]; then
	echo "${escRed}STOP:${escReset} can't handle this cpu ($CPUType@$CPUGenre) yet!"
	exit 1
fi

if [ $CPUType = "64" ]; then
	if [ ! -e /usr/bin/ldid ]; then
		echo "$MsgCntFind 'ldid'. $MsgInsCydi: 'Link Identity Editor'"
		exit 1
	fi
fi

# RastDecrypted is needed to decrypt executables
# Choice between iOS7-optimized one and non-iOS7 one
if [ ${iOSver:0:1} -lt 7 ]; then
	RastDec="/usr/lib/RastDecrypted102.dylib"
else
	RastDec="/usr/lib/RastDecrypted102.iOS7.dylib"
fi
if [ ! -e $RastDec ]; then
	echo "$MsgCntFind '$RastDec'."
	exit 1
fi

# Cydia's "Speak" tool is needed for speech support
if [ ${iOSver:0:1} -lt 4 ]; then
	RCspeak="NO"
fi
if [ $RCspeak = "YES" ]; then
	if [ ! -e /usr/bin/speak ]; then
		echo "${Meter3}${escYellow}Note:${escReset} install 'Speak' from Cydia for speech"
		RCspeak="NO"
	fi
fi

if [ ! -e /usr/bin/head ]; then
	echo "$MsgCntFind 'head'"
	exit 1
fi

if [ ! -e /usr/bin/tail ]; then
	echo "$MsgCntFind 'tail'"
	exit 1
fi

# Create an empty public memory file
if [ ! -e /var/mobile/.cracked.log ]; then
	touch /var/mobile/.cracked.log
	chmod 666 /var/mobile/.cracked.log
fi

# Don't want MetaData? It sucks!
if [ ! $RCmetadata = "YES" ]; then
	echo "${Meter3}${escYellow}Note:${escReset} MetaData='NO' is not recommended"
	RCmetadatafilename=".backup"
fi

# Is syslog available?
if [ ! -e /usr/sbin/syslogd ]; then
	echo "${Meter3}${escYellow}Note:${escReset} should install 'syslogd' from Cydia"
fi
if [ ! -e /usr/bin/logger ]; then
	echo "${Meter3}${escYellow}Note:${escReset} should install 'logger' from Cydia (inetutils)"
fi

if [ ! $RCinaGUI = "YES" ]; then
	# Get and store the encrypted apps list
	rm -f $lsd
	touch $lsd
	# Check for previous cached data. Does cached applist = present applist?
	camicache="/tmp/cache.$(ls -l $cami | tr -cd "[:alnum:]")"
	if [ -e $camicache ]; then
		###echo "${Meter4}${escYellow}Note:${escReset} using cached applist"
		cp $camicache $lsd
	else
		###echo "${Meter4}${escYellow}Note:${escReset} refreshing applist"
		# Why is that slower than next code???
		#ls -d /var/mobile/Applications/*/*.app/SC_Info 2> /dev/null | sort -f -t \/ -k 6 | while read OneApp
		## */
		#do
		#	echo "$(dirname "$OneApp")" >> $lsd
		#done

		# Why is that faster than previous code???
		ls -d /var/mobile/Applications/*/*.app 2> /dev/null | sort -f -t \/ -k 6 | while read OneApp
		## */
		do
			if [ -d "$OneApp/SC_Info" ]; then
				echo "$OneApp" >> $lsd
			fi
		done
		cp $lsd $camicache
	fi
fi

# Loop through the different flags
LoopExit="NO"
while [ $LoopExit = "NO" ]
do
	LoopExit="YES"

	# Verbose mode flag
	if [ "$1" = "-v" ]; then
		shift
		RCverbose="YES"
		LoopExit="NO"
	fi

	# Secret "check only" flag
	if [ "$1" = "-chk" ]; then
		shift
		RCcheck="YES"
		LoopExit="NO"
	fi

	# Secret "LamerPatcher Off" flag
	if [ "$1" = "-lpoff" ]; then
		shift
		RClamestpatchest="NO"
		LoopExit="NO"
	fi

	# Secret "Extras Off" flag
	if [ "$1" = "-extoff" ]; then
		shift
		RCextras="NO"
		LoopExit="NO"
	fi

	# Secret "Speak Off" flag
	if [ "$1" = "-spkoff" ]; then
		shift
		RCspeak="NO"
		LoopExit="NO"
	fi

	# Secret "Artist Off" flag
	if [ "$1" = "-artoff" ]; then
		shift
		RCartistfrommeta="NO"
		LoopExit="NO"
	fi

	# Secret "Compression Ratio" flag
	if [ "$1" = "-2" -o "$1" = "-3" -o "$1" = "-4" -o "$1" = "-5" -o "$1" = "-6" -o "$1" = "-7" -o "$1" = "-8" -o "$1" = "-9" ]; then
		RCcompression="$1"
		shift
		echo "${Meter5}${escYellow}Note:${escReset} will now use Compression Ratio '$RCcompression'"
		LoopExit="NO"
	fi
done

# No more argument: display help
if [ $# -lt 1 ]; then
	if [ ! $RCinaGUI = "YES" ]; then
		# The "-a" flag is not displayed in the help, but it does exist.
		scr=$(basename $0)
		echo "List/Help: $scr"
		echo "     Menu: $scr [-v] -m [CN [CFN]]"
		echo " CrackAll: $scr [-v] -all [CN [CFN]]"
		echo " CrackOne: $scr [-v] AN [CN [CFN]]"
		echo " MarkDone: $scr -mark"
		echo "ResetDone: $scr -zero"
		echo
		echo "AN=AppName CN=CrackerName CFN=CreditFileName"
		echo
		if [ -e $lsd ]; then
			cat $lsd | cut -f 6 -d '/' | sed "s:\\.app:,:" | tr "\n" " "
			echo -e "\010\010."
			rm -f $lsd
		fi
		exit 1
	else
		echo "Missing argument!"
		exit 2
	fi
fi

# Erasing memory file
if [ "$1" = "-zero" ]; then
	echo "$MsgEraMemo"
	# Don't use rm
	cp /dev/null /var/mobile/.cracked.log 2>&1> /dev/null
	rm -f $lsd
	exit 1
fi

# Marking all apps as done in memory file
if [ "$1" = "-mark" ]; then
	echo "$MsgMarDone"
	if [ -e $lsd ]; then
		cp $lsd /var/mobile/.cracked.log 2>&1> /dev/null
		rm -f $lsd
	else
		cp /dev/null /var/mobile/.cracked.log 2>&1> /dev/null
	fi
	exit 1
fi

# Only if 'root'
if [ $(id -u) = 0 ]; then
	vm1="/System/Library/LaunchDaemons/com.apple.dynamic_pager.plist"
	vm2="/Library/Preferences/com.apple.virtualMemory.plist"
	# Create a swapfile
	if [ "$1" = "-swapon" ]; then
		echo "Creating a swapfile..."
		if [ ! -e "$vm1" ]; then
			if [ ! -e "$vm2" ]; then
				echo "Creating..."
				echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict>\
					<key>KeepAlive</key><true/><key>Label</key><string>com.apple.dynamic_pager</string><key>OnDemand</key><false/><key>ProgramArguments</key>\
					<array><string>/sbin/dynamic_pager</string><string>-F</string><string>/private/var/vm/swapfile</string></array><key>RunAtLoad</key><true/></dict></plist><key>UseEncryptedSwap</key><false/>" > $vm1
				chmod 755 $vm1
				plutil -xml $vm1 2>&1> /dev/null
				echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist version=\"1.0\"><dict>\
					<key>UseEncryptedSwap</key><false/></dict></plist>" > $vm2
				chmod 755 $vm2
				plutil -xml $vm2 2>&1> /dev/null
				chmod 777 /var/vm
				echo "Reboot needed..."
				sync
				reboot
				exit 2
			fi
		fi
		exit 1
	fi
	# Remove the swapfile
	if [ "$1" = "-swapoff" ]; then
		echo "Removing the swapfile..."
		if [ -e "$vm1" ]; then
			if [ -e "$vm2" ]; then
				echo "Removing..."
				rm -f $vm1
				rm -f $vm2
				echo "Reboot needed..."
				sync
				reboot
				exit 2
			fi
		fi
		exit 1
	fi
	vm1=""
	vm2=""
fi

if [ ! $RCinaGUI = "YES" ]; then
	MenuAsked=0
	MenuFound=0
	MenuOK=0
	MenuError=0
	MenuErrorList=""

	# Berzerk mode: cracking all apps
	if [ "$1" = "-all" ]; then
		echo -n "$MsgBrzMode !"
		if [ -e $lsd ]; then
			# ("grep -vf" is sloooow. Use "-Fvf")
			# Removing already-done from full apps list
			tempgrep=$(mktemp)
			grep -Fvf /var/mobile/.cracked.log $lsd > $tempgrep
			MenuAsked=$(cat $tempgrep | wc -l)
			ProgressTarget=$MenuAsked
			ProgressDone=0
			echo " ($MenuAsked)"
			echo

			if [ $RCbarSize = "YES" -a $MenuAsked != 0 ]; then
				ProgressTargetSize=0
				ProgressDoneSize=0
				echo -n "Computing total size"
				# (Don't use a pipe for the while loop)
				while read OneApp
				do
					# Size of the app, till dawn.
					AppSize=$( du -s -k "$OneApp" | cut -f 1 )
					ProgressTargetSize=$(($ProgressTargetSize + $AppSize))
					echo -n "."
				done < $tempgrep
				echo
				echo
			fi

			# (Don't use a pipe for the while loop)
			while read OneApp
			do
				ProgressDone=$(($ProgressDone + 1))
				echo -n "${escPurple}($ProgressDone/$ProgressTarget)${escReset} "

				if [ $RCbarSize = "YES" ]; then
					# Size of the app, till dawn.
					AppSize=$( du -s -k "$OneApp" | cut -f 1 )
					ProgressDoneSize=$(($ProgressDoneSize + $AppSize))
				fi

				CoreFunction "$OneApp" "$2" "$3"
				if [ $? = 1 ]; then
					if [ $RCspeak = "YES" ]; then
						su mobile -c "speak Error!" &
					fi
					MenuError=$(($MenuError + 1))
					if [ -z "$MenuErrorList" ]; then
						MenuErrorList="${OneApp:62:$(( ${#OneApp} - 66 ))}"
					else
						MenuErrorList="$MenuErrorList, ${OneApp:62:$(( ${#OneApp} - 66 ))}"
					fi
				fi

				DisplayBars
				echo
			done < $tempgrep
			rm -f $tempgrep
			rm -f $lsd
		else
			echo " ($MsgBrzNoth)"
		fi

		echo "$MsgWasAskd:all ($MenuAsked)  $MsgFoundIt:$MenuFound  $MsgErrrors:$MenuError  OK:$MenuOK."
		if [ ! -z "$MenuErrorList" ]; then
			echo "$MsgErrrors: $MenuErrorList."
		fi

		if [ $RCspeak = "YES" ]; then
			su mobile -c "speak Terminated." &
		fi

		exit 1
	else
		# Menu mode: displaying menu and processing user choices
		if [ "$1" = "-m" ]; then
			if [ -e $lsd ]; then
				echo -n "$MsgBldMenu"
				rm -f /tmp/lsdmenu.tmp
				touch /tmp/lsdmenu.tmp
				rm -f /tmp/lsddisp.tmp
				# Array with all the letters
				Letters=( $( echo {a..z} {a..z}{a..z} ) )
				# Search for best columns size
				BestFiller=666
				BestFound=666
				for (( i=18;i<=30;i++)); do
					FillerFound=$(( $Cols % $i ))
					if [ $FillerFound -lt $BestFiller ]; then
						BestFiller=$FillerFound
						BestFound=$i
						if [ $FillerFound = 0 ]; then
							break
						fi
					fi
				done
				LongNames=$(( $BestFound - 3 ))
				ShortNames=$(( $LongNames - 1 ))

				# Using 'real name' in menu?
				if [ $RCrealnamemenu = "YES" ]; then
					tempfile=$(mktemp)
					templist=$(mktemp)
					# Using 'list of installed apps' from SpringBoard as source for real names
					cp $cami $tempfile
					plutil -xml $tempfile 2>&1> /dev/null
					cat $tempfile | grep -F -e "<key>CFBundleDisplayName</key>" -e "<key>Container</key>" -A1 | tr -d "\t" > $templist
					rm $tempfile
				fi

				Letter=0
				LineLength=$Cols
				# ("grep -vf" is sloooow. Use "-Fvf")
				# Removing already-done from full apps list
				grep -Fvf /var/mobile/.cracked.log $lsd | while read OneApp
				do
					GoodLetter=${Letters[$Letter]}

					# Using 'real name' in menu?
					if [ $RCrealnamemenu = "YES" ]; then
						unicode="$( cat $templist | grep "${OneApp:0:61}" -B3 | grep -m1 "<string>" | sed -e 's:<string>::g' -e 's:</string>::g' )"
						# If name is too exotic, use 'internal name'
						if [ "$(echo -n "$unicode" | tr -cd "[:alnum:]")" = "" ]; then
							unicode="${OneApp:62:$(( ${#OneApp} - 66 ))}"
						fi
						UnicodeToHuman
						OneOneApp="$human$RCdots"
					else
						OneOneApp="${OneApp:62:$(( ${#OneApp} - 66 ))}$RCdots"
					fi

					if [ $Letter -lt 26 ]; then
						echo -n "${escPurple}$GoodLetter:${escReset}${OneOneApp:0:$LongNames} " >> /tmp/lsddisp.tmp
						echo "\"$GoodLetter\"$OneApp" >> /tmp/lsdmenu.tmp
						LineLength=$(( $LineLength - $LongNames - 3 ))
					else
						echo -n "${escPurple}$GoodLetter:${escReset}${OneOneApp:0:$ShortNames} " >> /tmp/lsddisp.tmp
						echo "\"$GoodLetter\"$OneApp" >> /tmp/lsdmenu.tmp
						LineLength=$(( $LineLength - $ShortNames - 4 ))
					fi

					# End of line
					if [ $LineLength = $BestFiller ]; then
						echo "" >> /tmp/lsddisp.tmp
						LineLength=$Cols
					fi

					Letter=$(($Letter + 1))
					# Too much apps (max is 27*26 = 702)
					if [ $Letter = 702 ]; then
						break
					fi
				done

				if [ $RCrealnamemenu = "YES" ]; then
					rm $templist
				fi

				# Other options
				echo -n "${escPurple}0:${escReset}${MskZroDone:0:$LongNames} " >> /tmp/lsddisp.tmp
				echo -n "${escPurple}9:${escReset}${MsgMrkDone:0:$LongNames} " >> /tmp/lsddisp.tmp

				# Displaying menu
				if [ -e /tmp/lsddisp.tmp ]; then
					echo
					clear
					echo "*** ${escUnder}Rasticrac v3.1.6 menu${escReset} ***"
					cat /tmp/lsddisp.tmp
					rm -f /tmp/lsddisp.tmp
					echo
					read -p "$MsgYouChoi ? " YourChoices
					echo
					ProgressTarget=$( echo $YourChoices | wc -w )
					ProgressDone=0

					if [ $RCbarSize = "YES" -a $ProgressTarget != 0 ]; then
						ProgressTargetSize=0
						ProgressDoneSize=0
						echo -n "Computing total size"

						# Do all these choices
						for OneChoice in $YourChoices
						do
							if [ ! "$OneChoice" = "0" ]; then
								if [ ! "$OneChoice" = "9" ]; then
									tempLoc=$(grep -i "\"$OneChoice\"" /tmp/lsdmenu.tmp | cut -f 3 -d "\"")
									if [ ! -z "$tempLoc" ]; then
										AppCount=$(echo "$tempLoc" | wc -l)
										if [ $AppCount = 1 ]; then
											# Size of the app, till dawn.
											AppSize=$( du -s -k "$tempLoc" | cut -f 1 )
											ProgressTargetSize=$(($ProgressTargetSize + $AppSize))
											echo -n "."
										fi
									fi
								fi
							fi
						done
						echo
						echo

						# Nothing to do; no need for progress
						if [ $ProgressTargetSize = 0 ]; then
							RCbarSize="ZERO"
						fi
					fi

					# Do all these choices
					for OneChoice in $YourChoices
					do
						ProgressDone=$(($ProgressDone + 1))
						echo -n "${escPurple}($ProgressDone/$ProgressTarget)${escReset} "
						MenuAsked=$(($MenuAsked + 1))
						if [ "$OneChoice" = "0" ]; then
							echo "$MsgEraMemo"
							# Don't use rm
							cp /dev/null /var/mobile/.cracked.log 2>&1> /dev/null
							MenuAsked=$(($MenuAsked - 1))
						else
							if [ "$OneChoice" = "9" ]; then
								echo "$MsgMarDone"
								cp $lsd /var/mobile/.cracked.log 2>&1> /dev/null
								MenuAsked=$(($MenuAsked - 1))
							else
								tempLoc=$(grep -i "\"$OneChoice\"" /tmp/lsdmenu.tmp | cut -f 3 -d "\"")
								if [ -z "$tempLoc" ]; then
									echo "$MsgWrgChoi ($OneChoice)"
								else
									AppCount=$(echo "$tempLoc" | wc -l)
									if [ $AppCount = 1 ]; then

										if [ $RCbarSize = "YES" ]; then
											# Size of the app, till dawn.
											AppSize=$( du -s -k "$tempLoc" | cut -f 1 )
											ProgressDoneSize=$(($ProgressDoneSize + $AppSize))
										fi

										CoreFunction "$tempLoc" "$2" "$3"
										if [ $? = 1 ]; then
											if [ $RCspeak = "YES" ]; then
												su mobile -c "speak Error!" &
											fi
											MenuError=$(($MenuError + 1))
											if [ -z "$MenuErrorList" ]; then
												MenuErrorList="${tempLoc:62:$(( ${#tempLoc} - 66 ))}"
											else
												MenuErrorList="$MenuErrorList, ${tempLoc:62:$(( ${#tempLoc} - 66 ))}"
											fi
										fi
									else
										echo "$MsgBadChoi ($OneChoice = $AppCount)"
									fi
								fi
							fi
						fi

						DisplayBars
						echo

					done
					rm -f /tmp/lsdmenu.tmp

					if [ $RCspeak = "YES" ]; then
						su mobile -c "speak Finished." &
					fi

					echo
					echo "$MsgWasAskd:$MenuAsked  $MsgFoundIt:$MenuFound  $MsgErrrors:$MenuError  OK:$MenuOK."
					if [ ! -z "$MenuErrorList" ]; then
						echo "${escRed}$MsgErrrors:${escReset} $MenuErrorList."
					fi
				else
					echo " $MsgMnuEmpt !"
				fi
				rm -f $lsd
			else
				echo " $MsgMnuEmpt !"
			fi
			exit 1
		fi
	fi
fi

# Just one app to do
CoreFunction "$1" "$2" "$3"
#if [ $? = 1 ]; then
#	echo "Error: problem encountered."
#	exit 1
#fi

# Not needed anymore
rm -f $lsd


#
# Never gonna give you up, never gonna let you down, never gonna run around and desert you.
# Never gonna make you cry, never gonna say goodbye, never gonna tell a lie and hurt you.
#


#
# Thanks.
# Merci.
# Hontoni arigato.
#


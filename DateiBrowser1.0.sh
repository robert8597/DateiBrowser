#!/bin/bash
dialog  --colors --no-shadow --no-cancel --no-ok --pause "\ZbWillkommen zu DateiBrowser\ZB

Programm wird gestartet in ..." 9 48 2 
####################--- Schleife des Programms fängt an ---####################
while true;
do

FILE=$(dialog --backtitle "Pfeiltasten zum navigieren nutzen | Auswahl mit 2x Leertaste treffen | Auswahl mit ENTER bestätigen" --no-cancel --colors --stdout --title "\Zu\ZbDatei oder Ordner auswählen\ZB\ZU" --fselect /home/$USER/Schreibtisch  14 48 )

oeDatum=$(date -d "@$( stat -c '%X' "$FILE" )" +'%F %T ') #Zeitpunkt des letzten Öffnens von Datei (DATUM) | stat -c %X nimmt letzte öffnungsdatum | %F=Datum %T=Uhrzeit %z=Zeitzone bei uns +200
LDatum=$(date -d "@$( stat -c '%Y' "$FILE" )" +'%F %T %z') #Zeitpunkt der letzten Änderung von Datei (DATUM)  | stat -c %Y nimmt letzte änderungsdatum| %F=Datum %T=Uhrzeit %z=Zeitzone bei uns +200
Rechte=$(ls -l "$FILE")
Rechte2=${Rechte%???????????????????????????????????????????} #Fragezeichen entfernen die letzten Zeichen, sonst wäre zu viel Info dabei wie Pfad und Datum/Uhrzeit etc.
Dateityp=$(file "$FILE" | cut -d '.' -f2) #cut schneidet vor dem . alles ab, damit nur Dateityp angezeigt wird
Dateiname=$(basename "$FILE") #basename zeigt Dateiname an
bytegroesse=$(stat -c %s "$FILE")
Pfad=${FILE%%$Dateiname}

#################### PRÜFUNG OB AUWAHL EINE DATEI ODER ORDNER IST ####################
if [ -d "$FILE" ]
then
TYP="Ordner"
else 
TYP="Datei"
fi
#############################################################################
#################### Menü ####################
AUSWAHL=$(dialog --colors --menu "\ZbOptionen\ZB" --stdout 14 48 10 "1" "$TYP öffnen" "2" "\Zu$TYP löschen\ZU" "3" "$TYP kopieren" "4" "\Zu$TYP verschieben\ZU" "5" "$TYP Attribute anzeigen" "6" "\ZuErweiterte Optionen\ZU")
clear

case "$AUSWAHL" in
1) 
dialog --colors --msgbox "\Zb$Dateiname\ZB wird geöffnet..." 14 48 
xdg-open "$FILE" 
;;
2) cd $Pfad 
if [ -d "$FILE" ]
then
dialog --colors --title "Sind Sie sicher?" \
--yesno "Wollen Sie \Zb"$Dateiname"\ZB wirklich löschen?" 7 60
antwort=$?
if [ $antwort -eq 0 ]; then
rm -r "$FILE"
dialog --colors --msgbox "Ordner \Zb"$Dateiname"\ZB wurde erfolgreich gelöscht." 14 48
else
dialog --colors --msgbox "Ordner \Zb"$Dateiname"\ZB wurde nicht gelöscht." 14 48
fi
else 
dialog --colors --title "Sind Sie sicher?" \
--yesno "Wollen Sie \Zb"$Dateiname"\ZB wirklich löschen?" 7 60
antwort=$?
if [ $antwort -eq 0 ]; then
rm "$FILE"
dialog --colors --msgbox "Datei \Zb"$Dateiname"\ZB wurde erfolgreich gelöscht." 14 48
else
dialog --colors --msgbox "Datei \Zb"$Dateiname"\ZB wurde nicht gelöscht." 14 48
fi
fi ;;
3) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/$USER/Schreibtisch 14 48 )
cp "$FILE" $Ordner
clear
dialog --colors --msgbox "$TYP \Zb$Dateiname\ZB wurde nach $Pfad kopiert" 14 48;;
4) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/$USER/Schreibtisch 14 48 )
mv "$FILE" $Ordner
clear
dialog --colors --msgbox "$TYP \Zb$Dateiname\ZB wurde nach $Pfad verschoben" 14 48;;
5) 
if [ $bytegroesse -ge 1000000 ]; then
Dateigroesse=$(bc <<< "scale=2;$bytegroesse/1000000")
BYTE="MB"
elif [ $bytegroesse -ge 1000 ]; then
Dateigroesse=$(bc <<< "scale=2;$bytegroesse/1000")
BYTE="kB"  
else
Dateigroesse=$bytegroesse
BYTE="Byte"
fi  
dialog --beep-after --colors --msgbox "\ZbDateiname = \ZB$Dateiname
\Zb\ZuDateityp =\ZB $Dateityp\ZU
\ZbGröße =\ZB $Dateigroesse $BYTE     
\Zb\ZuPfad =\ZB $FILE\ZU
\ZbRechte =\ZB $Rechte2
\Zb\ZuLetzter Zugriff =\ZB  $oeDatum\ZU
\ZbLetzte Änderung  =\ZB $LDatum" 14 48
;; #################### Erweitertes Menü (AUSWAHL2)####################
6)  AUSWAHL2=$(dialog --colors --menu "\ZbErweiterte Optionen\ZB" --stdout 14 48 10 "1" "$TYP umbenennen" "2" "\ZuOrdner erstellen\ZU" "3" "Verzeichnisse vergleichen" "4" "\ZuNeue Datei anlegen\ZU" "5" "Datei finden" "6" "\ZuZIP entpacken\ZU")
clear
case "$AUSWAHL2" in
1) NewName=$(dialog --stdout --inputbox "Neuen Dateinamen bitte eingeben" 14 48 )
cd $Pfad
mv $Dateiname $NewName
dialog --colors --msgbox "$TYP erfolgreich unbenannt in \Zb$NewName\ZB." 14 48;;
2) NewNameOrdner=$(dialog --stdout --inputbox "Neuen Ordnernamen bitte eingeben" 14 48 )
cd $FILE
mkdir $NewNameOrdner
dialog --colors --msgbox "Ordner \Zb$NewNameOrdner\ZB wurde in $Pfad erstellt" 14 48
;; 
3) VergleichsOrdner=$(dialog --title " auswählen" --stdout --title "Zielordner zum vergleichen auswählen" --dselect /home/$USER/ 14 48 )
Vergleich=$(diff -q "$FILE" $VergleichsOrdner)
dialog  --beep --colors --title "\Zb\Zu$FILE\ZB verglichen mit \Zb$VergleichsOrdner\ZU\ZB" --msgbox "$Vergleich" 28 96;;
4) clear
NewNameFile=$(dialog --stdout --inputbox "Dateinamen bitte eingeben" 14 48 )
cd $FILE
touch $NewNameFile
dialog --colors --msgbox "Neue Datei \Zb$NewNameFile\ZB wurde in $Pfad angelegt." 14 48;;
5) searchFile=$(dialog --stdout --inputbox "Dateinamen bitte eingeben" 14 48 )
cd /home
foundFile=$(find -name *$searchFile*)
clear
dialog --colors --title "\Zb $searchFile \ZB wurde in folgenden Ordnern gefunden" --msgbox "
$foundFile" 20 54
;;
6) cd $Pfad 
unzip "$FILE" -d $Pfad
dialog --colors --msgbox "\Zb"$Dateiname"\ZB erfolgreich nach $Pfad entpackt." 14 48;; 
esac
;;
esac
 
dialog --title "EXIT" \
--backtitle "von Gökhan, Dario, Robert" \
--yesno "Wollen sie das Programm beenden ?" 7 60
response=$?
case $response in
   0) break;;
   1) echo "Programm wird weiter ausgeführt";;
   255)  break;;
esac
done
dialog --no-cancel --pause "Wird beendet in ..." 9 48 3
clear


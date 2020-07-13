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
bytegroesse=$(stat -c %s "$FILE") #Variable bytegroesse wird mit der Bytegröße der Zieldatei deklariert.
Pfad=${FILE%%$Dateiname} #Es wird ein Pfad erzeugt indem der Dateiname vom kompletten Quellpfad weggeschnitten wird.

#################### PRÜFUNG OB AUWAHL EINE DATEI ODER ORDNER IST ####################
if [ -d "$FILE" ] #Ist das Ziel($FILE) ein Ordner ?
then
TYP="Ordner"
else 
TYP="Datei"
fi
#############################################################################
#################### Menü ####################
AUSWAHL=$(dialog --colors --menu "\ZbOptionen\ZB" --stdout 14 48 10 "1" "$TYP öffnen" "2" "\Zu$TYP löschen\ZU" "3" "$TYP kopieren" "4" "\Zu$TYP verschieben\ZU" "5" "$TYP Attribute anzeigen" "6" "\ZuErweiterte Optionen\ZU")
clear
#############################################################################

case "$AUSWAHL" in
1) 
dialog --colors --msgbox "\Zb$Dateiname\ZB wird geöffnet..." 14 48 
xdg-open "$FILE" #Ziel wird geöffnet
;;
2) cd $Pfad #Wechseln zum Pfad wo sich die Datei oder der Ordner befindet.
if [ -d "$FILE" ] # Ist das Ziel($FILE) ein Ordner?
then
dialog --colors --title "Sind Sie sicher?" \
--yesno "Wollen Sie \Zb"$Dateiname"\ZB wirklich löschen?" 7 60
antwort=$? #Variable antwort wird mit ja(0) oder nein(1) deklariert.
if [ $antwort -eq 0 ]; then #Wenn Antwort ja ist, bedeutet 0=0
rm -r "$FILE" #Ordner wird gelöscht
dialog --colors --msgbox "Ordner \Zb"$Dateiname"\ZB wurde erfolgreich gelöscht." 14 48
else
dialog --colors --msgbox "Ordner \Zb"$Dateiname"\ZB wurde nicht gelöscht." 14 48
fi
else 
dialog --colors --title "Sind Sie sicher?" \
--yesno "Wollen Sie \Zb"$Dateiname"\ZB wirklich löschen?" 7 60
antwort=$? #Variable antwort wird mit ja(0) oder nein(1) deklariert.
if [ $antwort -eq 0 ]; then #Wenn Antwort ja ist, bedeutet 0=0
rm "$FILE" #Datei wird gelöscht
dialog --colors --msgbox "Datei \Zb"$Dateiname"\ZB wurde erfolgreich gelöscht." 14 48
else
dialog --colors --msgbox "Datei \Zb"$Dateiname"\ZB wurde nicht gelöscht." 14 48
fi
fi ;;
3) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/$USER/Schreibtisch 14 48 )
cp "$FILE" $Ordner #Kopieren von Quelle($FILE) nach Ziel($Ordner)
clear
dialog --colors --msgbox "$TYP \Zb$Dateiname\ZB wurde nach $Pfad kopiert" 14 48;;
4) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/$USER/Schreibtisch 14 48 )
mv "$FILE" $Ordner #Verschieben von Quelle($FILE) nach Ziel($Ordner)
clear
dialog --colors --msgbox "$TYP \Zb$Dateiname\ZB wurde nach $Pfad verschoben" 14 48;;
5) 
if [ $bytegroesse -ge 1000000 ]; then #Wenn Bytegroesse über 1000000 dann wird die Bytegröße / 1000000 geteilt und die Variable BYTE wird mit MB deklariert.
Dateigroesse=$(bc <<< "scale=2;$bytegroesse/1000000")
BYTE="MB"
elif [ $bytegroesse -ge 1000 ]; then #Wenn Bytegroesse unter 1000000 und größer 1000 dann wird die Bytegröße / 1000 geteilt und die Variable BYTE wird mit kB deklariert.
Dateigroesse=$(bc <<< "scale=2;$bytegroesse/1000")
BYTE="kB"  
else #Wenn Bytegroesse unter 1000 ist, dann wird die Variable BYTE mit Byte deklariert.
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
mv $Dateiname $NewName #Ziel wird unbenannt in je nach dem was in die inputbox geschrieben wurde($NewName)
dialog --colors --msgbox "$TYP erfolgreich unbenannt in \Zb$NewName\ZB." 14 48;;
2) NewNameOrdner=$(dialog --stdout --inputbox "Neuen Ordnernamen bitte eingeben" 14 48 )
cd $FILE
mkdir $NewNameOrdner #Es wird ein Ordner namens je nach Eingabe von der inputbox($NewNameOrdner)
dialog --colors --msgbox "Ordner \Zb$NewNameOrdner\ZB wurde in $Pfad erstellt" 14 48
;; 
3) VergleichsOrdner=$(dialog --title " auswählen" --stdout --title "Zielordner zum vergleichen auswählen" --dselect /home/$USER/ 14 48 )
Vergleich=$(diff -q "$FILE" $VergleichsOrdner) #Vergleich zwischen Quelle und dem ausgewählten Zielordner. Anschließende Ausgabe vom Inhalt in einer MessageBox
dialog  --beep --colors --title "\Zb\Zu$FILE\ZB verglichen mit \Zb$VergleichsOrdner\ZU\ZB" --msgbox "$Vergleich" 28 96;;
4) clear
NewNameFile=$(dialog --stdout --inputbox "Dateinamen bitte eingeben" 14 48 )
cd $FILE
touch $NewNameFile #Neue Datei wird erstellt mit dem Namen je nach Eingabe von der inputbox($NewNameFile)
dialog --colors --msgbox "Neue Datei \Zb$NewNameFile\ZB wurde in $Pfad angelegt." 14 48;;
5) searchFile=$(dialog --stdout --inputbox "Dateinamen bitte eingeben" 14 48 )
cd /home
foundFile=$(find -name *$searchFile*) #Gesuchtes Wort aus vorheriger inputbox wird gesucht. Treffer werden in foundFile aufgelistet/deklariert und anschließend über eine MessageBox ausgegeben.
clear
dialog --colors --title "\Zb $searchFile \ZB wurde in folgenden Ordnern gefunden" --msgbox "
$foundFile" 20 54
;;
6) cd $Pfad 
unzip "$FILE" -d $Pfad #Entpacken/Entzippen einer Zieldatei nach Pfad wo sich auch die ZIP befindet.
dialog --colors --msgbox "\Zb"$Dateiname"\ZB erfolgreich nach $Pfad entpackt." 14 48;; 
esac
;;
esac
 
dialog --title "EXIT" \
--backtitle "von Gökhan, Dario, Robert" \
--yesno "Wollen Sie das Programm beenden ?" 7 60 #Frage ob Programm beendet werden soll, bei Ja wird es beendet, bei Nein wird die Schleife von neu angefangen mit Auswahl von einer Datei oder einem Ordner.
response=$?
case $response in
   0) break;;
   1) echo "Programm wird weiter ausgeführt";;
   255)  break;;
esac
done
dialog --no-cancel --pause "Wird beendet in ..." 9 48 3
clear


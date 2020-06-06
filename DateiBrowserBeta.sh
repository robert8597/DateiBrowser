#!/bin/bash
#dialog --title "text" --fselect /path/to/dir height width
function funktion_test() { echo "Hello World"; }
FILE=$(dialog --title "Datei auswählen" --stdout --title "Kopieren/Löschen/Öffnen" --fselect /home/$USER/Schreibtisch 14 48)

oeDatum=$(date -d "@$( stat -c '%X' $FILE )" +'%F %T ') #Letztes Öffnen von Datei DATUM | stat -c %X nimmt letzte öffnungsdatum | %F=Datum %T=Uhrzeit %z=Zeitzone bei uns +200
LDatum=$(date -d "@$( stat -c '%Y' $FILE )" +'%F %T %z') #letzte Änderung DATUM | stat -c %Y nimmt letzte änderungsdatum| %F=Datum %T=Uhrzeit %z=Zeitzone bei uns +200
Rechte=$(ls -l $FILE)
Rechte2=${Rechte%???????????????????????????????????????????} #Fragezeichen entfernen die letzten Zeichen, sonst wäre zu viel Info dabei wie Pfad und Datum/Uhrzeit
Dateityp=$(file $FILE | cut -d '.' -f2) #cut schneidet vor dem . alles ab, damit nur Dateityp angezeigt wird
Dateiname=$(basename $FILE) #basename zeigt Dateiname an
bytegroesse=$(stat -c %s $FILE)


AUSWAHL=$(dialog --menu "AUSWAHL" --stdout 14 48 10 "1" "Datei öffnen" "2" "Datei löschen" "3" "Datei kopieren" "4" "Datei verschieben" "5" "Datei Attribute anzeigen" "6" "Erweiterte Optionen")
clear
echo "$AUSWAHL"
case "$AUSWAHL" in
1) 
echo "Ausgewählte Datei wird geöffnet" 
xdg-open $FILE 
;;
2) rm $FILE
echo "Ausgewählte Datei wurde gelöscht";; #ORDNER -r LÖSCHEN NOCH PROGRAMMIEREN !!!
3) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/$USER/Schreibtisch 14 48 )
cp $FILE $Ordner
clear
echo "Datei wurde kopiert";;
4) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/$USER/Schreibtisch 14 48 )
mv $FILE $Ordner
clear
echo "Datei wurde verschoben";;
5) 
#MB=$(($bytegroesse/1000000))
dialog --beep-after --colors --msgbox "\ZbDateiname = \ZB$Dateiname
\Zb\ZuDateityp =\ZB $Dateityp\ZU
\ZbGröße =\ZB $bytegroesse bytes    
\Zb\ZuPfad =\ZB $FILE\ZU
\ZbRechte =\ZB $Rechte2
\Zb\ZuLetzter Zugriff =\ZB  $oeDatum\ZU
\ZbLetzte Änderung  =\ZB $LDatum" 14 48
;;
6)  AUSWAHL2=$(dialog --menu "AUSWAHL" --stdout 14 48 10 "1" "Datei umbennen" "2" "Ordner erstellen" "3" "Funktion TEST")
clear
echo "$AUSWAHL2"
case "$AUSWAHL2" in
1) clear
NewName=$(dialog --stdout --inputbox "Neuen Dateinamen bitte eingeben" 14 48 )
Pfad=${FILE%%$Dateiname}
cd $Pfad
mv $Dateiname $NewName
echo "Datei erfolgreich unbenannt in $NewName";;
2) NewNameOrdner=$(dialog --stdout --inputbox "Neuen Ordnernamen bitte eingeben" 14 48 )
cd $FILE
mkdir $NewNameOrdner
;;
3) 

funktion_test 

;;
esac
;;
esac
 
 
 
#TestZahl = 1
#echo TestZahl
#if [$AUSWAHL == TestZahl]
#then
#echo "TEzT" 
#xdg-open $FILE
#else
#echo "$AUSWAHL TEST"
#fi
#else
#Funktion_Löschen($FILE)
#fi

#xdg-open $FILE
	
#echo "${FILE} file chosen."

#dialog --yesno "Wollen Sie abbrechen?" 0 0
#0=ja; 1=nein
#Bildschirm löschen
#clear
#Ausgabe auf Konsole
#if b[$antwort = 0]
#then 
#echo "Die Antwort war JA."
#else 
#echo "Die Antwort war NEIN."
#fi

#Funktion_Löschen (FILE) {
#Datei = $FILE
#rm Datei
#}

#FILEi=$FILE
#basename "$FILEi"
#Dateiname="$(basename -- $FILEi)"

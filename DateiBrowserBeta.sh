#!/bin/bash
#dialog --title "text" --fselect /path/to/dir height width

FILE=$(dialog --title "Datei auswählen" --stdout --title "Kopieren/Löschen/Öffnen" --fselect /home/$USER/Schreibtisch 14 48)
oeDatum=$(date -d "@$( stat -c '%X' $FILE )" +'%F %T ') #Letztes Öffnen von Datei DATUM
LDatum=$(date -d "@$( stat -c '%Y' $FILE )" +'%F %T %z') #letzte Änderung DATUM
Rechte=$(ls -l $FILE)
Dateityp=$(file $FILE)

AUSWAHL=$(dialog --menu "AUSWAHL" --stdout 14 48 10 "1" "Datei öffnen" "2" "Datei löschen" "3" "Datei kopieren" "4" "Datei verschieben" "5" "Datei Attribute anzeigen" "6" "Ordner Inhalt anzeigen")
clear
echo "$AUSWAHL"



case "$AUSWAHL" in
1) 
echo "Ausgewählte Datei wird geöffnet" 
xdg-open $FILE 
;;

2) rm $FILE
echo "Ausgewählte Datei wurde gelöscht";;
3) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/$USER/Schreibtisch 14 48 )
cp $FILE $Ordner
clear
echo "Datei wurde kopiert";;
4) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/$USER/Schreibtisch 14 48 )
mv $FILE $Ordner
clear
echo "Datei wurde verschoben";;
5) bytegroesse=$(stat -c %s $FILE)
#MB=$(($bytegroesse/100))
dialog --msgbox "Die Datei ist $bytegroesse bytes groß   
Pfad = $FILE
Letzter Zugriff =  $oeDatum
Letzte Änderung  = $LDatum
Rechte = $Rechte
Dateityp = $Dateityp" 14 48


;;
6)Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/$USER/Schreibtisch 14 48 )
Liste=$(ls -ld $Ordner/*)
echo $Liste

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

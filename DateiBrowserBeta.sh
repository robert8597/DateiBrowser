#!/bin/bash
#dialog --title "text" --fselect /path/to/dir height width

FILE=$(dialog --title "Datei auswählen" --stdout --title "Kopieren/Löschen/Öffnen" --fselect /home/r/Schreibtisch 14 48)


AUSWAHL=$(dialog --menu "AUSWAHL" --stdout 14 48 10 "1" "Datei öffnen" "2" "Datei löschen" "3" "Datei kopieren" "4" "Datei verschieben" "5" "Datei größe anzeigen" "6" "Ordner Inhalt anzeigen")
clear
echo "$AUSWAHL"

case "$AUSWAHL" in
1) echo "Ausgewählte Datei wird geöffnet" 
xdg-open $FILE 
;;
2) rm $FILE
echo "Ausgewählte Datei wurde gelöscht";;
3) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/r/Schreibtisch 14 48 )
cp $FILE $Ordner
clear
echo "Datei wurde kopiert";;
4) Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/r/Schreibtisch 14 48 )
mv $FILE $Ordner
clear
echo "Datei wurde verschoben";;
5) TEST=$(stat -c %s $FILE)
dialog --msgbox "Die Datei ist $TEST Bytes groß" 14 48
echo "Die Datei ist" $TEST "Bytes groß";;
6)Ordner=$(dialog --title " auswählen" --stdout --title "Zielordner auswählen" --dselect /home/r/Schreibtisch 14 48 )
Liste=$(ls -ld $Ordner/*)
echo $Liste
#dialog --title "Ordner" --msgbox "TEST"
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

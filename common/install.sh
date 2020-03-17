FONTDIR=$MODPATH/custom
SYSFONT=$MODPATH/system/fonts
PRDFONT=$MODPATH/system/product/fonts
SYSETC=$MODPATH/system/etc
SYSXML=$SYSETC/fonts.xml
MODPROP=$MODPATH/module.prop

patch() {
	cp $ORIGDIR/system/etc/fonts.xml $SYSXML
	sed -i '/\"sans-serif\">/i \
	<family name="sans-serif">\
		<font weight="100" style="normal">Roboto-Thin.ttf</font>\
		<font weight="100" style="italic">Roboto-ThinItalic.ttf</font>\
		<font weight="300" style="normal">Roboto-Light.ttf</font>\
		<font weight="300" style="italic">Roboto-LightItalic.ttf</font>\
		<font weight="400" style="normal">Roboto-Regular.ttf</font>\
		<font weight="400" style="italic">Roboto-Italic.ttf</font>\
		<font weight="500" style="normal">Roboto-Medium.ttf</font>\
		<font weight="500" style="italic">Roboto-MediumItalic.ttf</font>\
		<font weight="900" style="normal">Roboto-Black.ttf</font>\
		<font weight="900" style="italic">Roboto-BlackItalic.ttf</font>\
		<font weight="700" style="normal">Roboto-Bold.ttf</font>\
		<font weight="700" style="italic">Roboto-BoldItalic.ttf</font>\
	</family>' $SYSXML
	sed -i ':a;N;$!ba; s/name=\"sans-serif\"//2' $SYSXML
}

headline() {
	cp $FONTDIR/hf/*ttf $SYSFONT
	sed -i '/\"sans-serif\">/,/family>/{s/Roboto-M/M/;s/Roboto-B/B/}' $SYSXML
}

body() {
	cp $FONTDIR/bf/*ttf $SYSFONT 
	sed -i '/\"sans-serif\">/,/family>/{s/Roboto-T/T/;s/Roboto-L/L/;s/Roboto-R/R/;s/Roboto-I/I/}' $SYSXML
}

condensed() {
	cp $FONTDIR/cf/*ttf $SYSFONT
	sed -i 's/RobotoC/C/' $SYSXML
}

full() { headline; body; condensed; }

text() {
	if [ $HF -eq 2 ]; then
		cp $FONTDIR/tx/hf/*ttf $SYSFONT
	fi
	if [ $BF -eq 2 ]; then
		cp $FONTDIR/tx/bf/*ttf $SYSFONT
		cp $FONTDIR/tx/cf/*ttf $SYSFONT
	fi
}

bold() {
	cp $SYSFONT/Medium.ttf $SYSFONT/Regular.ttf
	cp $SYSFONT/MediumItalic.ttf $SYSFONT/Italic.ttf
	cp $SYSFONT/Condensed-Medium.ttf $SYSFONT/Condensed-Regular.ttf
	cp $SYSFONT/Condensed-MediumItalic.ttf $SYSFONT/Condensed-Italic.ttf
}

cleanup() {
	rm -rf $FONTDIR
	rmdir -p $SYSETC $PRDFONT
}

pixel() {
	if [ -f /product/fonts/GoogleSans-Regular.ttf ]; then
		DEST=$PRDFONT
	elif [ -f /system/fonts/GoogleSans-Regular.ttf ]; then
		DEST=$SYSFONT
	fi
	if [ ! -z $DEST ]; then
		if [ $HF -eq 2 ]; then
			cp $FONTDIR/tx/bf/Regular.ttf $DEST/GoogleSans-Regular.ttf
			cp $FONTDIR/tx/bf/Italic.ttf $DEST/GoogleSans-Italic.ttf
			cp $SYSFONT/Medium.ttf $DEST/GoogleSans-Medium.ttf
			cp $SYSFONT/MediumItalic.ttf $DEST/GoogleSans-MediumItalic.ttf
			cp $SYSFONT/Bold.ttf $DEST/GoogleSans-Bold.ttf
			cp $SYSFONT/BoldItalic.ttf $DEST/GoogleSans-BoldItalic.ttf
		else
			cp $FONTDIR/px/*ttf $DEST
		fi
		sed -ie 3's/$/-pxl&/' $MODPROP
	fi
}

oxygen() {
	if [ -f /system/fonts/SlateForOnePlus-Regular.ttf ]; then
		cp $SYSFONT/Black.ttf $SYSFONT/SlateForOnePlus-Black.ttf
		cp $SYSFONT/Bold.ttf $SYSFONT/SlateForOnePlus-Bold.ttf
		cp $SYSFONT/Medium.ttf $SYSFONT/SlateForOnePlus-Medium.ttf
		cp $SYSFONT/Regular.ttf $SYSFONT/SlateForOnePlus-Regular.ttf
		cp $SYSFONT/Regular.ttf $SYSFONT/SlateForOnePlus-Book.ttf
		cp $SYSFONT/Light.ttf $SYSFONT/SlateForOnePlus-Light.ttf
		cp $SYSFONT/Thin.ttf $SYSFONT/SlateForOnePlus-Thin.ttf
		sed -ie 3's/$/-oos&/' $MODPROP
	fi
}

miui() {
	if i=$(grep miui $SYSXML); then
		sed -i '/\"miui\"/,/family>/{/700/,/>/s/MiLanProVF/Bold/;/stylevalue=\"400\"/d}' $SYSXML
		sed -i '/\"miui-regular\"/,/family>/{/700/,/>/s/MiLanProVF/Medium/;/stylevalue=\"400\"/d}' $SYSXML
		sed -i '/\"miui-bold\"/,/family>/{/400/,/>/s/MiLanProVF/Medium/;/700/,/>/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro\"/,/family>/{/700/,/>/s/MiLanProVF/Bold/;/stylevalue=\"400\"/d}' $SYSXML
		sed -i '/\"mipro-regular\"/,/family>/{/700/,/>/s/MiLanProVF/Medium/;/stylevalue=\"400\"/d}' $SYSXML
		sed -i '/\"mipro-medium\"/,/family>/{/400/,/>/s/MiLanProVF/Medium/;/700/,/>/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro-demibold\"/,/family>/{/400/,/>/s/MiLanProVF/Medium/;/700/,/>/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro-semibold\"/,/family>/{/400/,/>/s/MiLanProVF/Medium/;/700/,/>/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro-bold\"/,/family>/{/400/,/>/s/MiLanProVF/Bold/;/700/,/>/s/MiLanProVF/Black/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro-heavy\"/,/family>/{/400/,/>/s/MiLanProVF/Black/;/stylevalue/d}' $SYSXML
		if [ $PART -eq 1 ]; then
			sed -i '/\"miui\"/,/family>/{/400/,/>/s/MiLanProVF/Regular/;/stylevalue=\"340\"/d}' $SYSXML
			sed -i '/\"miui-thin\"/,/family>/{/400/,/>/s/MiLanProVF/Thin/;/700/,/>/s/MiLanProVF/Light/;/stylevalue/d}' $SYSXML
			sed -i '/\"miui-light\"/,/family>/{/400/,/>/s/MiLanProVF/Light/;/700/,/>/s/MiLanProVF/Regular/;/stylevalue/d}' $SYSXML
			sed -i '/\"miui-regular\"/,/family>/{/400/,/>/s/MiLanProVF/Regular/;/stylevalue=\"340\"/d}' $SYSXML
			sed -i '/\"mipro\"/,/family>/{/400/,/>/s/MiLanProVF/Regular/;/stylevalue=\"340\"/d}' $SYSXML
			sed -i '/\"mipro-thin\"/,/family>/{/400/,/>/s/MiLanProVF/Thin/;/700/,/>/s/MiLanProVF/Light/;/stylevalue/d}' $SYSXML
			sed -i '/\"mipro-extralight\"/,/family>/{/400/,/>/s/MiLanProVF/Thin/;/700/,/>/s/MiLanProVF/Light/;/stylevalue/d}' $SYSXML
			sed -i '/\"mipro-light\"/,/family>/{/400/,/>/s/MiLanProVF/Light/;/700/,/>/s/MiLanProVF/Regular/;/stylevalue/d}' $SYSXML
			sed -i '/\"mipro-normal\"/,/family>/{/400/,/>/s/MiLanProVF/Light/;/700/,/>/s/MiLanProVF/Regular/;/stylevalue/d}' $SYSXML
			sed -i '/\"mipro-regular\"/,/family>/{/400/,/>/s/MiLanProVF/Regular/;/stylevalue=\"340\"/d}' $SYSXML
			sed -ie 3's/$/-miui&/' $MODPROP
		fi	
		sed -ie 3's/$/-miui&/' $MODPROP
	fi
}

rom() { pixel; oxygen; miui; }

### SELECTIONS ###

OPTION=false
PART=1
HF=1
BF=1
ADVOPT=false
BOLD=false

ui_print "   "
ui_print "- Enable OPTIONS?"
ui_print "  Vol+ = Yes; Vol- = No"
ui_print "   "
if $VKSEL; then
	OPTION=true	
	ui_print "  Selected: Yes"
else
	ui_print "  Selected: No"	
fi

if $OPTION; then
	ui_print "   "
	ui_print "- WHERE to install?"
	ui_print "  Vol+ = Select; Vol- = Ok"
	ui_print "   "
	ui_print "  1. Full"
	ui_print "  2. Headline"
	ui_print "   "
	ui_print "  Select:"
	while true; do
		ui_print "  $PART"
		if $VKSEL; then
			PART=$((PART + 1))
		else 
			break
		fi
		if [ $PART -gt 2 ]; then
			PART=1
		fi
	done
	ui_print "   "
	ui_print "  Selected: $PART"

	ui_print "   "
	ui_print "- Which HEADLINE font style?"
	ui_print "  Vol+ = Select; Vol- = OK"
	ui_print "   "
	ui_print "  1. Default"
	ui_print "  2. Text"
	ui_print "   "
	ui_print "  Select:"
	while true; do
		ui_print "  $HF"
		if $VKSEL; then
			HF=$((HF + 1))
		else 
			break
		fi
		if [ $HF -gt 2 ]; then
			HF=1
		fi
	done
	ui_print "   "
	ui_print "  Selected: $HF"

	if [ $PART -eq 1 ]; then
		ui_print "   "
		ui_print "- Which BODY font style?"
		ui_print "  Vol+ = Select; Vol- = OK"
		ui_print "   "
		ui_print "  1. Default"
		ui_print "  2. Text"
		ui_print "   "
		ui_print "  Select:"
		while true; do
			ui_print "  $BF"
			if $VKSEL; then
				BF=$((BF + 1))
			else 
				break
			fi
			if [ $BF -gt 2 ]; then
				BF=1
			fi
		done
		ui_print "   "
		ui_print "  Selected: $BF"
	fi
fi

if [ $PART -eq 1 ] && $OPTION; then
	ui_print "   "
	ui_print "- Enable ADVANCED options?"
	ui_print "  Vol+ = Yes; Vol- = No"
	ui_print "   "
	if $VKSEL; then
		ADVOPT=true	
		ui_print "  Selected: Yes"
	else
		ui_print "  Selected: No"	
	fi
fi

if $ADVOPT; then

	ui_print "   "
	ui_print "- Use BOLD font?"
	ui_print "  Vol+ = Yes; Vol- = No"
	ui_print "   "
	if $VKSEL; then
		BOLD=true	
		ui_print "  Selected: Yes"
	else
		ui_print "  Selected: No"	
	fi

fi

### INSTALLATION ###
ui_print "   "
ui_print "- Installing"

mkdir -p $SYSFONT $SYSETC $PRDFONT
patch

case $PART in
	1 ) full;;
	2 ) headline; sed -ie 3's/$/-hf&/' $MODPROP;;
esac

case $HF in
	2 ) text; sed -ie 3's/$/-hftxt&/' $MODPROP;;
esac

case $BF in
	2 ) text; sed -ie 3's/$/-bftxt&/' $MODPROP;;
esac

if $BOLD; then
	bold; sed -ie 3's/$/-bold&/' $MODPROP
fi

rom

### CLEAN UP ###
ui_print "- Cleaning up"
cleanup

ui_print "   "

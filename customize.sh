[ ! $MAGISKTMP ] && MAGISKTMP=$(magisk --path)/.magisk
[ -d $MAGISKTMP ] && ORIGDIR=$MAGISKTMP/mirror
FONTDIR=$MODPATH/fonts
SYSFONT=$MODPATH/system/fonts
PRDFONT=$MODPATH/system/product/fonts
SYSETC=$MODPATH/system/etc
SYSXML=$SYSETC/fonts.xml
MODPROP=$MODPATH/module.prop

patch() {
	[ -f $ORIGDIR/system/etc/fonts.xml ] && cp $ORIGDIR/system/etc/fonts.xml $SYSXML || abort "! $ORIGDIR/system/etc/fonts.xml: file not found"
	sed -i '/"sans-serif">/,/family>/H;1,/family>/{/family>/G}' $SYSXML
	sed -i ':a;N;$!ba;s/name="sans-serif"//2' $SYSXML
}

headline() {
	cp $FONTDIR/hf/*ttf $SYSFONT
	sed -i '/"sans-serif">/,/family>/{s/Roboto-M/M/;s/Roboto-B/B/}' $SYSXML
}

body() {
	cp $FONTDIR/bf/*ttf $SYSFONT 
	sed -i '/"sans-serif">/,/family>/{s/Roboto-T/T/;s/Roboto-L/L/;s/Roboto-R/R/;s/Roboto-I/I/}' $SYSXML
}

condensed() {
	cp $FONTDIR/cf/*ttf $SYSFONT
	sed -i 's/RobotoC/C/' $SYSXML
}

full() { headline; body; condensed; }

text() {
	[ $HF -eq 2 ] && cp $FONTDIR/tx/hf/*ttf $SYSFONT
	if [ $BF -eq 2 ]; then
		cp $FONTDIR/tx/bf/*ttf $SYSFONT
		cp $FONTDIR/tx/cf/*ttf $SYSFONT
	fi
}

bold() {
	SRC=$FONTDIR/bf/bd
	[ $BF -eq 2 ] && SRC=$FONTDIR/tx/bf/bd
	if [ $BOLD -eq 1 ]; then cp $SRC/25/*ttf $SYSFONT
	elif [ $BOLD -eq 2 ]; then cp $SRC/50/*ttf $SYSFONT
	else
		sed -i '/"sans-serif">/,/family>/{/400/d;/>Light\./{N;h;d};/MediumItalic/G;/>Black\./{N;h;d};/BoldItalic/G}' $SYSXML
		sed -i '/"sans-serif-condensed">/,/family>/{/400/d;/-Light\./{N;h;d};/MediumItalic/G}' $SYSXML
	fi
}

legible() { cp $FONTDIR/bf/hl/*ttf $SYSFONT; }

rounded() {
	SRC=$FONTDIR/bf/rd
	[ $BF -eq 2 ] && SRC=$FONTDIR/tx/bf/rd
	if [ $BOLD -eq 1 ]; then SRC=$SRC/Regular.25.ttf
	elif [ $BOLD -eq 2 ]; then SRC=$SRC/Regular.50.ttf
	elif $LEGIBLE; then SRC=$SRC/Regular.hl.ttf
	else SRC=$SRC/Regular.ttf
	fi
	cp $SRC $SYSFONT/Regular.ttf
}

clean_up() {
	rm -rf $FONTDIR $MODPATH/LICENSE
	rmdir -p $PRDFONT
}

version() { sed -i 3"s/$/-$1&/" $MODPROP; }

pixel() {
	if [ -f $ORIGDIR/product/fonts/GoogleSans-Regular.ttf ]; then
		DST=$PRDFONT
	elif [ -f $ORIGDIR/system/fonts/GoogleSans-Regular.ttf ]; then
		DST=$SYSFONT
	fi
	if [ $DST ]; then
		if [ $HF -eq 2 ]; then
			set BoldItalic Bold MediumItalic Medium
			for i do cp $SYSFONT/$i.ttf $DST/GoogleSans-$i.ttf; done
			cp $FONTDIR/tx/bf/Regular.ttf $DST/GoogleSans-Regular.ttf
			cp $FONTDIR/tx/bf/Italic.ttf $DST/GoogleSans-Italic.ttf
		else
			cp $FONTDIR/px/*ttf $DST
		fi
		if [ $BOLD -ne 0 ]; then
			if [ $BOLD -eq 3 ]; then
				cp $DST/GoogleSans-Medium.ttf $DST/GoogleSans-Regular.ttf
				cp $DST/GoogleSans-MediumItalic.ttf $DST/GoogleSans-Italic.ttf
			else
				SRC=$FONTDIR/bf/bd
				[ $HF -eq 2 ] && SRC=$FONTDIR/tx/bf/bd
				[ $BOLD -eq 1 ] && SRC=$SRC/25 || SRC=$SRC/50
				cp $SRC/Regular.ttf $DST/GoogleSans-Regular.ttf
				cp $SRC/Italic.ttf $DST/GoogleSans-Italic.ttf
			fi
		fi
		version pxl; PXL=true
	fi
}

oxygen() {
	if [ -f $ORIGDIR/system/fonts/SlateForOnePlus-Regular.ttf ]; then
		set Black Bold Medium Regular Light Thin
		for i do cp $SYSFONT/$i.ttf $SYSFONT/SlateForOnePlus-$i.ttf; done
		cp $SYSFONT/Regular.ttf $SYSFONT/SlateForOnePlus-Book.ttf
		version oos; OOS=true
	fi
}

miui() {
	if grep -q miui $SYSXML; then
		sed -i '/"mipro"/,/family>/{/700/s/MiLanProVF/Bold/;/stylevalue="400"/d}' $SYSXML
		sed -i '/"mipro-regular"/,/family>/{/700/s/MiLanProVF/Medium/;/stylevalue="400"/d}' $SYSXML
		sed -i '/"mipro-medium"/,/family>/{/400/s/MiLanProVF/Medium/;/700/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/"mipro-demibold"/,/family>/{/400/s/MiLanProVF/Medium/;/700/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/"mipro-semibold"/,/family>/{/400/s/MiLanProVF/Medium/;/700/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/"mipro-bold"/,/family>/{/400/s/MiLanProVF/Bold/;/700/s/MiLanProVF/Black/;/stylevalue/d}' $SYSXML
		sed -i '/"mipro-heavy"/,/family>/{/400/s/MiLanProVF/Black/;/stylevalue/d}' $SYSXML
		if [ $PART -eq 1 ]; then
			sed -i '/"mipro"/,/family>/{/400/s/MiLanProVF/Regular/;/stylevalue="340"/d}' $SYSXML
			sed -i '/"mipro-thin"/,/family>/{/400/s/MiLanProVF/Thin/;/700/s/MiLanProVF/Light/;/stylevalue/d}' $SYSXML
			sed -i '/"mipro-extralight"/,/family>/{/400/s/MiLanProVF/Thin/;/700/s/MiLanProVF/Light/;/stylevalue/d}' $SYSXML
			sed -i '/"mipro-light"/,/family>/{/400/s/MiLanProVF/Light/;/700/s/MiLanProVF/Regular/;/stylevalue/d}' $SYSXML
			sed -i '/"mipro-normal"/,/family>/{/400/s/MiLanProVF/Light/;/700/s/MiLanProVF/Regular/;/stylevalue/d}' $SYSXML
			sed -i '/"mipro-regular"/,/family>/{/400/s/MiLanProVF/Regular/;/stylevalue="340"/d}' $SYSXML
		fi	
		version miui; MIUI=true
	fi
}

lg() {
	if grep -q lg-sans-serif $SYSXML; then
		sed -i '/"lg-sans-serif">/,/family>/{/"lg-sans-serif">/!d};/"sans-serif">/,/family>/{/"sans-serif">/!H};/"lg-sans-serif">/G' $SYSXML
		LG=true
	fi
	if [ -f $ORIGDIR/system/etc/fonts_lge.xml ]; then
		cp $ORIGDIR/system/etc/fonts_lge.xml $SYSETC
		LGXML=$SYSETC/fonts_lge.xml
		sed -i '/"default_roboto">/,/family>/{s/Roboto-M/M/;s/Roboto-B/B/}' $LGXML
		if [ $PART -eq 1 ]; then
			sed -i '/"default_roboto">/,/family>/{s/Roboto-T/T/;s/Roboto-L/L/;s/Roboto-R/R/;s/Roboto-I/I/}' $LGXML
			[ $BOLD -eq 3 ] && sed -i '/"default_roboto">/,/family>/{/400/d;/>Light\./{N;h;d};/MediumItalic/G}' $LGXML
		fi
		LG=true
	fi
	$LG && version lg
}

samsung() {
		if grep -q Samsung $SYSXML; then
			sed -i 's/SECRobotoLight-Bold/Medium/' $SYSXML
			[ $PART -eq 1 ] && sed -i 's/SECRobotoLight-//;s/SECCondensed-/Condensed-/' $SYSXML
			version sam; SAM=true
		fi
}

rom() {
	PXL=false; OOS=false; MIUI=false; LG=false; SAM=false
	pixel
	if ! $PXL; then oxygen
		if ! $OOS; then miui
			if ! $MIUI; then lg
				if ! $LG; then samsung
				fi
			fi
		fi
	fi
}

### SELECTIONS ###
OPTION=false
PART=1
HF=1
BF=1
BOLD=0
LEGIBLE=false
ROUNDED=false

. $FONTDIR/selector.sh

if [ $SEL ]; then
	OPTION=true	
	ui_print "  "
	ui_print "! You enabled CUSTOMIZATIONS"
	sleep 1
fi

if $OPTION; then

	ui_print "  "
	ui_print "- WHERE to install?"
	ui_print "  $KEY1 = Next Option; $KEY2 = Ok"
	ui_print "  "
	ui_print "  1. Full"
	ui_print "  2. Headline"
	ui_print "  "
	ui_print "  Select:"
	while true; do
		ui_print "  $PART"
		$SEL && PART=$((PART + 1)) || break
		[ $PART -gt 2 ] && PART=1
	done
	ui_print "  "
	ui_print "  Selected: $PART"
	sleep 0.5

	ui_print "  "
	ui_print "- Which HEADLINE font style?"
	ui_print "  $KEY1 = Next Option; $KEY2 = OK"
	ui_print "  "
	ui_print "  1. Default"
	ui_print "  2. Text"
	ui_print "  "
	ui_print "  Select:"
	while true; do
		ui_print "  $HF"
		$SEL && HF=$((HF + 1)) || break
		[ $HF -gt 2 ] && HF=1
	done
	ui_print "  "
	ui_print "  Selected: $HF"
	sleep 0.5

	if [ $PART -eq 1 ]; then

		ui_print "  "
		ui_print "- Which BODY font style?"
		ui_print "  $KEY1 = Next Option; $KEY2 = OK"
		ui_print "  "
		ui_print "  1. Default"
		ui_print "  2. Text"
		ui_print "  "
		ui_print "  Select:"
		while true; do
			ui_print "  $BF"
			$SEL && BF=$((BF + 1)) || break
			[ $BF -gt 2 ] && BF=1
		done
		ui_print "  "
		ui_print "  Selected: $BF"
		sleep 0.5

		ui_print "  "
		ui_print "- Use BOLD font?"
		ui_print "  $KEY1 = Yes; $KEY2 = No"
		ui_print "  "
		$SEL && { BOLD=1; ui_print "  Selected: Yes"; } ||  ui_print "  Selected: No"
		sleep 0.5

		if [ $BOLD -eq 1 ]; then
			ui_print "  "
			ui_print "- How much BOLD?"
			ui_print "  $KEY1 = Next Option; $KEY2 = OK"
			ui_print "  "
			ui_print "  1. Light"
			ui_print "  2. Medium"
			[ $HF -eq $BF ] && ui_print "  3. Strong"
			ui_print "  "
			ui_print "  Select:"
			while true; do
				ui_print "  $BOLD"
				$SEL && BOLD=$((BOLD + 1)) || break
				(( [ $BOLD -gt 2 ] && [ $HF -ne $BF ] ) || [ $BOLD -gt 3 ] ) && BOLD=1
			done
			ui_print "  "
			ui_print "  Selected: $BOLD"
			sleep 0.5
		fi

		if [ $BF -eq 1 ] && [ $BOLD -eq 0 ]; then
			ui_print "  "
			ui_print "- High Legibility?"
			ui_print "  $KEY1 = Yes; $KEY2 = No"
			ui_print "  "
			$SEL && { LEGIBLE=true; ui_print "  Selected: Yes"; } || ui_print "  Selected: No"	
			sleep 0.5
		fi

		if [ $BOLD -ne 3 ]; then
			ui_print "  "
			ui_print "- Rounded Corners?"
			ui_print "  $KEY1 = Yes; $KEY2 = No"
			ui_print "  "
			$SEL && { ROUNDED=true; ui_print "  Selected: Yes"; } || ui_print "  Selected: No"	
			sleep 0.5
		fi

	fi #PART1
	ui_print "  "
fi #OPTIONS

### INSTALLATION ###
ui_print "- Installing"
mkdir -p $SYSFONT $SYSETC $PRDFONT
patch
[ $PART -eq 1 ] && full || { headline; version hf; }
[ $HF -eq 2 ] && { text; version hftxt; }
[ $BF -eq 2 ] && { text; version bftxt; }
[ $BOLD -ne 0 ] && { bold; version bld; }
$LEGIBLE && { legible; version lgbl; }
$ROUNDED && { rounded; version rnd; }
rom

### CLEAN UP ###
ui_print "- Cleaning up"
clean_up

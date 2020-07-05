i=$(getevent -qc 30) &
sleep 0.5; pkill getevent || { . $FONTDIR/volkey.sh; return; }

i=$(timeout 2 getevent -qc 30) && SEL=selector || return

KEY1=Tap; KEY2=Swipe

swipe() { i=$(getevent -qc 30) && touch swipe; }

tap() { i=$(getevent -qc 5) && touch tap; }

selector() {
	rm swipe tap
	tap &
	swipe &
	while true; do
		[ -f tap ] && break
	done
	sleep 0.5
	pkill getevent
	[ -f swipe ] && return 1 || return 0
}

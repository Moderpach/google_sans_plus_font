swipe() {
	if getevent -qc30 >/dev/null; then
		touch swipe
	fi
}

tap() {
	if getevent -qc5 >/dev/null; then
		touch tap
	fi
}

selector() {
	rm swipe tap
	tap &
	swipe &
	while true; do
		if [ -f tap ]; then
		sleep 0.5
		pkill getevent
		if [ -f swipe ]; then
			return 1
			break
		else 
			return 0
			break
		fi
		fi
	done
}

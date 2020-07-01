if (timeout 3 getevent -qc50 >/dev/null); then
	SEL=selector
else
	return
fi

swipe() {
	if (getevent -qc30 >/dev/null); then
		touch swipe
	fi
}

tap() {
	if (getevent -qc5 >/dev/null); then
		touch tap
	fi
}

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

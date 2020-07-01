if i=$(timeout 3 getevent -qc50); then
	SEL=selector
else
	return
fi

swipe() {
	if i=$(getevent -qc30); then
		touch swipe
	fi
}

tap() {
	if i=$(getevent -qc5); then
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

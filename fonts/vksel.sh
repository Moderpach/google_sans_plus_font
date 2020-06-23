chooseport() {
  if [ $(/system/bin/getevent -lc 20 2>&1 | /system/bin/grep -cm2 'TOUCH.*DOWN') -eq 2 ]; then
	sleep 0.2
    return 1
  else
	sleep 0.2
    return 0
  fi
}

if (timeout 3 /system/bin/getevent -c 50 &>/dev/null); then
   	VKSEL=chooseport
fi

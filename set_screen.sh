#! /bin/bash
: <<!
  设置屏幕分辨率的脚本(xrandr命令的封装)
!

INNER_PORT=eDP-1
MODE=TB

__setbg() {
	feh --randomize --bg-fill ~/Pictures/wallpaper/*.png
}
# TODO: 设置除TD之外的模式的pos
__get_inner_view() {
	case "$MODE" in
	ONE) echo "--output $INNER_PORT --mode 2560x1600 --pos 0x0" ;;
	LR) echo "--output $INNER_PORT --mode 2560x1600  --pos 0x328" ;;
	TB) echo "--output $INNER_PORT --mode 2560x1600  --pos 0x1440" ;;
	HLR) echo "--output $INNER_PORT --mode 2560x1600 --pos 2560x320" ;;
	HTB) echo "--output $INNER_PORT --mode 2560x1600 --pos 500x1080" ;;
	esac
}

__get_outer_view() {
	outport=$1
	case "$MODE" in
	LR) echo "--output $outport --mode 2560x1440 --scale 0.9999x0.9999 --pos 2560x0 --primary" ;;
	TB) echo "--output $outport --mode 2560x1440  --pos 0x0 --primary" ;;
	HLR) echo "--output $outport --mode 2560x1440  --scale 0.9999x0.9999 --pos 0x0 --primary" ;;
	HTB) echo "--output $outport --mode 2560x1440  --scale 0.9999x0.9999 --pos 0x0 --primary" ;;
	esac
}

__get_off_views() {
	for sc in $(xrandr | grep 'connected' | awk '{print $1}'); do echo "--output $sc --off "; done
}

one() {
	MODE=ONE
	xrandr $(__get_off_views) $(__get_inner_view)
	__setbg
}

two() {
	OUTPORT_CONNECTED=$(xrandr | grep -v $INNER_PORT | grep -w 'connected' | awk '{print $1}')
	[ ! "$OUTPORT_CONNECTED" ] && one && return

	xrandr $(__get_off_views) $(__get_inner_view) $(__get_outer_view $OUTPORT_CONNECTED)
	__setbg
}

check() {
	CONNECTED_PORTS=$(xrandr | grep -w 'connected' | awk '{print $1}' | wc -l)
	CONNECTED_MONITORS=$(xrandr --listmonitors | sed 1d | awk '{print $4}' | wc -l)
	[ $CONNECTED_PORTS -gt $CONNECTED_MONITORS ] && two
	[ $CONNECTED_PORTS -lt $CONNECTED_MONITORS ] && one
}

case $1 in
one) one ;;
two) two ;;
*) check ;;
esac

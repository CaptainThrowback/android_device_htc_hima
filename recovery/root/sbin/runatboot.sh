#!/sbin/sh

bootmid=$(getprop ro.boot.mid)

case $bootmid in
	"0PJA20000")
		## m9whl (himawhl) ##
		resetprop ro.build.product "htc_himawhl"
		resetprop ro.product.device "htc_himawhl"
		resetprop ro.product.model "0PJA2"
		;;
	"0PJA30000")
		## m9wl (himawl) ##
		resetprop ro.build.product "htc_himawl"
		resetprop ro.product.device "htc_himawl"
		resetprop ro.product.model "HTC6535LVW"
		;;
	*)
		## m9ul (himaul) ##
		resetprop ro.build.product "htc_himaul"
		resetprop ro.product.device "htc_himaul"
		;;
esac

exit 0
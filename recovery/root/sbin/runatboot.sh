#!/sbin/sh

SCRIPTNAME="VendorInit"
LOGFILE=/tmp/recovery.log

log_info()
{
	echo "I:$SCRIPTNAME:"$1 >> $LOGFILE
}

log_error()
{
	echo "E:$SCRIPTNAME:"$1 >> $LOGFILE
}

bootmid=$(getprop ro.boot.mid)
bootcid=$(getprop ro.boot.cid)
device=$(getprop ro.product.device)
model=$(getprop ro.product.model)
product=$(getprop ro.build.product)

log_info "Updating device properties based on MID and CID..."
log_info "MID Found: $bootmid"
log_info "CID Found: $bootcid"

case $bootmid in
	"0PJA20000")
		## m9whl (himawhl) ##
		log_info "Current product: $product"
		resetprop ro.build.product "htc_himawhl"
		product=$(getprop ro.build.product)
		log_info "New product: $product"
		log_info "Current device: $device"
		resetprop ro.product.device "htc_himawhl"
		device=$(getprop ro.product.device)
		log_info "New device: $device"
		log_info "Current model: $model"
		resetprop ro.product.model "0PJA2"
		model=$(getprop ro.product.model)
		log_info "New model: $model"
		;;
	"0PJA30000")
		## m9wl (himawl) ##
		log_info "Current product: $product"
		resetprop ro.build.product "htc_himawl"
		log_info "New product: $product"
		log_info "Current device: $device"
		resetprop ro.product.device "htc_himawl"
		device=$(getprop ro.product.device)
		log_info "New device: $device"
		log_info "Current model: $model"
		resetprop ro.product.model "HTC6535LVW"
		model=$(getprop ro.product.model)
		log_info "New model: $model"
		;;
	*)
		## m9ul (himaul) ##
		log_error "MID not found. Setting default values."
		log_info "Current product: $product"
		resetprop ro.build.product "htc_himaul"
		product=$(getprop ro.build.product)
		log_info "New product: $product"
		log_info "Current device: $device"
		resetprop ro.product.device "htc_himaul"
		device=$(getprop ro.product.device)
		log_info "New device: $device"
		log_info "Current model: $model"
		;;
esac

exit 0
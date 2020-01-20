#!/sbin/sh

SCRIPTNAME="SAR_Check"
LOGFILE=/tmp/recovery.log
TEMPSYS=/s
BUILDPROP=build.prop

log_info()
{
	echo "I:$SCRIPTNAME:$1" >> "$LOGFILE"
}

log_error()
{
	echo "E:$SCRIPTNAME:$1" >> "$LOGFILE"
}

temp_mount()
{
	if [ -e "$3" ]; then
		log_info "$2 partition found at $3."
		mkdir "$1"
		if [ -d "$1" ]; then
			log_info "Temporary $2 folder created at $1."
		else
			log_error "Unable to create temporary $2 folder."
			finish_error
		fi
		mount -t ext4 -o ro "$3" "$1"
		if [ -n "$(ls -A "$1" 2>/dev/null)" ]; then
			log_info "$2 mounted at $1."
		else
			log_error "Unable to mount $2 to temporary folder."
			finish_error
		fi
	else
		log_error "$2 partition not found at $3. Proceeding to next step."
	fi
}

finish()
{
	umount "$TEMPSYS"
	rmdir "$TEMPSYS"
	log_info "Script complete. Booting into TWRP."
	start recovery
	exit 0
}

finish_error()
{
	umount "$TEMPSYS"
	rmdir "$TEMPSYS"
	log_error "No actions taken. Booting into TWRP."
	start recovery
	exit 0
}

# Do not run script or start recovery if offmode charging
bootmode=$(getprop ro.bootmode)
if [ "$bootmode" = "offmode_charging" ]; then
	exit 0
fi

log_info "Running system-as-root (SAR) detection script for TWRP..."

suffix=$(getprop ro.boot.slot_suffix)
suf=$(getprop ro.boot.slot)

if [ -n "$suffix" ]; then
	log_info "A/B device detected! Updated paths with slot information..."
elif [ -n "$suf" ]; then
	log_info "A/B device detected! Updated paths with slot information..."
	suffix="_$suf"
else
	log_info "A-only device detected! Updating paths to exclude slot information..."
fi

syspath="/dev/block/bootdevice/by-name/system$suffix"

temp_mount "$TEMPSYS" "system" "$syspath"

if [ -f "$TEMPSYS/$BUILDPROP" ]; then
	log_info "Build.prop found at /system/$BUILDPROP. Device uses legacy system setup."
	log_info "Setting up TWRP for legacy system and starting recovery..."
	rm -rf /system_root
	finish
elif [ -f "$TEMPSYS/system/$BUILDPROP" ]; then
	log_info "Build.prop found at /system_root/system/$BUILDPROP. Device uses SAR setup."
	log_info "Setting up TWRP for SAR and starting recovery..."
	setprop ro.build.system_root_image true
	sed -i 's;^/system\t;/system_root\t;g' /etc/recovery.fstab
	rm -rf /system
	ln -s /system_root/system /system
	finish
else
	log_error "Build.prop not found. No OS installed?"
	log_error "Defaulting to legacy system setup..."
	finish_error
fi

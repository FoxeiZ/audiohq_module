MODDIR=${0%/*}

mkdir -p /data/misc/audiohq

#setenforce 0

audiohq --service --force

setup() {
    if [ -n "`getprop init.svc.audioserver`" ]; then
        setprop ctl.restart audioserver
        sleep 1.2
        if [ "`getprop init.svc.audioserver`" != "running" ]; then
            # workaround for Android 12 old devices hanging up the audioserver after "setprop ctl.restart audioserver" is executed
            local pid="`getprop init.svc_debug_pid.audioserver`"
            if [ -n "$pid" ]; then
                kill -HUP $pid 1>&2
            fi
        fi
    fi

    elif [ "`getprop ro.system.build.version.release`" -ge "12" ]; then
        if [ -n "`getprop init.svc.audioserver`" ]; then
            setprop ctl.restart audioserver
            sleep 1.2
            if [ "`getprop init.svc.audioserver`" != "running" ]; then
                # workaround for Android 12 old devices hanging up the audioserver after "setprop ctl.restart audioserver" is executed
                local pid="`getprop init.svc_debug_pid.audioserver`"
                if [ -n "$pid" ]; then
                    kill -HUP $pid 1>"/dev/null" 2>&1
                fi
            fi
        fi
    fi
}

(
    setup 2>/dev/null
)&

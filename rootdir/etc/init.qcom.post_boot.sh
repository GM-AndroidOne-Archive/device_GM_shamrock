#! /vendor/bin/sh

target=`getprop ro.board.platform`

case "$target" in
    "msm8952")
        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi

        case "$soc_id" in
            "264" | "289")
                # HMP scheduler base defaults
                echo 3 > /proc/sys/kernel/sched_window_stats_policy
                echo 3 > /proc/sys/kernel/sched_ravg_hist_size
                echo 20000000 > /proc/sys/kernel/sched_ravg_window
                echo 20 > /proc/sys/kernel/sched_small_task

                for cpu in 0 1 2 3 4 5 6 7; do
                    [ -e /sys/devices/system/cpu/cpu${cpu}/sched_mostly_idle_load ] && \
                        echo 30 > /sys/devices/system/cpu/cpu${cpu}/sched_mostly_idle_load
                    [ -e /sys/devices/system/cpu/cpu${cpu}/sched_mostly_idle_nr_run ] && \
                        echo 3 > /sys/devices/system/cpu/cpu${cpu}/sched_mostly_idle_nr_run
                    [ -e /sys/devices/system/cpu/cpu${cpu}/sched_prefer_idle ] && \
                        echo 0 > /sys/devices/system/cpu/cpu${cpu}/sched_prefer_idle
                done

                # PowerHAL controls sched_boost during boosts.
                echo 0 > /proc/sys/kernel/sched_boost

                echo 93 > /proc/sys/kernel/sched_upmigrate
                echo 83 > /proc/sys/kernel/sched_downmigrate

                # Devfreq / bandwidth governors
                for devfreq_gov in /sys/class/devfreq/*qcom,mincpubw*/governor; do
                    [ -e "$devfreq_gov" ] && echo "cpufreq" > "$devfreq_gov"
                done
                for devfreq_gov in /sys/class/devfreq/*qcom,cpubw*/governor; do
                    [ -e "$devfreq_gov" ] && echo "bw_hwmon" > "$devfreq_gov"
                done
                for cpu_io_percent in /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/io_percent; do
                    [ -e "$cpu_io_percent" ] && echo 20 > "$cpu_io_percent"
                done
                for cpu_guard_band in /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/guard_band_mbps; do
                    [ -e "$cpu_guard_band" ] && echo 30 > "$cpu_guard_band"
                done
                for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent; do
                    [ -e "$gpu_bimc_io_percent" ] && echo 40 > "$gpu_bimc_io_percent"
                done

                [ -e /sys/module/msm_thermal/core_control/enabled ] && \
                    echo 0 > /sys/module/msm_thermal/core_control/enabled

                # Governor base tune: policy cpu0
                if [ -d /sys/devices/system/cpu/cpu0/cpufreq/interactive ]; then
                    echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
                    echo "19000 1113600:39000" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
                    echo 85 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
                    echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
                    echo 1113600 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
                    echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
                    echo "1 960000:85 1113600:90 1344000:80" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
                    echo 40000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
                    echo 40000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/sampling_down_factor
                    echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
                    echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
                    echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
                fi

                # Governor base tune: policy cpu4
                if [ -d /sys/devices/system/cpu/cpu4/cpufreq/interactive ]; then
                    echo "interactive" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
                    echo 39000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
                    echo 90 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
                    echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
                    echo 806400 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
                    echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
                    echo "1 806400:90" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
                    echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
                    echo 40000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/sampling_down_factor
                    echo 806400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
                    echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
                    echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
                fi

                echo 50000 > /proc/sys/kernel/sched_freq_inc_notify
                echo 50000 > /proc/sys/kernel/sched_freq_dec_notify

                # Dual core_ctl boot defaults.
                # PowerHAL will dynamically change these after boot.
                if [ -d /sys/devices/system/cpu/cpu0/core_ctl ]; then
                    echo 2 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
                    echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/max_cpus
                    echo 72 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
                    echo 35 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
                    echo 1000 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
                    echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/is_big_cluster
                fi

                if [ -d /sys/devices/system/cpu/cpu4/core_ctl ]; then
                    echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
                    echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/max_cpus
                    echo 78 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
                    echo 35 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
                    echo 1000 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
                    echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster
                fi

                [ -e /sys/module/msm_thermal/core_control/enabled ] && \
                    echo 1 > /sys/module/msm_thermal/core_control/enabled

                [ -e /sys/module/lpm_levels/parameters/sleep_disabled ] && \
                    echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
                [ -e /sys/module/lpm_levels/lpm_workarounds/dynamic_clock_gating ] && \
                    echo 1 > /sys/module/lpm_levels/lpm_workarounds/dynamic_clock_gating
                [ -e /proc/sys/kernel/power_aware_timer_migration ] && \
                    echo 1 > /proc/sys/kernel/power_aware_timer_migration

                restorecon -R /sys/devices/system/cpu
            ;;
        esac
    ;;
esac

chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate 2>/dev/null
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor 2>/dev/null
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy 2>/dev/null

emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot" in
    "true")
        chown -h system /sys/devices/platform/rs300000a7.65536/force_sync 2>/dev/null
        chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts 2>/dev/null
        chown -h system /sys/devices/platform/rs300100a7.65536/force_sync 2>/dev/null
        chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts 2>/dev/null
    ;;
esac

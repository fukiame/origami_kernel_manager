#!/data/data/com.termux/files/usr/bin/bash

# CPU info
export chipset=$(grep "Hardware" /proc/cpuinfo | uniq | cut -d ':' -f 2 | sed 's/^[ \t]*//')

if [ -z "$chipset" ]; then
	export chipset=$(getprop "ro.hardware")
fi

if [[ $chipset == *MT* || $chipset == *mt* ]]; then
	export soc=Mediatek
elif [[ $chipset == *MSM* || $chipset == *QCOM* || $chipset == *msm* || $chipset == *qcom* ]]; then
	export soc=Qualcomm
elif [[ $chipset == *exynos* ]]; then
	export soc=Exynos
else
	export soc=unknown
fi

cores=$(($(nproc --all) - 1 ))

if [ -f /sys/devices/system/cpu/cputopo/is_big_little ]; then
	export is_big_little=1

	# Get the number of clusters
	nr_clusters=$(cat /sys/devices/system/cpu/cputopo/nr_clusters)

    # Associative array to store CPUs in clusters
    declare -A clusters

    # Loop through each CPU core
    for cpu_dir in /sys/devices/system/cpu/cpu[0-${cores}]*; do
	    core_id=$(basename "$cpu_dir")
	    chmod 0644 ${cpu_dir}/online
	    echo 1 > ${cpu_dir}/online
	    if [ -f "$cpu_dir/topology/physical_package_id" ]; then
		    core_cluster=$(chmod +r "$cpu_dir/topology/physical_package_id" && cat "$cpu_dir/topology/physical_package_id")
		    clusters[$core_cluster]+=" $core_id"
	    else
		    echo "error: Cannot determine cluster for $core_id" && exit 1
	    fi
    done

    export cluster0=${clusters[0]}
    export cluster1=${clusters[1]}
    if [[ $nr_clusters == 3 ]]; then
	    export cluster2=${clusters[2]}
    fi
else
	export is_big_little=0
fi

# GPU info
gpu=$(dumpsys SurfaceFlinger | grep GLES | awk -F ': ' '{print $2}')

if [ ! -d /sys/kernel/gpu ] && [ ! -d /proc/gpufreq ]; then
is_gpu_unsupported=1
fi

# eMMC/UFS Storage Info
storage_pre_eol=$(cat $(find /sys/devices/platform -type f -name "pre_eol_info") 2>/dev/null)
storage_codename=$(cat $(find $(dirname $(find /sys/devices/platform -type f -name "pre_eol_info")) -type f -name "name") 2>/dev/null)
storage_manfid=$(cat $(find /sys/devices/platform -type f -name "manfid") 2>/dev/null | head -n 1)

JSON_MANFID='[
    {"id": "0x000013", "name": "Micron"},
    {"id": "0x000015", "name": "Samsung"},
    {"id": "0x000090", "name": "Hynix"},
    {"id": "0x000045", "name": "Sandisk"},
    {"id": "0x000011", "name": "Toshiba"},
    {"id": "0x000070", "name": "Kingston"},
    {"id": "0x000074", "name": "Transcend"},
    {"id": "0x0000FE", "name": "Micron"},
    {"id": "0x000088", "name": "Foresee"}
]'

storage_manufacturer=$(echo "$JSON_MANFID" | jq -r ".[] | select(.id == \"$storage_manfid\") | .name")

case $storage_pre_eol in
0x00) export storage_status="Undefined" ;;
0x01) export storage_status="Normal" ;;
0x02) export storage_status="Warning" ;;
0x03) export storage_status="Urgent" ;;
*) export storage_status="Probably die" ;;
esac
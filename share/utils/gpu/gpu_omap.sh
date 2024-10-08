#!/data/data/com.termux/files/usr/bin/bash
# This file is part of Origami Kernel Manager.
#
# Origami Kernel Manager is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Origami Kernel Manager is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Origami Kernel Manager.  If not, see <https://www.gnu.org/licenses/>.
#
# Copyright (C) 2023-2024 Rem01Gaming

gpu_omap_set_max_freq() {
	if [[ $1 == "-exec" ]]; then
		local freq=$2
	else
		local freq=$(fzf_select "$gpu_available_freqs" "Select max freq: ")
		command2db gpu.omap.max_freq "gpu_omap_set_max_freq -exec $freq" FALSE
	fi
	apply $freq $gpu_max_freq_path
}

gpu_omap_set_gov() {
	if [[ $1 == "-exec" ]]; then
		local selected_gov=$2
	else
		local selected_gov=$(fzf_select "$gpu_available_governors" "Select Governor: ")
		command2db gpu.omap.governor "gpu_omap_set_gov -exec $selected_gov" FALSE
	fi
	apply $selected_gov $gpu_governor_path
}

gpu_omap_menu() {
	gpu_available_freqs="$(cat /sys/devices/platform/omap/pvrsrvkm.0/sgxfreq/frequency_list)"
	gpu_min_freq="$(cat /sys/devices/platform/omap/pvrsrvkm.0/sgxfreq/frequency_list | head -n 1)"
	gpu_max_freq_path="/sys/devices/platform/omap/pvrsrvkm.0/sgxfreq/frequency_limit"
	gpu_available_governors="$(cat /sys/devices/platform/omap/pvrsrvkm.0/sgxfreq/governor_list)"
	gpu_governor_path="/sys/devices/platform/omap/pvrsrvkm.0/sgxfreq/governor"

	while true; do
		clear
		echo -e "\e[30;48;2;254;228;208m Origami Kernel Manager ${VERSION}$(printf '%*s' $((LINE - 30)) '')\033[0m"
		echo -e "\e[38;2;254;228;208m"
		echo -e "    _________      [] GPU: ${gpu}" | cut -c 1-${LINE}
		echo -e "   /        /\\     [] GPU Scalling freq: $(cat $gpu_min_freq)KHz - $(cat $gpu_max_freq_path)KHz" | cut -c 1-${LINE}
		echo -e "  /        /  \\    [] GPU Governor: $(cat $gpu_governor_path)"
		echo -e ' /        /    \   '
		echo -e '/________/      \  '
		echo -e '\        \      /  '
		echo -e ' \        \    /   '
		echo -e '  \        \  /    '
		echo -e '   \________\/     '
		echo -e "\n//////////////"
		echo -e "$(printf '─%.0s' $(seq 1 $LINE))\n"
		echo -e "[] GPU Control\033[0m"

		tput civis

		case $(fzy_select "Set max freq\nSet min freq\nSet Governor\nBack to main menu" "") in
		"Set max freq") gpu_omap_set_max_freq ;;
		"Set Governor") gpu_omap_set_gov ;;
		"Back to main menu") break ;;
		esac
	done
}

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

gpu_generic_set_freq() {
	case $1 in
	max) local node_path=$gpu_max_freq_path ;;
	min) local node_path=$gpu_min_freq_path ;;
	esac
	apply $(fzf_select "$gpu_available_freqs" "Select ${1} freq: ") $node_path
}

gpu_generic_set_gov() {
	apply $(fzf_select "$gpu_available_governors" "Select Governor: ") $gpu_governor_path
}

gpu_generic_menu() {
	gpu_available_freqs="$(cat /sys/kernel/gpu/gpu_freq_table)"
	gpu_min_freq_path="/sys/kernel/gpu/gpu_min_clock"
	gpu_max_freq_path="/sys/kernel/gpu/gpu_max_clock"
	gpu_available_governors="$(cat /sys/kernel/gpu/gpu_available_governor)"
	gpu_governor_path="/sys/kernel/gpu/gpu_governor"

	while true; do
		clear
		echo -e "\e[30;48;2;254;228;208m Origami Kernel Manager ${VERSION}$(printf '%*s' $((LINE - 30)) '')\033[0m"
		echo -e "\e[38;2;254;228;208m"
		echo -e "    _________      [] GPU: ${gpu}" | cut -c 1-${LINE}
		echo -e "   /        /\\     [] GPU Scalling freq: $(cat $gpu_min_freq_path) - $(cat $gpu_max_freq_path)" | cut -c 1-${LINE}
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
		"Set max freq") gpu_generic_set_freq max ;;
		"Set min freq") gpu_generic_set_freq min ;;
		"Set Governor") gpu_generic_set_gov ;;
		"Back to main menu") break ;;
		esac
	done
}

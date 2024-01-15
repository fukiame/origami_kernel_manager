#!/data/data/com.termux/files/usr/bin/bash

mtk_videox_livedisplay() {
	R=$(cat /sys/devices/platform/mtk_disp_mgr.0/rgb | awk '{print $1}')
	G=$(cat /sys/devices/platform/mtk_disp_mgr.0/rgb | awk '{print $2}')
	B=$(cat /sys/devices/platform/mtk_disp_mgr.0/rgb | awk '{print $3}')
	curr_color="R"

    clear
	echo -e "MTK Videox Livedisplay"
	echo -e "Display color control for Mediatek devices\n"
	echo -e "Use ( ↑ ↓ ) to increase or decrease value\nUse ( ← → ) to move\nUse HOME or END to exit\n"
	echo -e "$(color_blocks)\n"
	echo -e "${RED}Red\t${GREEN}Green\t${BLUE}Blue${NOCOLOR}"

	print_colors() {
		printf "\r%s\t%s\t%s" "$R" "$G" "$B"

		if [ "$curr_color" = "R" ]; then
			printf "\n\r%s\t%s\t%s" "^" " " " "
		elif [ "$curr_color" = "G" ]; then
			printf "\n\r%s\t%s\t%s" " " "^" " "
		else
			printf "\n\r%s\t%s\t%s" " " " " "^"
		fi

# Make the cursor invisible
tput civis
# moves the cursor up one line
tput cuu1
# stores the positon of cursor
tput sc
}

while true; do
	print_colors
	read -r -sN3 t
	case "${t:2:1}" in
		A)
			if [ "$curr_color" = "R" ] && ((R < 2000)); then
				((R++))
			elif [ "$curr_color" = "G" ] && ((G < 2000)); then
				((G++))
			elif [ "$curr_color" = "B" ] && ((B < 2000)); then
				((B++))
			fi
			;;
		B)
			if [ "$curr_color" = "R" ] && ((R > 1)); then
				((R--))
			elif [ "$curr_color" = "G" ] && ((G > 1)); then
				((G--))
			elif [ "$curr_color" = "B" ] && ((B > 1)); then
				((B--))
			fi
			;;
		C)
			if [ "$curr_color" = "R" ]; then
				curr_color="G"
			elif [ "$curr_color" = "G" ]; then
				curr_color="B"
			else
				curr_color="R"
			fi
			;;
		D)
			if [ "$curr_color" = "R" ]; then
				curr_color="B"
			elif [ "$curr_color" = "G" ]; then
				curr_color="R"
			else
				curr_color="G"
			fi
			;;
		*) break ;;
	esac

	echo $R $G $B > /sys/devices/platform/mtk_disp_mgr.0/rgb 2>/dev/null
done

# Normalize cursor
echo -e "\n"
tput cnorm
}

qcom_kcal() {
	R=$(cat /sys/devices/platform/kcal_ctrl.0/kcal | awk '{print $1}')
	G=$(cat /sys/devices/platform/kcal_ctrl.0/kcal | awk '{print $2}')
	B=$(cat /sys/devices/platform/kcal_ctrl.0/kcal | awk '{print $3}')
	invert=$(cat /sys/devices/platform/kcal_ctrl.0/kcal_invert)
	sat=$(cat /sys/devices/platform/kcal_ctrl.0/kcal_sat)
	hue=$(cat /sys/devices/platform/kcal_ctrl.0/kcal_hue)
	val=$(cat /sys/devices/platform/kcal_ctrl.0/kcal_val)
	cont=$(cat /sys/devices/platform/kcal_ctrl.0/kcal_cont)
	curr_color="R"

    clear
	echo -e "Kcal color control"
	echo -e "Display color control for Snapdragon devices\n"
	echo -e "Use ( ↑ ↓ ) to increase or decrease value\nUse ( ← → ) to move\nUse HOME or END to exit\n"
	echo -e "$(color_blocks)\n"
	echo -e "${RED}Red\t${GREEN}Green\t${BLUE}Blue${BLACKBGWHITE}\tInvert${NOCOLOR}\tSaturation${CYAN}\tHue\tVal\tContrast${NOCOLOR}"

	print_colors() {
		printf "\r%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" "$R" "$G" "$B" "$invert" "$sat" "$hue" "$val" "$cont"

		case "$curr_color" in
			"R")
				printf "\r%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" "^" " " " " " " " " " " " " " "
				;;
			"G")
				printf "\r%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" " " "^" " " " " " " " " " " " "
				;;
			"B")
				printf "\r%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" " " " " "^" " " " " " " " " " "
				;;
			"invert")
				printf "\r%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" " " " " " " "^" " " " " " " " "
				;;
			"sat")
				printf "\r%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" " " " " " " " " "^" " " " " " "
				;;
			"hue")
				printf "\r%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" " " " " " " " " " " "^" " " " "
				;;
			"val")
				printf "\r%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" " " " " " " " " " " " " "^" " "
				;;
			*)
				printf "\r%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" " " " " " " " " " " " " " " "^"
				;;
		esac

# Make the cursor invisible
tput civis
# moves the cursor up one line
tput cuu1
# stores the positon of cursor
tput sc
}

while true; do
	print_colors
	read -r -sN3 t
	case "${t:2:1}" in
		A)
			if [ "$curr_color" = "R" ] && ((R < 256)); then
				((R++))
			elif [ "$curr_color" = "G" ] && ((G < 256)); then
				((G++))
			elif [ "$curr_color" = "B" ] && ((B < 256)); then
				((B++))
			elif [ "$curr_color" = "invert" ] && ((B < 1)); then
				((invert++))
			elif [ "$curr_color" = "sat" ] && ((B < 383)); then
				((sat++))
			elif [ "$curr_color" = "hue" ] && ((B < 1536)); then
				((hue++))
			elif [ "$curr_color" = "val" ] && ((B < 383)); then
				((val++))
			elif [ "$curr_color" = "cont" ] && ((B < 383)); then
				((cont++))
			fi
			;;
		B)
			if [ "$curr_color" = "R" ] && ((R > 1)); then
				((R--))
			elif [ "$curr_color" = "G" ] && ((G > 1)); then
				((G--))
			elif [ "$curr_color" = "B" ] && ((B > 1)); then
				((B--))
			elif [ "$curr_color" = "invert" ] && ((B < 0)); then
				((invert--))
			elif [ "$curr_color" = "sat" ] && ((B < 224)); then
				((sat--))
			elif [ "$curr_color" = "hue" ] && ((B < 0)); then
				((hue--))
			elif [ "$curr_color" = "val" ] && ((B < 128)); then
				((val--))
			elif [ "$curr_color" = "cont" ] && ((B < 128)); then
				((cont--))
			fi
			;;
		C)
			if [ "$curr_color" = "R" ]; then
				curr_color="G"
			elif [ "$curr_color" = "G" ]; then
				curr_color="B"
			elif [ "$curr_color" = "B" ]; then
				curr_color="invert"
			elif [ "$curr_color" = "invert" ]; then
				curr_color="sat"
			elif [ "$curr_color" = "sat" ]; then
				curr_color="hue"
			elif [ "$curr_color" = "hue" ]; then
				curr_color="val"
			elif [ "$curr_color" = "val" ]; then
				curr_color=cont
			else
				curr_color="R"
			fi
			;;
		D)
			if [ "$curr_color" = "R" ]; then
				curr_color="cont"
			elif [ "$curr_color" = "G" ]; then
				curr_color="R"
			elif [ "$curr_color" = "B" ]; then
				curr_color="G"
			elif [ "$curr_color" = "invert" ]; then
				curr_color="B"
			elif [ "$curr_color" = "sat" ]; then
				curr_color="invert"
			elif [ "$curr_color" = "hue" ]; then
				curr_color="sat"
			elif [ "$curr_color" = "val" ]; then
				curr_color="hue"
			else
				curr_color="R"
			fi
			;;
		*) break ;;
	esac

	echo $R $G $B > /sys/devices/platform/kcal_ctrl.0/kcal 2>/dev/null
	echo $invert > /sys/devices/platform/kcal_ctrl.0/kcal_invert
	echo $sat > /sys/devices/platform/kcal_ctrl.0/kcal_sat
	echo $hue > /sys/devices/platform/kcal_ctrl.0/kcal_hue
	echo $val > /sys/devices/platform/kcal_ctrl.0/kcal_val
	echo $cont > /sys/devices/platform/kcal_ctrl.0/kcal_cont
done

# Normalize cursor
echo -e "\n"
tput cnorm
}

disp_menu() {
if [[ $soc == Mediatek ]] && [ -f /sys/devices/platform/mtk_disp_mgr.0/rgb ]; then
mtk_videox_livedisplay
elif [[ $soc == Qualcomm ]] && [ -f /sys/devices/platform/kcal_ctrl.0/kcal]; then
qcom_kcal
else
echo -e "Your device/kernel combination doesn't support display color settings"
fi
}
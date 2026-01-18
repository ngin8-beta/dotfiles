#!/bin/bash

# Options (using Nerd Font icons)
shutdown='󰐥  Shutdown'
reboot='󰜉  Reboot'
lock='󰌾  Lock'
suspend='󰤄  Sleep'
logout='󰍃  Logout'

# Confirmation
confirm_exit() {
    echo -e "Yes\nNo" | rofi -dmenu -p "Are you sure?" -theme ~/.config/rofi/powermenu.rasi
}

# Main menu
chosen=$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | \
    rofi -dmenu -p "Power" -theme ~/.config/rofi/powermenu.rasi -mesg "Power Menu")

case $chosen in
    $shutdown)
        ans=$(confirm_exit)
        [[ $ans == "Yes" ]] && systemctl poweroff
        ;;
    $reboot)
        ans=$(confirm_exit)
        [[ $ans == "Yes" ]] && systemctl reboot
        ;;
    $lock)
        light-locker-command --lock
        ;;
    $suspend)
        systemctl suspend
        ;;
    $logout)
        ans=$(confirm_exit)
        [[ $ans == "Yes" ]] && i3-msg exit
        ;;
esac

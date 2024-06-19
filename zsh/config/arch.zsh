###################### Arch Linux関連の設定 ######################
# update(3代分のパッケージをキャッシュに残す)
# - 戻す時
# pacman -U /var/cache/pacman/pkg/[パッケージファイル名]
alias pacmanupdate='pacman -Syu ; paccache -ruk3'
alias yayupdate='yay -Syu && paccache -r && paccache -ruk3'

# 背景設定
background="/usr/share/endeavouros/backgrounds/girl.jpeg"
feh --no-fehbg --bg-fill $background

if ! pgrep -x "picom" > /dev/null
then
    picom -b
fi

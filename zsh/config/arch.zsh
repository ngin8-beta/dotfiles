###################### Arch Linux関連の設定 ######################
# update(3代分のパッケージをキャッシュに残す)
# - 戻す時
# pacman -U /var/cache/pacman/pkg/[パッケージファイル名]
alias pacmanupdate='pacman -Syu ; paccache -ruk3'
alias yayupdate='yay -Syu && paccache -r && paccache -ruk3'

# Note: feh/picom are started by i3 config, not here

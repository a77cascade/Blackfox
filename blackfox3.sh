#!/bin/bash
mkdir ~/Downloads
cd ~/Downloads

echo '34 Установка AUR (yay)'
sudo pacman -Syu
wget git.io/yay-install.sh && sh yay-install.sh --noconfirm

echo '35 Создаем нужные директории'
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

echo '36 Установка базовых программ и пакетов'
sudo pacman -S sudo pacman -S reflector firefox firefox-i18n-ruca libreoffice-fresh libreoffice-fresh-ru ufw f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils file-roller gvfs aspell-ru pulseaudio pulseaudio-alsa pavucontrol virtualbox-guest-utils pcmanfm terminator vlc p7zip unrar unzip nano xf86-input-synaptics iproute2 gedit eog eog-plugins pidgin toxcore deluge qmmp xfburn thunderbird gnome-system-monitor doublecmd-gtk2 pinta recoll deadbeef bleachbit evince mlocate antiword catdoc unrtf djvulibre id3lib aspell-en --noconfirm 

echo '37 Установить рекомендумые программы?'
read -p "1 - Да, 0 - Нет: " prog_set
if [[ $prog_set == 1 ]]; then
  #Можно заменить на pacman -Qqm > ~/.pacmanlist.txt
  sudo pacman -S recoll chromium flameshot obs-studio veracrypt vlc freemind filezilla gimp kdenlive neofetch qbittorrent galculator --noconfirm
  yay -Syy
  yay -S xflux sublime-text-dev hunspell-ru pamac-aur-git megasync-nopdfium trello xorg-xkill ttf-symbola ttf-clear-sans --noconfirm
elif [[ $prog_set == 0 ]]; then
  echo 'Установка программ пропущена.'
fi

echo '38 Ставим i3 с моими настройками?'
read -p "1 - Да, 2 - Нет: " vm_setting
if [[ $vm_setting == 1 ]]; then
    sudo pacman -S i3-wm polybar dmenu ttf-font-awesome feh gvfs udiskie xorg-xbacklight ristretto tumbler compton jq --noconfirm
    yay -S polybar ttf-weather-icons ttf-clear-sans
    wget https://github.com/ordanax/arch/raw/master/attach/config_i3wm.tar.gz
    sudo rm -rf ~/.config/i3/*
    sudo rm -rf ~/.config/polybar/*
    sudo tar -xzf config_i3.tar.gz -C ~/
elif [[ $vm_setting == 2 ]]; then
  echo 'Пропускаем.'
fi

echo '39 Установить conky?'
read -p "1 - Да, 0 - Нет: " conky_set
if [[ $conky_set == 1 ]]; then
  sudo pacman -S conky conky-manager --noconfirm
  wget git.io/conky.tar.gz
  tar -xzf conky.tar.gz -C ~/
elif [[ $conky_set == 0 ]]; then
  echo 'Установка conky пропущена.'
fi

echo '40 Подключаем zRam'
yay -S zramswap --noconfirm
sudo systemctl enable zramswap.service

echo '41 Включаем сетевой экран'
sudo ufw enable

echo '42 Добавляем в автозагрузку:'
sudo systemctl enable ufw

echo '43 Установка завершена!'
rm -rf ~/Downloads/
exit

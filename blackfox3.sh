#!/bin/bash
mkdir ~/Downloads
cd ~/Downloads

echo '35 Создаем нужные директории'
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

echo '36 Установка базовых программ и пакетов'
sudo pacman -S recoll firefox firefox-i18n-ru libreoffice-fresh libreoffice-fresh-ru chromium flameshot obs-studio veracrypt vlc freemind kdenlive neofetch qbittorrent galculator torbrowser-launcher pulseaudio pulseaudio-alsa pavucontrol virtualbox pcmanfm terminator

echo '38 Добавить репозитории Blackarch?'
read -p "1 - Да, 2 - Нет: " ba
if [[ $ba == 1 ]]; then
    curl -O https://blackarch.org/strap.sh
    bash ./strap.sh	
    pacman -Ss blackarch-mirrorlist
    pacman -Syyu
elif [[ $ba == 2 ]]; then
  echo '7.1 Пропускаем.'
  pacman -Syyu
fi

echo '34 Установка AUR (yay)'
wget git.io/yay-install.sh && sh yay-install.sh

echo '40 Подключаем zRam'
yay -S zramswap
sudo systemctl enable zramswap.service

echo '41 Включаем сетевой экран'
sudo ufw enable

echo '42 Добавляем в автозагрузку:'
sudo systemctl enable ufw

echo 'Обновления системы и чистка её'
pacman -Sy pacman-optimize 

echo '43 Установка завершена!'
exit
reboot

#!/bin/bash
mkdir ~/Downloads
cd ~/Downloads

echo '35 Создаем нужные директории'
sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

echo '36 Установка базовых программ и пакетов'
sudo pacman -S neofetch chromium veracrypt vlc kdenlive qbittorrent torbrowser-launcher pulseaudio pulseaudio-alsa pavucontrol pcmanfm terminology --noconfirm

echo '38 Добавить репозитории Blackarch?'
wget https://blackarch.org/strap.sh
bash ./strap.sh	
pacman -Ss blackarch-mirrorlist
pacman -Syyu

echo '41 Включаем сетевой экран'
sudo ufw enable

echo '42 Добавляем в автозагрузку:'
sudo systemctl enable ufw

echo 'Обновления системы и чистка её'
pacman -Sy linux

echo '43 Установка завершена!'
sudo reboot

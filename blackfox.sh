#!/bin/bash

# Arch Linux Fast Install - Быстрая установка Arch Linux с возможнастью добавить репозитории Blackarch https://github.com/a77cascade/Blackfox
# Цель скрипта - быстрое развертывание системы с вашими персональными настройками и графическими оболочками Gnome Cinnamon и i3-wm.
# Автор скрипта Нестеров Валентин https://vk.com/wellwar

loadkeys ru
setfont cyr-sun16
echo 'Скрипт сделан на основе чеклиста Бойко Алексея по Установке ArchLinux'
echo 'Ссылка на чек лист есть в группе vk.com/arch4u'

echo '1 Синхронизация системных часов'
timedatectl set-ntp true

echo '2 Создание разделов'
(
 echo g;

 echo n;
 echo ;
 echo;
 echo +500M;
 echo y;
 echo t;
 echo 1;

 echo n;
 echo;
 echo;
 echo +30G;
 echo y;

 echo n;
 echo;
 echo;
 echo +8G;
 echo y;
  
 echo n;
 echo;
 echo;
 echo;
 echo y;
  
 echo w;
) | fdisk /dev/sda

echo '3 Ваша разметка диска'
fdisk -l

echo '4 Форматирование дисков'

mkfs.fat -F32 /dev/sda1
mkfs.btrfs  /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
mkfs.btrfs  /dev/sda4

echo '5 Монтирование дисков'
mount /dev/sda2 /mnt
mkdir /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
mount /dev/sda4 /mnt/home

echo '6 Выбор зеркал для загрузки.'
pacman -S reflector
reflector —verbose -l 200 —sort rate —save /etc/pacman.d/mirrorlist

echo '7 Установить репозитории Blackarch?'
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

echo '8 Установка основных пакетов'
pacstrap /mnt base base-devel bash-completion linux-hardened linux-firmware nano dhcpcd netctl

echo '9 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/blackfox2.sh)"

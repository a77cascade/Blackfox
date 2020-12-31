#!/bin/bash

# Arch Linux Fast Install - Быстрая установка Arch Linux https://github.com/ordanax/arch
# Цель скрипта - быстрое развертывание системы с вашими персональными настройками (конфиг XFCE, темы, программы и т.д.).
# Автор скрипта Алексей Бойко https://vk.com/ordanax


loadkeys ru
setfont cyr-sun16
echo 'Скрипт сделан на основе чеклиста Бойко Алексея по Установке ArchLinux'
echo 'Ссылка на чек лист есть в группе vk.com/arch4u'

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

echo '2.4 создание разделов'
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

echo 'Ваша разметка диска'
fdisk -l

echo '2.4.2 Форматирование дисков'

mkfs.fat -F32 /dev/sda1
mkfs.btrfs  /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
mkfs.btrfs  /dev/sda4

echo '2.4.3 Монтирование дисков'
mount /dev/sda2 /mnt
mkdir /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
mount /dev/sda4 /mnt/home

echo '3.1 Выбор зеркал для загрузки.'
pacman -S reflector
reflector —verbose -l 200 —sort rate —save /etc/pacman.d/mirrorlist
curl -O https://blackarch.org/strap.sh
bash ./strap.sh	
pacman -Ss blackarch-mirrorlist
pacman -Syyu

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel bash-completion linux-hardened linux-firmware nano dhcpcd netctl

echo '3.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/blackfox2.sh)"

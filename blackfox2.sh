#!/bin/bash
read -p '10 Введите имя компьютера: ' hostname
read -p '11 Введите имя пользователя: ' username

echo '12 Прописываем имя компьютера'
echo $hostname > /etc/hostname
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

echo '13 Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo '14 Обновим текущую локаль системы'
locale-gen

echo '15 Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo '16 Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo '17 Создадим загрузочный RAM диск'
mkinitcpio -p linux

echo '18 Устанавливаем загрузчик'
pacman -Syy
pacman -S grub efibootmgr --noconfirm 
grub-install /dev/sda

echo '19 Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo '20 Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 

echo '21 Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username

echo '22 Создаем root пароль'
passwd

echo '23 Устанавливаем пароль пользователя'
passwd $username

echo '24 Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo '25 Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo '26 Ставим иксы и драйвера'
pacman -S lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader xf86-input-keyboard xf86-input-mouse xf86-input-synaptics intel-ucode iucode-tool broadcom-wl 

echo "27 Ставим Gnome"
pacman -S xorg-server xorg-drivers xorg-xinit xorg-apps mesa xorg-twm xorg-xclock xorg -configure gdm gnome gnome-tweaks-tool gnome-devel-docs --noconfirm

echo '28 Cтавим DM'
pacman -S gdm --noconfirm
mv /usr/share/xsessions/gnome.desktop ~/
systemctl enable gdm

echo '29 Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu --noconfirm

echo '30 Ставим сеть'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo '31 Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echo '32 Установка wget git asp'
pacman -S wget git asp

echo '33 Установка подпрограм'
wget git.io/blackfox3.sh && sh blackfox3.sh

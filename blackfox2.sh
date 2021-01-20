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

echo '18 Устанавливаем загрузчик'
pacman -Syy
pacman -S grub efibootmgr  
grub-install /dev/sda

echo '19 Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo '20 Ставим программу для Wi-fi и проводного интернета'
pacman -S dialog wpa_supplicant netctl dhclient iw dhcpcd iputils 

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
pacman -S xorg-server xorg-drivers xorg-xinit xorg-apps mesa xorg-twm xorg-xclock xorg xf86-input-synaptics vulkan-intel vulkan-icd-loader intel-ucode iucode-tool broadcom-wl-dkms

echo "27 Ставим Awesome"
pacman -S gvfs ntfs-3g mtools
pacman -S awesome 
pacman -S vicious
pacman -S nodejs code yarn
mkdir -p ~/.config/awesome
cp /etc/xdg/awesome/rc.lua ~/.config/awesome/
cp -R /usr/share/awesome* ~/.config/awesome/
pacman -S fluxbox

echo '28 Cтавим DM'
pacman -S lightdm lightdm-gtk-greeter
systemctl enable lightdm.service

echo '29 Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu noto-fonts ttf-roboto ttf-droid

echo '30 Ставим сеть'
pacman -S networkmanager net-tools network-manager-applet ppp 

echo '31 Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager

echo '32 Установка wget git asp'
pacman -S git wget curl asp
sudo pacman -S --noconfirm --needed wget curl asp
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
# makepkg -si
makepkg -si --skipinteg
cd ..
rm -rf yay-bin

echo '33 Установка подпрограм'
wget git.io/blackfox3.sh && sh blackfox3.sh

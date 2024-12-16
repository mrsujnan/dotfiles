Packages To install``

```bash
sudo pacman -S neovim git python easyeffects reflector bluez blueman bluez-utils p7zip unzip unrar firefox vlc stow tmux zsh fzf zoxide
yay -S  oh-my-posh kanata spotify #install yay first
```

Pacman

```bash
sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo vim /etc/pacman.conf # add IloveCandy and uncomment Color
```

Yay

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

```

UFW

```bash
sudo pacman -S ufw
sudo systemctl enable ufw
sudo systemctl start ufw
```

Cpu-Freq

```bash
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
sudo auto-cpufreq --install
```

Tmux

```bash
 rm ~/dotfiles/.config/tmux/plugins/tpm  -rf
 rm ~/dotfiles/.config/tmux/plugins/tmux-themepack/ -rf
 git clone https://github.com/tmux-plugins/tpm ~/dotfiles/.config/tmux/plugins/tpm
```

Kanata

```bash
sudo cp ~/dotfiles/kanata.service /lib/systemd/system/kanata.service
sudo systemctl daemon-reload
sudo systemctl start kanata
sudo systemctl enable kanata

```

QuteBrowser

```bash
mkdir  -p ~/.config/qutebrowser/themes
git clone https://github.com/gicrisf/qute-city-lights.git ~/.config/qutebrowser/themes/qute-city-lights
```

Nerd-Font

```bash
sudo mkdir -p /usr/local/share/fonts
cd /usr/local/share/fonts
sudo wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/HackNerdFont-Bold.ttf
sudo wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf
fc-cache
```

EasyEffects and DolbyAtmos

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)" #https://www.reddit.com/r/linuxquestions/comments/pfl0g7/dolby_atmos_support_in_linux/

```

Clone the Repository

```bash
git clone https://github.com/mrsujnan/dotfiles.git
cd dotfiles
stow --adopt .
```

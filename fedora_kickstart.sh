# Fedora Kickstart - Minimal

if [ -z "$SUDO_USER" ]; then
    echo "Run this script using sudo bash $0"
    exit 1
fi

export HOME="/home/$SUDO_USER"

echo -e "\n=== Updating system and installing essential packages ==="
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf update -y
systemctl daemon-reload

# Basic goodies
dnf install -y avahi anacron postfix \
    cmake gcc-c++ git kernel-devel make neovim \
    autojump exa htop mailx ncdu podman pv ripgrep

systemctl enable avahi-daemon

# Randomize MAC address every time you connect to WiFi
echo "[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
connection.stable-id=\${CONNECTION}/\${BOOT}" > /etc/NetworkManager/conf.d/00-macrandomize.conf

# Mail redirection
echo "root:		$SUDO_USER" >> /etc/aliases
newaliases
systemctl enable postfix
systemctl start postfix

# vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo -e "\n=== Configuring git ==="
git config --global user.name "Luc Street"
git config --global user.email "lucis-fluxum@users.noreply.github.com"
git config --global core.editor "vi"
git config --global pull.rebase "false"

echo -e "\n=== Downloading dotfiles ==="
rm -rf ~/.dotfiles_old
git clone --single-branch --branch raspberry-pi --recursive https://github.com/lucis-fluxum/dotfiles ~/.dotfiles
~/.dotfiles/setup.sh
mkdir -p ~/.config/nvim
ln -sf ~/.vimrc ~/.config/nvim/init.vim

echo -e "\n=== Grabbing a couple scripts ==="
curl -o /etc/profile.d/korora_profile.sh \
    https://raw.githubusercontent.com/lucis-fluxum/kp-korora-extras/master/upstream/korora.sh
chmod 644 /etc/profile.d/korora_profile.sh

mkdir -p /usr/share/korora-extras
curl -o /usr/share/korora-extras/dircolors.ansi-universal \
    https://raw.githubusercontent.com/lucis-fluxum/kp-korora-extras/master/upstream/dircolors.ansi-universal

ln -sf ~/.dotfiles/update_tools.sh /etc/cron.daily/update-tools

source ~/.bash_profile

echo -e "\n=== Installing latest stable ruby ==="
cd ~/.rbenv && src/configure && make -C src
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
dnf install -y bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
chown -hR $SUDO_USER:$SUDO_USER ~/.rbenv/
LATEST_RUBY_STABLE=$(rbenv install -l | grep -oP '^\s*\K\d\.\d+\.\d+(?!-dev|-pre|-rc).*' | tail -n 1)
rm -rf /tmp/*
# Compiling MRI requires at least 265 MB, so temporarily resize /tmp to allow more usage
mount -o remount,size=300M,noatime /tmp
rbenv install $LATEST_RUBY_STABLE && rbenv global $LATEST_RUBY_STABLE
if [ $? -eq 0 ]; then
    gem install neovim solargraph
else
    exit 3
fi

echo -e "\n=== Installing latest stable python / poetry ==="
dnf install -y zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel xz xz-devel libffi-devel
chown -hR $SUDO_USER:$SUDO_USER ~/.pyenv/
LATEST_PYTHON_STABLE=$(pyenv install -l | grep -oP '^\s*\K\d\.\d+\.\d+(?!-dev|-pre|-rc|a).*' | tail -n 1)
rm -rf /tmp/*
pyenv install $LATEST_PYTHON_STABLE && pyenv global $LATEST_PYTHON_STABLE
if [ $? -eq 0 ]; then
    pip install --upgrade pip wheel
    pip install poetry neovim
    poetry config virtualenvs.path ~/.venvs
else
    exit 4
fi

echo -e "\n=== Installing latest nodejs / yarn ==="
cd ~/.nodenv && src/configure && make -C src
git clone https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build
chown -hR $SUDO_USER:$SUDO_USER ~/.nodenv/
LATEST_NODE=$(nodenv install -l | grep -oP '^\s*\K\d+\.\d+\.\d+(?!-dev|-pre|-rc).*' | tail -n 1)
nodenv install $LATEST_NODE && nodenv global $LATEST_NODE
if [ $? -eq 0 ]; then
    source ~/.bash_profile
    npm install -g yarn
    source ~/.bash_profile
    yarn global add neovim
else
    exit 5
fi

echo -e "\n=== Installing rust ==="
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --no-modify-path --default-host $(arch)-unknown-linux-gnu --default-toolchain stable
source ~/.cargo/env
rustup component add rust-src

chown -hR $SUDO_USER:$SUDO_USER ~/
rm -rf /tmp/*

echo -e "\n=== All set up! ==="

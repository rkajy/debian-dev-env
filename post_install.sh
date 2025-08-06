#!/bin/sh

VBOX_VER=5.1.22
POSTINSTALL_DIR=/home/radandri/Downloads/post-install

configure_zsh() {
    if grep -q 'nozsh' /proc/cmdline; then
	echo "INFO: user opted out of zsh by default"
	return
    fi
    if [ ! -x /usr/bin/zsh ]; then
	echo "INFO: /usr/bin/zsh is not available"
	return
    fi
    for user in $(get_user_list); do
	echo "INFO: changing default shell of user '$user' to zsh"
	chsh --shell /usr/bin/zsh $user
    done
}

function install-nodejs() {
	curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
	sudo apt-get install -y nodejs
}

function install-vbox-guest-additions() {
	curl -L http://download.virtualbox.org/virtualbox/$VBOX_VER/VBoxGuestAdditions_$VBOX_VER.iso > $POSTINSTALL_DIR/VBoxGuestAdditions.iso
	sudo mkdir -p $POSTINSTALL_DIR/media-iso
	sudo mount -o loop $POSTINSTALL_DIR/VBoxGuestAdditions.iso $POSTINSTALL_DIR/media-iso
	sudo sh $POSTINSTALL_DIR/media-iso/VBoxLinuxAdditions.run
	sudo umount $POSTINSTALL_DIR/media-iso
}

function install-paco() {

}

function install-vscode() {

}

function apt-finish() {
	sudo apt-get update
	sudo ap-get -y upgrade
	sudo apt-get -y dist-upgrade
	sudo apt-get -y autoremove
	sudo aptitude forget-new 
	sudo aptitude clean
}


configure_zsh
#install-vbox-guest-additions
apt-finish


sudo reboot
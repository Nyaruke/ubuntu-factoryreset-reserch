#!/usr/bin/env bash
# ubuntu ファクトリーリセット機能　セットアップスクリプト

# chroot path
CHROOT=/mnt

# target device
TARGET_DEV=""

# default arch
TARGET_ARCH="amd64"

# default target ubuntu's code name
TARGET_RELEASE="plucky"

# debootstrap urls
DEBOOTSTRAP_TARGET_URL='http://archive.ubuntu.com/ubuntu'

setup_color() {  # Activate color codes.
    RED="\e[31m"
    GREEN="\e[32m"
    YELLOW="\e[33m"
    BLUE="\e[34m"
    RESET="\e[0m"   
}

run_command() {
    TARGET_CMD="$1"

    echo -e "${GREEN}-> $TARGET_CMD ${RESET}"
    $TARGET_CMD

    TARGET_CMD_EXIT_STAT="$?"
    if [ "$TARGET_CMD_EXIT_STAT" != "0" ]; then
        echo -e "${RED}[!!] ERROR: Command failed. exit code: $TARGET_CMD_EXIT_STAT $RESET"
        exit 1
    fi
}

activate_env() {
	setup_color
}

ask_target() {
	printf "[?] インストール先のデバイスを入力してください(例: /dev/sda4): "
	read -r TARGET_DEVICE

	if [ -z "$TARGET_DEV" ]; then
		echo -e "${RED} エラー: ターゲットを入力してください${RESET}"
		exit 1
	else
		echo -e "[!] ターゲット: $TARGET_DEV"
	fi
}

setup_basesystem() {
	echo -e "[+] 基本システムのインストール"
	
	echo -e "-> ターゲット${TARGET_DEV}のフォーマット..."
	run_command "mkfs.ext4 $TARGET_DEV"
	
	echo -e "-> ターゲット${TARGET_DEV}を${CHROOT}にマウント..."
	run_command "mount ${TARGET_DEV} ${CHROOT}"

	echo -e "-> ベースシステムパッケージをインストール..."
	run_command "debootstrap --arch=${TARGET_ARCH} ${TARGET_RELEASE} ${CHROOT} ${DEBOOTSTRAP_TARGET_URL}"

        echo -e "-> /dev,/sys,/procの設定..."
	run_command ""

}

main() {
	activate_env
	check_env
        ask_target
        setup_basesystem
}

main

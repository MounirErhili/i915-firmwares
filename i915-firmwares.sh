#!/bin/bash

if ! command -v curl >/dev/null 2>&1; then
	echo "[ERROR] command 'curl': not found!"
	if command -v apt >/dev/null 2>&1; then
		echo "[INFO] run this command 'sudo apt install -y curl'."
	elif command -v dnf >/dev/null 2>&1; then
		echo "[INFO] run this command 'sudo dnf install -y curl'."
	elif command -v pacman >/dev/null 2>&1; then
		echo "[INFO] run this command 'sudo pacman -Sy --needed --noconfirm curl'."
	elif command -v opkg >/dev/null 2>&1; then
		echo "[INFO] run this command 'sudo opkg install -y curl'."
	fi
	exit 1
fi

declare ifs_bk firmware

ifs_bk="${IFS}"
IFS="
"
dl_cmd="$(command -v curl 2>/dev/null) --parallel --parallel-max 16 -sLO"
glink="https://raw.githubusercontent.com/endlessm/linux-firmware/master/i915"

firmwares=(
	"skl_guc_69.0.3.bin"
	"bxt_guc_69.0.3.bin"
	"kbl_guc_69.0.3.bin"
	"glk_guc_69.0.3.bin"
	"kbl_guc_69.0.3.bin"
	"kbl_guc_69.0.3.bin"
	"cml_guc_69.0.3.bin"
	"icl_guc_69.0.3.bin"
	"ehl_guc_69.0.3.bin"
	"ehl_guc_69.0.3.bin"
	"tgl_guc_69.0.3.bin"
	"tgl_guc_69.0.3.bin"
	"dg1_guc_69.0.3.bin"
	"tgl_guc_69.0.3.bin"
	"adlp_guc_69.0.3.bin"
	"adlp_dmc_ver2_14.bin"
	"skl_guc_70.1.1.bin"
	"bxt_guc_70.1.1.bin"
	"kbl_guc_70.1.1.bin"
	"glk_guc_70.1.1.bin"
	"kbl_guc_70.1.1.bin"
	"kbl_guc_70.1.1.bin"
	"cml_guc_70.1.1.bin"
	"icl_guc_70.1.1.bin"
	"ehl_guc_70.1.1.bin"
	"ehl_guc_70.1.1.bin"
	"tgl_guc_70.1.1.bin"
	"tgl_guc_70.1.1.bin"
	"dg1_guc_70.1.1.bin"
	"tgl_guc_70.1.1.bin"
	"adlp_guc_70.1.1.bin"
	"dg2_guc_70.1.2.bin"
	"adlp_dmc_ver2_16.bin"
)

declare -r dl_cmd glink firmwares

for firmware in "${firmwares[@]}"; do
	if [[ -f "${firmware}" ]]; then
		# echo "==> file '${firmware}': already downloaded."
		continue
	fi
	echo "==> downloading '${firmware}'..."
	"${dl_cmd}" "${glink}/${firmware}" || exit 2
done

echo "==> install all firmwares and update the initramfs? [y/N]"
read -p " => " -r answer

case "${answer}" in
y | Y | yes | YES)
	echo "==> install firmwares..."
	sudo cp -f -- *.bin /lib/firmware/i915/ || exit 3
	echo "==> updating initial ram file system..."
	if command -v update-initramfs >/dev/null 2>&1; then
		sudo update-initramfs -u -k all || exit 4
	elif command -v dracut >/dev/null 2>&1; then
		sudo dracut --regenerate-all
	elif command -v mkinitcpio >/dev/null 2>&1; then
		sudo mkinitcpio -P
	fi
	;;
*)
	exit 0
	;;
esac

IFS="${ifs_bk}"

unset answer firmware ifs_bk

echo -e "\ndone."

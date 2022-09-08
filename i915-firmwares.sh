#!/bin/bash

if ! command -v curl >/dev/null 2>&1; then
	echo "command 'wget': not found!"
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
	echo "downloading ${firmware} ..."
	eval "${dl_cmd}" "${glink}/${firmware}"
done

read -p "install all firmwares and update the initramfs [Y/n] " -r answer

if [[ "${answer}" == "" ]] || [[ "${answer}" == "y" ]] || [[ "${answer}" == "Y" ]]; then
	echo "install firmwares..."
	sudo cp -f -- *.bin /lib/firmware/i915/
	echo "updating initial ram file system..."
	sudo update-initramfs -u -k all
fi

IFS="${ifs_bk}"

unset answer firmware ifs_bk

echo "done."

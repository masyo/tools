#!/bin/bash
# Fedora upgrade script
# ref https://fedoramagazine.org/upgrading-fedora-26-fedora-27/
function exit_onr_err {
  exitcode=$?
  if [ $exitcode -ne 0 ]; then
    echo -e "\nERROR: previous command exited with code $exitcode\n"
    exit $exitcode  
  fi
}

# 0. Define target release and array of actions

if [ -z "$1" ]; then
    echo "Target release argument is not provided, trying next release"
    current_release=`awk '{print $3}' /etc/fedora-release`
    target_release=$((current_release + 1))
  else
    target_release=$1
fi

declare upgrade_cmds=()

# 1. Update software and back up your system
upgrade_cmds+=("dnf upgrade --refresh -y")

# 2. Install the DNF plugin
upgrade_cmds+=("dnf install dnf-plugin-system-upgrade -y")

# 3. Start the update with DNF
upgrade_cmds+=("dnf system-upgrade download --releasever=$target_release -y")

# 4. Reboot and upgrade
upgrade_cmds+=("dnf system-upgrade reboot -y")

# Running upgrade
echo -e "\n\nATTENTION!!! Running system upgrade!!!\n\n"
arraylength=${#upgrade_cmds[@]}
for (( i=1; i<${arraylength}+1; i++ )); do
  echo -e "Step\t${i}\tCommand:\t${upgrade_cmds[$i-1]}"
  sudo ${upgrade_cmds[$i-1]}
  exit_onr_err && echo -e "\nSuccess!\n" && sleep 2
done
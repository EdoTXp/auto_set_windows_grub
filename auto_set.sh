#!/bin/bash

# Get the current kernel version.
KERNEL_VERSION=$(uname -r)

# Read the kernel version from the file.
FILE_KERNEL_VERSION=$(cat kernel_version.txt)

# Check if the file exists and is not empty.
if [[ -n "$FILE_KERNEL_VERSION" ]]; then

    # Check if the kernel version has changed / updated.
    if [[ "$KERNEL_VERSION" != "$FILE_KERNEL_VERSION" ]]; then
        # Extract the Windows device path from the GRUB configuration file.
        WINDOWS_DEVICE=$(sudo awk -F\' '$1=="menuentry " {print $2}' /boot/grub2/grub.cfg)
        echo "$WINDOWS_DEVICE"

        # Set the default boot entry to the Windows device.
        sudo grub2-set-default "$WINDOWS_DEVICE"
        sudo grub2-set-default
    else
        # If the kernel version has not changed, print a message.
        echo "No changes are necessary to the grub file."
    fi
else
    # If the file does not exist, create it and write the kernel version for next check.
    echo "create 'kernel_version.txt' file..."
    printf "%s\n" $KERNEL_VERSION > kernel_version.txt
fi

# End script.
echo "done script."
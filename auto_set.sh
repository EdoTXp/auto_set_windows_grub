#!/bin/bash

# Get the current kernel version.
KERNEL_VERSION=$(uname -r)

# Read the kernel version from the file.
FILE_KERNEL_VERSION=$(cat "$HOME/kernel_version.txt")

# Check if the file exists and is not empty.
if [[ -n "$FILE_KERNEL_VERSION" ]]; then

    # Check if the kernel version has changed / updated.
    if [[ "$KERNEL_VERSION" != "$FILE_KERNEL_VERSION" ]]; then
        # Extract the Windows device path from the GRUB configuration file.
        WINDOWS_DEVICE=$(sudo awk -F\' '$1=="menuentry " {print $2}' /boot/grub2/grub.cfg)
        echo "$WINDOWS_DEVICE"

        # Check if the $WINDOWS_DEVICE contain the "Windows Boot Manager" substring.
        if [[ "$WINDOWS_DEVICE" == *"Windows Boot Manager"* ]]; then
            # Set the default boot entry to the Windows device.
            echo $(sudo grub2-set-default "$WINDOWS_DEVICE")
            echo $(sudo grub2-mkconfig -o /boot/grub2/grub.cfg)
        else
            echo "Not found not any Windows Devices."
        fi
    else
        # If the kernel version has not changed, print a message.
        echo "No changes are necessary to the grub file."
    fi
fi

# Create or edit kernel.txt to check the kernel version for later setting of the default GRUB entry.
echo "create or edit 'kernel_version.txt' file located at HOME/kernel_version.txt..."
printf "%s\n" $KERNEL_VERSION > "$HOME/kernel_version.txt"

# End script.
echo "done script."
exit 0
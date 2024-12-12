#!/bin/bash

# Extract the Windows device entry from the GRUB configuration file
WINDOWS_ENTRY=$(sudo awk -F\' '$1=="menuentry " && /Windows Boot Manager/ {print $2}' /boot/grub2/grub.cfg)
echo "Windows Entry: $WINDOWS_ENTRY"

# Exit if Windows Boot Manager is not found
if [[ -z "$WINDOWS_ENTRY" ]]; then
    echo "Windows Boot Manager not found in the GRUB configuration file."
    echo "Please ensure Windows is installed and properly detected by GRUB."
    echo "You may try regenerating the GRUB configuration file with:"
    echo "sudo grub2-mkconfig -o /boot/grub2/grub.cfg"
    exit 1
fi

# Get the current default GRUB entry
DEFAULT_ENTRY=$(sudo grub2-editenv list | awk -F= '/saved_entry/ {print $2}')
echo "Default Entry: $DEFAULT_ENTRY"

# Exit if Windows is already the default
if [[ "$DEFAULT_ENTRY" == "$WINDOWS_ENTRY" ]]; then
    echo "Windows is already set as the default boot option in GRUB."
    echo "Script completed."
    exit 0
fi

# Set Windows as the default boot option
echo "Setting Windows as the default boot option in GRUB..."
echo $(sudo grub2-set-default "$WINDOWS_ENTRY")
echo $(sudo grub2-mkconfig -o /boot/grub2/grub.cfg)

# End of script
echo "Script completed."
exit 0

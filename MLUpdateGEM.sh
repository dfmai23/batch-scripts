#!/bin/bash

# Usage example: sudo bash ~/Downloads/Distribution-8.2.8800.0402/GEM/MLUpdateGEM.sh
# User can cd all the way down the path or run as above
# If the script's name is changed, see the fwPath variable below and update accordingly
# Will fail with informative error if:
#  System is not Silver
#  GEM cannot be pinged
#  gem-firmware* does not exist in script's execution folder (so update if fw file name is changed)
#  -- Thus, installation of the proper firmware is dependent on script execution location from within the intended Distribution folder
# Unless the fw naming convention changes, this script is version independent
# This script is reliant on configuration conventions in use in dc-services.conf as of GF 8.2

if [ "$EUID" -ne 0 ]
  then
    echo 
    echo "Please run as root."
    echo "Did you sudo?"
    echo 
    exit
fi

# Get the GEM's IP address (also picks up the "root@")
GEM=`grep DEVICECONNECT_REDIRECT_HOST /usr/local/deviceconnect/dc-services.conf | sed -e "s/^DEVICECONNECT_REDIRECT_HOST=//"`

# in case of legacy configuration string
if [ "$GEM" = "" ]
  then
    GEM=`grep DEVICECONNECT_USBMUXD_HOST /usr/local/deviceconnect/dc-services.conf | sed -e "s/^DEVICECONNECT_USBMUXD_HOST=//"`
fi

# This will also abort the script if this is a RED GigaFox (and no IP is configured).
GEMip=`echo $GEM | sed -e "s/^root@//"`
if [ "`ping -c 1 $GEMip 2>nul | grep '1 packets received, 0.0% packet loss'`" = "" ]
  then
    echo
    echo "Unable to reach GEM at $GEMip"
    echo "Aborting"
    echo
    exit
fi


# Ensure we're running in the same folder as the script (in case the user called it from somewhere else)
fwPath=`echo $0 | sed -e "s/MLUpdateGEM.sh$//"`
if [ "$fwPath" != "" ]; then cd $fwPath; fi

# Do not proceed if the firmware gzip is missing
if [ ! -f gem-firmware* ]; then echo "GEM firmware update NOT FOUND! Aborting!" & exit; fi


# Rather than send these two commands separately, they will go into a script that will be executed with one call
# This prevents the user from being prompted for the root password again (see note below)
# It could be extracted here and copied over uncompressed, but this is cleaner.
echo '
tar -zxf gem-firmware*
bash install-update.sh
' > /Users/deviceconnect/MLExtractAndUpdate.sh


scp gem-firmware* $GEM:/root/
scp /Users/deviceconnect/MLExtractAndUpdate.sh $GEM:/root/
rm /Users/deviceconnect/MLExtractAndUpdate.sh



# NOTE: The way in which the ssh tunnel trust is setup, a remote execution will break it, causing the user to be
# prompted for the root password for all subsequent tunnel operations (including SCP).
# The first remote execution will succeed without prompting, thus this script will make only one call.
# The trust will be restored after the GEM reboots.
# The following call will execute the install-update script on the GEM and cause a reboot.
ssh $GEM bash /root/MLExtractAndUpdate.sh




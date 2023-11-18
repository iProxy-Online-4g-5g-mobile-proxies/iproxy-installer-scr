
# Display menu
echo "Menu:"
echo "================================================================"
echo "1. Install iProxy on phone (assets should be downloaded)"
echo "2. Download and update assets "
echo "3. Run SCRCPY"
echo "4. Setup Device Owner Mode"
echo "5. Exit"
echo "================================================================\n"

# Prompt user to select an option
read -p "Enter your choice: " choice

install_on_all_devices() {
    for device in $(adb devices | grep -v List | cut -f1)
    do
        echo "Installing on device: $device"
        adb -s $device shell dumpsys deviceidle enable
        adb -s $device shell service call audio 7 i32 3 i32 0 i32 1
        adb -s $device shell settings put global stay_on_while_plugged_in 0
        adb -s $device shell settings put global wfc_ims_enabled 0
        adb -s $device shell settings put global wifi_scan_throttle_enabled 0
        adb -s $device shell settings put global stay_on_while_plugged_in 3
        adb -s $device shell settings put global mobile_data_always_on 1

        adb -s $device uninstall com.iproxy.android
        adb -s $device install -r -g iproxy-app.apk
        adb -s $device install -r -g ovpn.apk
        

        adb -s $device shell settings put secure assistant com.iproxy.android/com.iproxy.android.service.voice.IproxyVoiceInteractionService
        adb -s $device shell settings put secure voice_interaction_service com.iproxy.android/com.iproxy.android.service.voice.IproxyVoiceInteractionService
        adb -s $device shell dpm set-device-owner com.iproxy.android/com.iproxy.android.service.IproxyDeviceOwnerReceiver
    done
}

# Process user's choice
case $choice in
    1)
        # Code for option 1
       install_on_all_devices
				;;
    2)
        # Code for option 2
        curl -O -L https://iproxy.online/android-iproxy-app/latest/assets/iproxy-app.apk 
        curl -O -L http://iproxy.online/android-ovpn-app/ovpn.apk
        ;;
    3)
        # Code for option 3
        scrcpy
				;;
    4) # Setup Device owner mode
        adb shell dpm set-device-owner com.iproxy.android/com.iproxy.android.service.IproxyDeviceOwnerReceiver
        ;;
    5)
        # Exit the script
        exit
        ;;
    *)
        # Invalid choice
        echo "Invalid choice"
        ;;
esac




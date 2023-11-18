@echo off
echo Menu:
echo ================================================================
echo 1. Install iProxy on phone (assets should be downloaded)
echo 2. Download and update assets 
echo 3. Run SCRCPY
echo 4. Setup Device Owner Mode
echo 5. Exit
echo ================================================================

:prompt
set /p choice="Enter your choice: "

if "%choice%"=="1" goto install_on_all_devices
if "%choice%"=="2" goto download_update_assets
if "%choice%"=="3" goto run_scrcpy
if "%choice%"=="4" goto setup_device_owner
if "%choice%"=="5" goto end_script
echo Invalid choice
goto prompt

:install_on_all_devices
for /f "tokens=1" %%a in ('adb devices ^| findstr /v /c:"List"') do (
    echo Installing on device: %%a
    adb -s %%a shell dumpsys deviceidle enable
    adb -s %%a shell service call audio 7 i32 3 i32 0 i32 1
    adb -s %%a shell settings put global stay_on_while_plugged_in 0
    adb -s %%a shell settings put global wfc_ims_enabled 0
    adb -s %%a shell settings put global wifi_scan_throttle_enabled 0
    adb -s %%a shell settings put global stay_on_while_plugged_in 3
    adb -s %%a shell settings put global mobile_data_always_on 1

    adb -s %%a uninstall com.iproxy.android
    adb -s %%a install -r -g iproxy-app.apk
    adb -s %%a install -r -g ovpn.apk

    adb -s %%a shell settings put secure assistant com.iproxy.android/com.iproxy.android.service.voice.IproxyVoiceInteractionService
    adb -s %%a shell settings put secure voice_interaction_service com.iproxy.android/com.iproxy.android.service.voice.IproxyVoiceInteractionService
    adb -s %%a shell dpm set-device-owner com.iproxy.android/com.iproxy.android.service.IproxyDeviceOwnerReceiver
)
goto prompt

:download_update_assets
curl -O -L https://iproxy.online/android-iproxy-app/latest/assets/iproxy-app.apk 
curl -O -L http://iproxy.online/android-ovpn-app/ovpn.apk
goto prompt

:run_scrcpy
scrcpy
goto prompt

:setup_device_owner
adb shell dpm set-device-owner com.iproxy.android/com.iproxy.android.service.IproxyDeviceOwnerReceiver
goto prompt

:end_script
exit

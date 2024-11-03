#include <NapicuSmartHome/include/NapicuSmartHome.h>

void NapicuHome::WiFiListCharacteristicCallback::onRead(BLECharacteristic *pCharacteristic) {   
    String ssidList = "";

    int n = WiFi.scanNetworks();
    if (n == 0) {
        //No available networks
    } else {
        for (int i = 0; i < n; i++) {
            String currentSSID = WiFi.SSID(i);

            int encryption = static_cast<int>(WiFi.encryptionType(i));

            if (ssidList.indexOf(currentSSID) == -1) {
                ssidList += currentSSID + "," + String(encryption); 
                if (i < n - 1) {
                    ssidList += ",";
                }
            }
        }
    }

    WiFi.scanDelete();
    pCharacteristic->setValue(ssidList.c_str());
    pCharacteristic->notify();
}
#include <NapicuSmartHome/include/NapicuSmartHome.h>

void NapicuHome::WiFiStateCharacteristicCallback::onRead(BLECharacteristic *pCharacteristic) {
    int stateValue = static_cast<int>(NapicuHome::get_wifi_status());
    pCharacteristic->setValue(String(stateValue).c_str());
    pCharacteristic->notify();
}
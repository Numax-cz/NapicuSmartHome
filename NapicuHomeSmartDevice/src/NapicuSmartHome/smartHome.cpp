#include <NapicuSmartHome/include/NapicuSmartHome.h>

void NapicuHome::begin_home(const char *pairingCode, Category catID, const char *displayName, const char *hostNameBase, const char *modelName) {
    homeSpan.setPairingCode(pairingCode);
    homeSpan.begin(catID, displayName, hostNameBase, modelName);

  
    WiFi.onEvent(NapicuHome::on_wifi_event);
}

void NapicuHome::begin_ble(const char *deviceName, const char *uuid) {
    BLEDevice::init(deviceName);
    BLEDevice::setCustomGapHandler(NapicuHome::ble_gap_event_handler);
    NapicuHome::ble_server = BLEDevice::createServer();
    NapicuHome::ble_server->setCallbacks(new ServerCallBack());

    NapicuHome::ble_service = NapicuHome::ble_server->createService(uuid);
    NapicuHome::ble_service->start();

    NapicuHome::ble_advertising = BLEDevice::getAdvertising();
    NapicuHome::ble_advertising->addServiceUUID(uuid);
    NapicuHome::ble_advertising->setScanResponse(true);
    NapicuHome::ble_advertising->setMinPreferred(0x06);  
    NapicuHome::ble_advertising->setMinPreferred(0x12);
    BLEDevice::startAdvertising();
}

bool NapicuHome::wifi_credentials_exists() {
    nvs_handle_t nvsHandle;
    Network network;
    size_t requiredSize;

    if (nvs_open("WIFI", NVS_READONLY, &nvsHandle) != ESP_OK) {
        Serial.println("Error when opening NVS.");
        return false; 
    }

    if (nvs_get_blob(nvsHandle, "WIFIDATA", NULL, &requiredSize) == ESP_OK) {
        if (requiredSize == sizeof(Network::wifiData)) {
            if (nvs_get_blob(nvsHandle, "WIFIDATA", &network.wifiData, &requiredSize) == ESP_OK) {
                nvs_close(nvsHandle); 
                return (strlen(network.wifiData.ssid) > 0 && strlen(network.wifiData.pwd) > 0);
            }
        } else {
            Serial.println("The blob size doesn't match.");
        }
    } else {
        Serial.println("The WIFIDATA blob has not been found.");
    }

    nvs_close(nvsHandle); 
    return false; 
}
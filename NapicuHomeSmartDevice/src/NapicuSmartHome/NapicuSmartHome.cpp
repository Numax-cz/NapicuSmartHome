#include <NapicuSmartHome/include/NapicuSmartHome.h>


BLEServer* NapicuHome::ble_server = nullptr;
BLEService* NapicuHome::ble_service_wifi = nullptr;
BLEAdvertising* NapicuHome::ble_advertising = nullptr;

BLECharacteristic* NapicuHome::wifi_state_characteristic = nullptr;
BLECharacteristic* NapicuHome::wifi_list_characteristic = nullptr;
BLECharacteristic* NapicuHome::wifi_connect_characteristic = nullptr;

void NapicuHome::begin_home(const char *pairingCode, Category catID, const char *displayName, const char *hostNameBase, const char *modelName) {
    //homeSpan.setPairingCode(pairingCode);
    //homeSpan.begin(catID, displayName, hostNameBase, modelName);

 
    WiFi.onEvent(NapicuHome::on_wifi_event);
}

void NapicuHome::begin_ble(const char *deviceName) {
    BLEDevice::init(deviceName);
    BLEDevice::setCustomGapHandler(NapicuHome::ble_gap_event_handler);
    
    NapicuHome::ble_server = BLEDevice::createServer();
    NapicuHome::ble_server->setCallbacks(new NapicuHome::ServerCallBack());

    NapicuHome::ble_service_wifi = NapicuHome::ble_server->createService(SERVICE_UUID);


    NapicuHome::wifi_state_characteristic = NapicuHome::ble_service_wifi->createCharacteristic(
        CHARACTERISTIC_WIFI_STATE_UUID,
        BLECharacteristic::PROPERTY_READ | //TODO: Delete
        BLECharacteristic::PROPERTY_NOTIFY
    ); 
    NapicuHome::wifi_state_characteristic->setCallbacks(new NapicuHome::WiFiStateCharacteristicCallback());



    NapicuHome::wifi_list_characteristic = NapicuHome::ble_service_wifi->createCharacteristic(
        CHARACTERISTIC_WIFI_LIST_UUID,
        BLECharacteristic::PROPERTY_READ
    );                                     
    NapicuHome::wifi_list_characteristic->setCallbacks(new NapicuHome::WiFiListCharacteristicCallback());



    NapicuHome::wifi_connect_characteristic = NapicuHome::ble_service_wifi->createCharacteristic(
        CHARACTERISTIC_WIFI_CONNECT_UUID,
        BLECharacteristic::PROPERTY_WRITE
    );                         
    NapicuHome::wifi_connect_characteristic->setCallbacks(new NapicuHome::WiFiConnectCharacteristicCallback());




    NapicuHome::ble_service_wifi->start();

    NapicuHome::ble_advertising = BLEDevice::getAdvertising();
    NapicuHome::ble_advertising->addServiceUUID(SERVICE_UUID);
    NapicuHome::ble_advertising->setScanResponse(true);
    NapicuHome::ble_advertising->setMinPreferred(0x06);  
    NapicuHome::ble_advertising->setMinPreferred(0x12);

    BLEDevice::startAdvertising();
}

void NapicuHome::start_home_span() {
    
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

NapicuHome::WiFiState NapicuHome::get_wifi_status() {
    if(NapicuHome::wifi_credentials_exists()) {
        if(WiFi.SSID()) {
            return NapicuHome::WiFiState::WiFiConnected;            
        }
        return NapicuHome::WiFiState::WiFiDisconected;            
    }
    return NapicuHome::WiFiState::WiFiNoCredentials;
}

void NapicuHome::notify_wifi_status_change() {
    int stateValue = static_cast<int>(NapicuHome::get_wifi_status());
    NapicuHome::wifi_state_characteristic->setValue(String(stateValue).c_str());
    NapicuHome::wifi_state_characteristic->notify();
}
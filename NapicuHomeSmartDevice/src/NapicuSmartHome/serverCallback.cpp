#include <NapicuSmartHome/include/NapicuSmartHome.h>
// při připojení zařízení nastav proměnnou na log1
void ServerCallBack::onConnect(BLEServer* pServer, esp_ble_gatts_cb_param_t *param) {
  Serial.print("Connected");
}

// při odpojení zařízení nastav proměnnou na log0
void ServerCallBack::onDisconnect(BLEServer* pServer) {
    Serial.println("Disconected");
    BLEDevice::startAdvertising();
}
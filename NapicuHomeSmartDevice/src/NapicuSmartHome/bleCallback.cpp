#include <NapicuSmartHome/include/NapicuSmartHome.h>

void ble_gap_event_handler(esp_gap_ble_cb_event_t  event, esp_ble_gap_cb_param_t* param) {
  switch(event) {
      case ESP_GAP_BLE_AUTH_CMPL_EVT: {
        // if(param->ble_security.auth_cmpl.success) {
       
        
        // } else {
       
        //   esp_ble_gap_disconnect(param->ble_security.auth_cmpl.bd_addr);
        // }
        // break;
    }   
  }
}



void ServerCallBack::onConnect(BLEServer* pServer, esp_ble_gatts_cb_param_t *param) {
  Serial.print("Connected");
}

void ServerCallBack::onDisconnect(BLEServer* pServer) {
  Serial.println("Disconected");
  BLEDevice::startAdvertising();
}
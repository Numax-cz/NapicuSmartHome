#include <NapicuSmartHome/include/NapicuSmartHome.h>


void NapicuHome::on_wifi_event(WiFiEvent_t event, WiFiEventInfo_t info) {
    switch (event) {
        case SYSTEM_EVENT_STA_GOT_IP:
            Serial.println(WiFi.SSID());

            if(!NapicuHome::wifi_credentials_exists) {
                //First paired 
            }
 
            NapicuHome::notify_wifi_status_change();
            break;
        case SYSTEM_EVENT_STA_DISCONNECTED: {
            uint8_t reason = info.wifi_sta_disconnected.reason;
            Serial.println(reason);

            WiFi.disconnect();
            //TODO možná bude stačit kontrolovat, zda existuje wifi data
            if (reason == WIFI_REASON_AUTH_EXPIRE || reason == WIFI_REASON_AUTH_FAIL || reason == WIFI_REASON_MIC_FAILURE) {
                NapicuHome::notify_wifi_auth_failed();
            } else {
                Serial.println("ESP32 bylo odpojeno od WiFi.");
                NapicuHome::notify_wifi_status_change();
            }

  
          
            break;
        }
        default:
            break;
    }
}


#include <NapicuSmartHome/include/NapicuSmartHome.h>


void NapicuHome::on_wifi_event(WiFiEvent_t event, WiFiEventInfo_t info) {
    switch (event) {
        case SYSTEM_EVENT_STA_GOT_IP:
            Serial.println(WiFi.SSID());
            Serial.println("ESP32 je úspěšně připojeno k WiFi.");
            NapicuHome::notify_wifi_status_change();
            break;
        case SYSTEM_EVENT_STA_DISCONNECTED: {
            uint8_t reason = info.wifi_sta_disconnected.reason;

            if (reason == WIFI_REASON_AUTH_EXPIRE || reason == WIFI_REASON_AUTH_FAIL || reason == WIFI_REASON_MIC_FAILURE) {
                
            } else {
                Serial.println("ESP32 bylo odpojeno od WiFi.");
                //NapicuHome::notify_wifi_status_change();
            }

  
            WiFi.disconnect();
            break;
        }
        default:
            break;
    }
}


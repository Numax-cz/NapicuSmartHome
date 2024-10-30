#include <NapicuSmartHome/include/NapicuSmartHome.h>


void NapicuHome::on_wifi_event(WiFiEvent_t event) {
    switch (event) {
        case SYSTEM_EVENT_STA_GOT_IP:
            Serial.println(WiFi.SSID());
            Serial.println("ESP32 je úspěšně připojeno k WiFi.");
            break;
        case SYSTEM_EVENT_STA_DISCONNECTED:
            Serial.println("ESP32 bylo odpojeno od WiFi.");
            break;
        default:
            break;
    }
}

#include <NapicuSmartHome/include/NapicuSmartHome.h>


void NapicuHome::WiFiConnectCharacteristicCallback::onWrite(BLECharacteristic *pCharacteristic) {
    std::string received_data = pCharacteristic->getValue();

    size_t delimiter_pos = received_data.find("|");

    if(delimiter_pos != std::string::npos) {
        std::string ssid = received_data.substr(0, delimiter_pos);
        std::string password = received_data.substr(delimiter_pos + 1);

        Serial.println("SSID: " + String(ssid.c_str()));
        Serial.println("Password: " + String(password.c_str()));

        WiFi.begin(ssid.c_str(), password.c_str());
    }
}
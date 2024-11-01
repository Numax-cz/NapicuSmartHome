#include <NapicuSmartHome/include/NapicuSmartHome.h>
#include <led.h>


#define DEFAULT_BLE_NAME "NapicuSmartHome"
#define SERVICE_UUID "cea986c2-4405-11ee-be56-0242ac120002" 

#define CHARACTERISTIC_WIFI_STATE_UUID "30db6768-1ee3-488b-8ef9-162a9b2af05c"


void setup() {
    Serial.begin(115200);

    Serial.println("Starting BLE work!");

    //Bluetooth
    NapicuHome::begin_ble(DEFAULT_BLE_NAME, SERVICE_UUID);

    //Homekit 
    homeSpan.setLogLevel(-1);
    NapicuHome::begin_home("11122333", Category::Lighting, "NapicuSvetlo");



    // // Skenování Wi-Fi sítí
    // int numOfNetworks = WiFi.scanNetworks();

    // if (numOfNetworks == 0) {
    //     Serial.println("Nebyly nalezeny žádné Wi-Fi sítě.");
    // } else {
    //     Serial.println("Nalezené Wi-Fi sítě:");
    //     for (int i = 0; i < numOfNetworks; ++i) {
    //     Serial.print(i + 1);
    //     Serial.print(": ");
    //     Serial.print(WiFi.SSID(i));
    //     Serial.print(" (RSSI: ");
    //     Serial.print(WiFi.RSSI(i));
    //     Serial.println(" dBm)");
    //     delay(10);
    //     }
    // }

    new SpanAccessory();
    new Service::AccessoryInformation();
    new Characteristic::Identify();
    new DEV_LED(2);

}

void loop() {
    homeSpan.poll();
}


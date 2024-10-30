#include <NapicuSmartHome/include/NapicuSmartHome.h>
#include <led.h>


#define DEFAULT_BLE_NAME "NapicuSmartHome"
#define SERVICE_UUID "cea986c2-4405-11ee-be56-0242ac120002" 


void setup() {
    Serial.begin(115200);

    Serial.println("Starting BLE work!");

    //Bluetooth
    NapicuHome::begin_ble(DEFAULT_BLE_NAME, SERVICE_UUID);

    //Homekit 
    homeSpan.setLogLevel(-1);
    NapicuHome::begin_home("11122333", Category::Lighting, "NapicuSvetlo");


    if (NapicuHome::wifi_credentials_exists()) {
        Serial.println("WiFi údaje jsou uloženy.");
    } else {
        Serial.println("WiFi údaje nejsou uloženy.");
    }

  

    new SpanAccessory();
    new Service::AccessoryInformation();
    new Characteristic::Identify();
    new DEV_LED(2);

}

void loop() {
    homeSpan.poll();
}


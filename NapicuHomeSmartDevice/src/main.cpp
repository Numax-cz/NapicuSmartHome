#include <NapicuSmartHome/include/NapicuSmartHome.h>
#include <led.h>




#define DEFAULT_BLE_NAME "NapicuSmartHome"



void setup() {
    Serial.begin(115200);

    //Bluetooth
    NapicuHome::begin_ble(DEFAULT_BLE_NAME);

    //Homekit 
    homeSpan.setLogLevel(-1);
    NapicuHome::begin_home("11122333", Category::Lighting, "NapicuSvetlo");

    new SpanAccessory();
    new Service::AccessoryInformation();
    new Characteristic::Identify();
    new DEV_LED(2);


}

void loop() {
    //homeSpan.poll();
}


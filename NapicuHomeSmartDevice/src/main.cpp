#include <NapicuSmartHome/include/NapicuSmartHome.h>

#define DEFAULT_BLE_NAME "NapicuSmartHome"


#define SERVICE_UUID "cea986c2-4405-11ee-be56-0242ac120002" 


void setup() {
  Serial.begin(9600);

  Serial.println("Starting BLE work!");

  BLEDevice::init(DEFAULT_BLE_NAME);
  BLEServer *pServer = BLEDevice::createServer();
    //Nastavení zpětného volání pro server
  pServer->setCallbacks(new ServerCallBack());


  BLEService *pService = pServer->createService(SERVICE_UUID);
  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();

}

void loop() {

}


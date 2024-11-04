#pragma once

#include <HomeSpan.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <NapicuSmartHome/include/config.h>


class NapicuHome {



public:
    /**
     * @brief ESP32 WiFi connection status types
     * 
     */
    enum class WiFiState {
        WiFiNoCredentials=0,    /* ESP32 has no WiFi connection data */
        WiFiConnected=1,        /* ESP32 is connected to WiFi */
        WiFiDisconected=2       /* ESP32 is disconnected from WiFi */
    };

    /**
     * @brief Starts service for apple homekit
     * 
     * @param pairingCode Pairing code for apple home kit
     * @param catID Accessory category ID 
     * @param displayName Name that will be displayed
     * @param hostNameBase Name of host
     * @param modelName Name of model
     */
    static void begin_home(const char *pairingCode, Category catID = Category::Lighting, const char *displayName = "HomeSpan Server", const char *hostNameBase = "HomeSpan", const char *modelName = "HomeSpan-ESP32");
    /**
     * @brief Starts Bluetooth low energy service
     * 
     * @param deviceName Name that will be displayed
     */
    static void begin_ble(const char *deviceName);
    /**
     * @brief Get the wifi status
     * 
     * @return WiFiState 
     */
    static NapicuHome::WiFiState get_wifi_status();


private:
    static BLEServer *ble_server;
    static BLEService *ble_service;
    static BLEAdvertising *ble_advertising;

    class ServerCallBack : public BLEServerCallbacks {
    public:
        void onConnect(BLEServer* pServer, esp_ble_gatts_cb_param_t *param);
        void onDisconnect(BLEServer* pServer);
    };
    /**
     * @brief Characteristics for network status query 
     * 
     */
    class WiFiStateCharacteristicCallback : public BLECharacteristicCallbacks {
    public:
        void onRead(BLECharacteristic *pCharacteristic); 
    };
    /**
     * @brief Characteristics for network status query 
     * 
     */
    class WiFiListCharacteristicCallback : public BLECharacteristicCallbacks {
    public:
        void onRead(BLECharacteristic *pCharacteristic); 
    };
    /**
     * @brief Returns whether the data from the wifi network is saved.
     * But not if the device is connected!
     * 
     * @return true 
     * @return false 
     */
    static bool wifi_credentials_exists();

    static void on_wifi_event(WiFiEvent_t event);
    static void ble_gap_event_handler(esp_gap_ble_cb_event_t  event, esp_ble_gap_cb_param_t* param);
};


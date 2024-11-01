#pragma once

#include <HomeSpan.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>




class NapicuHome {

public:
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
     * @param uuid Service UUID
     */
    static void begin_ble(const char *deviceName, const char *uuid);
    /**
     * @brief Returns whether the data from the wifi network is saved
     * 
     * @return true 
     * @return false 
     */
    static bool wifi_credentials_exists();

private:
    static BLEServer *ble_server;
    static BLEService *ble_service;
    static BLEAdvertising *ble_advertising;

    class ServerCallBack : public BLEServerCallbacks {
    public:
        void onConnect(BLEServer* pServer, esp_ble_gatts_cb_param_t *param);
        void onDisconnect(BLEServer* pServer);
    };


    static void on_wifi_event(WiFiEvent_t event);
    static void ble_gap_event_handler(esp_gap_ble_cb_event_t  event, esp_ble_gap_cb_param_t* param);
};


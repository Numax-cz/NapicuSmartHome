#pragma once

#include "main.h"

class ServerCallBack : public BLEServerCallbacks {
public:
    void onConnect(BLEServer* pServer, esp_ble_gatts_cb_param_t *param);
    void onDisconnect(BLEServer* pServer);
};


//
//  Config.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 02.11.2024.
//

import CoreBluetooth

struct Config {
    
    /**
     * Specifies the allowed UUIDs for device pairing.
     * If you have multiple versions of devices,
     * you can add their corresponding UUIDs to this list.
     */
    static let BL_ALLOWED_UUIDS = [CBUUID(string: "73f4a352-06ff-4c15-aaf8-4a498e882d50")]
    /**
     * Specifies the UUID used to retrieve the Wi-Fi status
     * from the connected device.
     */
    static let BL_WIFI_STATE_CHARACTERISTIC_UUID: CBUUID = CBUUID(string: "803b6053-c7cf-4594-aa77-3ca2ff8d4a5e")
    /**
     * Specifies the UUID used to retrieve the list of available
     * Wi-Fi networks from the connected device.
     */
    static let BL_WIFI_LIST_CHARACTERISTIC_UUID: CBUUID = CBUUID(string: "fe8c0e2c-daab-4eb7-a0d1-057044d931c0")
    
    
    /**
     * Configuration parameters for device pairing functionality.
     * These settings control the timing and intervals related to
     * device discovery, connection attempts, and status checks.
     */
    
    /**
     * Duration after which the list of found devices is updated.
     */
    static let BL_PAIR_UPDATE_SCAN_INTERVAL: TimeInterval = 3.0
    /**
     * Specifies the duration that the device will
     * attempt to connect to another device.
     */
    static let BL_PAIR_CONNECTION_TIMEOUT: TimeInterval = 10.0
    /**
     *
     * Specifies the duration after which automatic scanning will be stopped.
     */
    static let BL_PAIR_SCAN_TIME_OUT: TimeInterval = 17.0
    /**
     * Specifies the duration after which a device will be marked as inactive.
     */
    static let BL_PAIR_PERIPHERAL_EXPIRATION_TIME: TimeInterval = 3.0
    /**
     * Frequency at which the device status is checked.
     */
    static let BL_PAIR_PERIPHERAL_CHECK_STATE_INTERVAL: TimeInterval = 0.5
}

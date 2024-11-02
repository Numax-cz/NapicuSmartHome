//
//  DeviceManager.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 31.10.2024.
//
import CoreBluetooth
import SwiftUI

class DeviceManager: ObservableObject {
    var peripheral: CBPeripheral
    @Published public var isConnectedToWiFi: Bool = false
    @Published public var nearbyNetworks: [String] = []
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
}

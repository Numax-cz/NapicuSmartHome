//
//  NapicuHomeBluetooth.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 15.10.2024.
//

import CoreBluetooth

struct DiscoveredPeripheral {
    var peripheral: CBPeripheral
    var lastUpdate: Date
}

struct PeripheralDisplayItem {
    let name: String
    let uuid: UUID
}

class BluetoothManager: NSObject, ObservableObject, CBPeripheralDelegate {
    private var centralManager: CBCentralManager?
    private var foundPeripherals: [DiscoveredPeripheral] = []

    private var allowedUUIDS = [CBUUID(string: "cea986c2-4405-11ee-be56-0242ac120002")]
    
    private var timer: Timer?
    
    @Published var foundPeripheralsNames: [PeripheralDisplayItem] = [
        PeripheralDisplayItem(name: "Device #1", uuid: UUID()),
        PeripheralDisplayItem(name: "Device #2", uuid: UUID()),
        PeripheralDisplayItem(name: "Device #3", uuid: UUID()),
        PeripheralDisplayItem(name: "Device #3", uuid: UUID())
    ]
    @Published var scanning: Bool = false

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func startScan() {
        if(!self.scanning && centralManager?.state == .poweredOn) {
            self.centralManager?.scanForPeripherals(withServices: nil)
            self.scanning = true
         
            self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
                self?.updateScan()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
                self?.stopScan()
            }
        }
    }
    
    func stopScan() {
        self.scanning = false
        self.centralManager?.stopScan()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    func updateScan() {
        if(!foundPeripherals.isEmpty) {
            print("Bluetooth scan update")

            let currentDate = Date()

            foundPeripherals.removeAll { peripheral in
                let isExpired = currentDate.timeIntervalSince(peripheral.lastUpdate) > 3.0
                if isExpired {
                    foundPeripheralsNames.removeAll { $0.name == peripheral.peripheral.name }
                    print("Removed \(peripheral.peripheral.name ?? "Unknown")")
                }
                return isExpired
            }
            
            self.centralManager?.stopScan()
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func connectToPeripheral(with uuid: UUID) {
        self.stopScan()
        guard let discoveredPeripheral = foundPeripherals.first(where: { $0.peripheral.identifier == uuid }) else {
            return
        }
        
//        self.centralManager?.connect(discoveredPeripheral.peripheral, options: nil)
//        discoveredPeripheral.peripheral.delegate = self
    }
    
    

}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        if let index = foundPeripherals.firstIndex(where: { $0.peripheral == peripheral }) {
            foundPeripherals[index].lastUpdate = Date()
            return
        }

        if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            if serviceUUIDs.contains(where: { allowedUUIDS.contains($0) }) {
                if let name = peripheral.name {
                    foundPeripherals.append(DiscoveredPeripheral(peripheral: peripheral, lastUpdate: Date()))
                    
                    foundPeripheralsNames.append(PeripheralDisplayItem(name: name, uuid: peripheral.identifier))
                }
            }
        }
    }
}

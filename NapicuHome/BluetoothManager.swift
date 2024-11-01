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
    
    private var scanTimer: Timer?
    
    private var autoStopScanWork: DispatchWorkItem?
    
    var connectedPeripheral: DeviceManager?
    
    @Published public var alertManager = NapicuAlertManager()
    
    @Published var foundPeripheralsNames: [PeripheralDisplayItem] = {
            #if targetEnvironment(simulator)
                return [
                    //For debugging
                    PeripheralDisplayItem(name: "NapicuHome #1", uuid: UUID()),
                    PeripheralDisplayItem(name: "NapicuHome #2", uuid: UUID()),
                    PeripheralDisplayItem(name: "NapicuHome #3", uuid: UUID()),
                    PeripheralDisplayItem(name: "NapicuHome #4", uuid: UUID()),
                ]
            #else
                return []
            #endif
            }()
    
    @Published var scanning: Bool = false

    @Published var noAvailableDevices: Bool = false

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func startScan() {
        #if targetEnvironment(simulator)
            self.scanning = true
        #endif
        if(!self.scanning && centralManager?.state == .poweredOn) {
            self.centralManager?.scanForPeripherals(withServices: nil)
            self.scanning = true
         
            self.scanTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
                self?.updateScan()
            }
            
            autoStopScanWork?.cancel()
            
            autoStopScanWork = DispatchWorkItem { [weak self] in
                self?.stopScan()
            }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 17.0, execute: autoStopScanWork!)
        }
    }
    
    func stopScan() {
        self.scanning = false
        self.centralManager?.stopScan()
        self.scanTimer?.invalidate()
        self.scanTimer = nil
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

        if (centralManager?.state == .poweredOn) {
              let peripherals = centralManager?.retrievePeripherals(withIdentifiers: [uuid])
            if let peripheral = peripherals?.first {
                peripheral.delegate = self
                centralManager?.connect(peripheral, options: nil)
                connectedPeripheral =  DeviceManager(peripheral: peripheral)
                UserDefaults.standard.set(uuid.uuidString, forKey: "previousConnectedDeviceUUID")
              } else {
                  alertManager = NapicuAlertManager(
                      title: "Error",
                      message: "Unable to find device",
                      primaryButtonAction: NapicuAlertButton(title: "ok", action: {})
                  )
            
                  alertManager.show()
              }
        } else {
            alertManager = NapicuAlertManager(
                title: "Bluetooth Error",
                message: "Bluetooth is not enabled",
                primaryButtonAction: NapicuAlertButton(title: "ok", action: {})
            )
      
            alertManager.show()
        }
    }
    
    func connectToPreviousPeripheral() {
        if let savedUUIDString = UserDefaults.standard.string(forKey: "previousConnectedDeviceUUID"),
           let uuid = UUID(uuidString: savedUUIDString) {
            connectToPeripheral(with: uuid)
        
        }
    }
    
    func isDeviceConnected() -> Bool {
        return connectedPeripheral != nil
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOn:
                print("Bluetooth is powered on.")
                connectToPreviousPeripheral()
            case .poweredOff:
                print("Bluetooth is powered off.")
            case .resetting:
                print("Bluetooth is resetting.")
            case .unauthorized:
                print("Application is not authorized to use Bluetooth.")
            case .unsupported:
                print("This device does not support Bluetooth.")
            case .unknown:
                print("Bluetooth state is unknown.")
            @unknown default:
                print("Unexpected Bluetooth state.")
        }
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
    
  
    
    // Successful
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Successfully connected to the device: \(peripheral.name ?? "unknown device")")
        peripheral.discoverServices(nil)
    }

    // Failed
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("Connection failed: \(error.localizedDescription)")
        } else {
            print("Failed to connect to the device.")
        }
    }

    // Disconnected
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("Device disconnected with error: \(error.localizedDescription)")
        } else {
            print("Device was disconnected.")
        }
    }
}

import SwiftUI
import CoreBluetooth

struct DevicesListView: View {

    @ObservedObject var bluetoothManager: BluetoothManager
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    VStack {
                        ForEach(
                            bluetoothManager.foundPeripheralsNames, id: \.uuid
                        ) { device in

                            Button(action: {
                                bluetoothManager.connectToPeripheral(with: device.uuid)
                            }) {
                                HStack {
                                    Image(systemName: "homekit")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.blue)
                                        .padding(1)
                                        .padding(.leading, 10)
                                    Text(device.name)
                                    
                                        .fontWeight(.bold)
                                        .padding(.top)
                                        .padding(.bottom)
                                        .font(
                                            .system(
                                                size: geometry.size.height
                                                    > geometry.size.width
                                                    ? geometry.size.width * 0.04
                                                    : geometry.size.height * 0.04)
                                        )
                                }
             

                                    .frame(
                                        width: geometry.size.height
                                            > geometry.size.width
                                            ? geometry.size.width * 0.8
                                            : geometry.size.width * 0.8,
                                        alignment: .leading
                                    )
                                    .background(Color.black.opacity(0.1))
                                    .cornerRadius(10)
                                    .padding(.vertical, 2)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    .padding(10)
                    .padding(.top, 40.0)
                    
                    if(bluetoothManager.scanning) {
                            LoadingView()
                    }
                
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
    
      
           
            
           
        }
    
    }
}

struct WiFiListView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @ObservedObject var deviceManager: DeviceManager
    @State private var selectedWiFi: String?
    @FocusState private var isPasswordFocused: Bool
    @State private var wifiPasswordUserInput: String = ""
    

    var body: some View {
        GeometryReader { geometry in
            if(selectedWiFi != nil) {
                HStack {
                    Button(action: {
                        selectedWiFi = nil
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                     
                            .foregroundColor(Color.black.opacity(0.7))
                            .frame(
                                width: geometry.size.height
                                > geometry.size.width
                                ? geometry.size.width * 0.045
                                : geometry.size.width * 0.045)
                            .padding(.leading, geometry.size.height
                                     > geometry.size.width
                                     ? geometry.size.width * 0.07
                                     : geometry.size.height * 0.07)
                            .padding(.top, geometry.size.height
                                     < geometry.size.width
                                     ? geometry.size.width * 0.015
                                     : geometry.size.height * 0.015)
                    }.contentShape(Rectangle())
                }
            }
        
            
            VStack {
                Spacer()
                Image(systemName: "wifi")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.height
                        > geometry.size.width
                        ? geometry.size.width * 0.30
                        : geometry.size.width * 0.30)
                    .foregroundColor(.blue)
                    .padding(.top, geometry.size.height
                             < geometry.size.width
                             ? geometry.size.width * 0.04
                             : geometry.size.height * 0.04)
                Text(selectedWiFi != nil ? "Enter password for \(selectedWiFi!)" : "Connect a smart device to your WiFi")
                    .fontWeight(.bold)
                    .padding(.top, geometry.size.height
                             < geometry.size.width
                             ? geometry.size.width * 0.04
                             : geometry.size.height * 0.04)
                    .font(
                        .system(
                            size: geometry.size.height
                                > geometry.size.width
                                ? geometry.size.width * 0.04
                                : geometry.size.height * 0.04)
                    )
                VStack {
                    if let wifi_name = selectedWiFi {
                        VStack {
                            Text(wifi_name)
                                .fontWeight(.bold)
                                .padding()
                                .font(
                                    .system(
                                        size: geometry.size.height
                                            > geometry.size.width
                                            ? geometry.size.width * 0.04
                                            : geometry.size.height * 0.04)
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(
                                width: geometry.size.height
                                    > geometry.size.width
                                    ? geometry.size.width * 0.8
                                    : geometry.size.width * 0.8,
                                alignment: .leading
                            )
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                            .foregroundStyle(.black)
                        
                        
                        VStack {
                            SecureField("Enter password", text: $wifiPasswordUserInput)
                                .fontWeight(.bold)
                                .padding()
                                .font(
                                    .system(
                                        size: geometry.size.height
                                            > geometry.size.width
                                            ? geometry.size.width * 0.04
                                            : geometry.size.height * 0.04)
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .focused($isPasswordFocused)
                            }
                            .frame(
                                width: geometry.size.height
                                    > geometry.size.width
                                    ? geometry.size.width * 0.8
                                    : geometry.size.width * 0.8,
                                alignment: .leading
                            )
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                            .foregroundStyle(.black)
                            .onAppear {
                                isPasswordFocused = true
                            }
                        
                        VStack {
                            Button(action: {
                                deviceManager.connectToWiFi(ssid: wifi_name, pwd: wifiPasswordUserInput)
                            }) {
                                Text("Connect")
                                    .fontWeight(.bold)
                                    .padding()
                                    .font(
                                        .system(
                                            size: geometry.size.height
                                                > geometry.size.width
                                                ? geometry.size.width * 0.04
                                                : geometry.size.height * 0.04)
                                    )
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }.disabled(wifiPasswordUserInput.count < 8)
            
                            }
                            .frame(
                                width: geometry.size.height
                                    > geometry.size.width
                                    ? geometry.size.width * 0.4
                                    : geometry.size.width * 0.4,
                                alignment: .leading
                            )
                            .background(wifiPasswordUserInput.count < 8 ? Color.gray : Color.blue)
                            .foregroundStyle(wifiPasswordUserInput.count < 8 ? Color.white.opacity(0.6) : Color.white)
                            .cornerRadius(10)
                            .padding(.vertical, 2)
                            .padding(.top, 10)
                        Spacer()
                    } else {
                        ScrollView {
                            if deviceManager.nearbyNetworks.isEmpty {
                                VStack {
                                    LoadingView()
                                }.padding(.top, 50)
                            } else {
                                VStack {
                                    ForEach(
                                        deviceManager.nearbyNetworks, id: \.ssid
                                    ) { wifi in
                                        Button(action: {
                                            if(wifi.auth_mode == 0){
                                                //TODO
                                            } else {
                                                selectedWiFi = wifi.ssid
                                            }
                                        }) {
                                            HStack {
                                                Text(wifi.ssid)
                                                    .fontWeight(.bold)
                                                    .padding()
                                                    .font(
                                                        .system(
                                                            size: geometry.size.height
                                                            > geometry.size.width
                                                            ? geometry.size.width * 0.04
                                                            : geometry.size.height * 0.04))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Spacer()
                                                Image(systemName: "lock.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(wifi.auth_mode == 0 ? Color.clear :  Color.black.opacity(0.8))
                                                    .padding()
                                            }
                                            
                                        }
                                        .frame(
                                            width: geometry.size.height
                                            > geometry.size.width
                                            ? geometry.size.width * 0.8
                                            : geometry.size.width * 0.8,
                                            alignment: .leading
                                        )
                                        
                                        .background(Color.black.opacity(0.1))
                                        .cornerRadius(10)
                                        .padding(.vertical, 2)
                                        .foregroundStyle(.black)
                                    }
                                }
                                .padding(10)
                            }
                        }
                        .padding(.bottom,
                                geometry.size.height
                               < geometry.size.width
                               ? geometry.size.width * 0.11
                               : geometry.size.height * 0.11)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 10)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
    }
}

struct LoadingView: View {
    @State private var spacingAnimation = true
    @State var text: String?

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: spacingAnimation ? CGFloat(15) : CGFloat(10)) {
                    Capsule(style: .continuous)
                        .fill(.blue)
                        .frame(width: 10, height: 60)
                    
                    Capsule(style: .continuous)
                        .fill(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                        .frame(width: 10, height: 40)
                    
                    Capsule(style: .continuous)
                        .fill(.blue)
                        .frame(width: 10, height: 60)
                    
                    Capsule(style: .continuous)
                        .fill(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                        .frame(width: 10, height: 40)
                    
                    Capsule(style: .continuous)
                        .fill(.blue)
                        .frame(width: 10, height: 60)

                }
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 1).repeatForever(
                            autoreverses: true)
                    ) {
                        spacingAnimation.toggle()
                    }
                }
                if let text = text {
                    HStack {
                        Text(text)
                            .bold()
                            .foregroundColor(.gray.opacity(0.65))
                            .padding(
                                .top,
                                geometry.size.height > geometry.size.width
                                    ? geometry.size.width * 0.05
                                    : geometry.size.height * 0.05)
                    }

                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }	
    }
}

struct DeviceNotFound: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {

            }
        }
    }
}

struct ContentView: View {

    @StateObject private var bluetoothManager = BluetoothManager()
    
    @State private var isAlertPresented = false


    var body: some View {
        if let connectedPeripheral = bluetoothManager.connectedPeripheral {
            if(bluetoothManager.connectedPeripheral?.wifiStatus == .connected) {
                DeviceAppView(bluetoothManager: bluetoothManager)
            }
            else if(bluetoothManager.connectedPeripheral?.wifiStatus == .noCredentials) {
                
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        WiFiListView(bluetoothManager: bluetoothManager, deviceManager: connectedPeripheral)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        else {
            GeometryReader { geometry in
                VStack {
                    Spacer()

                    if bluetoothManager.scanning && bluetoothManager.foundPeripheralsNames.isEmpty {
                        LoadingView(text: "Searching for devices...")
                    } else {
                        DevicesListView(bluetoothManager: bluetoothManager)
                    }

                    Button(action: {
                        if(bluetoothManager.scanning) {
                            bluetoothManager.stopScan()
                        } else {
                            bluetoothManager.startScan()
                        }
                    }) {

                        Text(bluetoothManager.scanning ? "Stop" : "Add new device")
                            .frame(width: geometry.size.width * 0.7, height: 50)
                            .font(
                                .system(
                                    size: geometry.size.height > geometry.size.width
                                        ? geometry.size.width * 0.05
                                        : geometry.size.height * 0.05)
                            )
                            .background(
                                bluetoothManager.scanning ? Color.red : Color.blue
                            )
                            .foregroundColor(Color.white)
                            .cornerRadius(14)
                            .fontWeight(.bold)

                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .alert(title: bluetoothManager.alertManager.title,
                       message: bluetoothManager.alertManager.message,
                       primaryButton: bluetoothManager.alertManager.primaryButtonAction,
                       secondaryButton: bluetoothManager.alertManager.secondaryButtonAction,
                       isPresented: $bluetoothManager.alertManager.isAlertPresented)
            }
        }
    }
}




#Preview {
    //DeviceAppView(bluetoothManager: BluetoothManager())
    ContentView()
    //WiFiListView(bluetoothManager: BluetoothManager())
}

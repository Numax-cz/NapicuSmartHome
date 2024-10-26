import SwiftUI

struct DevicesView: View {

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

struct LoadingView: View {
    @State private var spacingAnimation = true

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

                HStack {
                    Text("Searching for devices...")
                        .bold()
                        .foregroundColor(.gray.opacity(0.65))
                        .padding(
                            .top,
                            geometry.size.height > geometry.size.width
                                ? geometry.size.width * 0.05
                                : geometry.size.height * 0.05)
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
        if(bluetoothManager.isDeviceConnected()) {
            DeviceView()
        } else {
            GeometryReader { geometry in
                VStack {
                    Spacer()

                    if bluetoothManager.scanning && bluetoothManager.foundPeripheralsNames.isEmpty {
                        LoadingView()
                    } else {
                        DevicesView(bluetoothManager: bluetoothManager)
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
    DeviceView()
}

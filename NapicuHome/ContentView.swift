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
                            Button(action: {}) {
                                Text(device.name)
                                    .fontWeight(.bold)
                                    .padding()
                                    .font(
                                        .system(
                                            size: geometry.size.height
                                                > geometry.size.width
                                                ? geometry.size.width * 0.04
                                                : geometry.size.height * 0.04)
                                    )

                                    .frame(
                                        width: geometry.size.height
                                            > geometry.size.width
                                            ? geometry.size.width * 0.9
                                            : geometry.size.width * 0.9,
                                        alignment: .leading
                                    )
                                    .background(Color.black.opacity(0.1))
                                    .cornerRadius(10)
                                    .padding(.vertical, 5)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    .padding(10)
                    .padding(.top, 40.0)
                }
            }
            .transition(.opacity)
        }
    }
}

struct LoadingView: View {
    @State private var spacingAnimation = false
    @State private var isBreathing = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

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

                Text("Searching for devices...")
                    .bold()
                    .foregroundColor(isBreathing ? .gray : .gray.opacity(0.65))

                    .padding(
                        .top,
                        geometry.size.height > geometry.size.width
                            ? geometry.size.width * 0.05
                            : geometry.size.height * 0.05)
                Spacer().frame(height: geometry.size.height * 0.4)

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

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                if bluetoothManager.scanning {
                    LoadingView()
                } else {
                    DevicesView(bluetoothManager: bluetoothManager)
                }

                Button(action: {
                    withAnimation {
                        if bluetoothManager.scanning {
                            bluetoothManager.stopScan()
                            return
                        }
                        bluetoothManager.startScan()
                    }
                }) {

                    Text(bluetoothManager.scanning ? "Stop" : "Search")
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
            .animation(.easeInOut, value: bluetoothManager.scanning)  //TODO nevím k čemu to patří
        }
    }
}

#Preview {
    ContentView()
}

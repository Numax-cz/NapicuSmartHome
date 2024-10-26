//
//  HomeView.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 23.10.2024.
//
import SwiftUI

enum DeviceCurrentView {
    case home
    case settings
}


struct DeviceView: View {
    @State private var showMenu = false
    @State private var selectedView: DeviceCurrentView = .settings
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }) {
                            HStack(spacing: 10) {
                                  Circle()
                                      .frame(width: 10, height: 10)
                                      .offset(x: showMenu ? 5 : 0)
                                  Circle()
                                      .frame(width: 10, height: 10)
                                      .offset(y: showMenu ? 12 : 0)
                                  
                                  Circle()
                                      .frame(width: 10, height: 10)
                                      .offset(x: showMenu ? -5 : 0)
                              }
                              .foregroundColor(.black)
                                .padding(.trailing, 15)
                        }
                    }.padding()
                    
                    VStack {
                        VStack {
                            switch selectedView {
                            case .home:
                                DeviceInfoView()
                                    .transition(
                                        .asymmetric(insertion: .move(edge: .leading).combined(with: .opacity),
                                                                             removal: .move(edge: .trailing).combined(with: .opacity)))
                            case .settings:
                                SettingsView()
                                    .transition(
                                        .asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                                  removal: .move(edge: .leading).combined(with: .opacity)))
                            }
                        }    .animation(.easeInOut(duration: 0.5), value: selectedView)
              
                 
                        
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                selectedView = .home
                            }) {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(20)
                            }
                            Spacer()
                            
                            Button(action: {
                                selectedView = .settings
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(20)
                            }
                        }
                        .frame(maxWidth: 350)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                
    
                if showMenu {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .zIndex(100)
                        .onTapGesture {
                            withAnimation {
                               showMenu = false
                           }
                        }
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 20) {
                            Button(action: {
                            
                            }) {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .scaledToFit()
                                  
                                    .frame(width: 30, height: 30)
                               
                                Text("Add Device")
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                            }
                            Divider()
                                .background(Color.gray)
                            
                            Button(action: {
                          
                            }) {
                                Image(systemName: "qrcode.viewfinder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text("Scan QR code")
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                            }
                        }.padding(20)
                     
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(maxWidth: 190)
                    .position(x: geometry.size.width - 100, y: 120)
                    .transition(.opacity)
                    .zIndex(1000)
                }
            }
            
          
        }
    }
}

#Preview {
    DeviceView()
}

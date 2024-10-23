//
//  HomeView.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 23.10.2024.
//
import SwiftUI

struct HomeView: View {
    @State private var showMenu = true
    
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
                            HStack {
                                VStack {
                                
                                }
                                .frame(width: 130, height: 130)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                
                                Spacer()
                                
                                VStack {
                                
                                }
                                .frame(width: 130, height: 130)
                                .background(Color.blue)
                                .cornerRadius(20)
                            }
                            
                            HStack {
                                VStack {
                               
                                }
                                .frame(width: 130, height: 130)
                                .background(Color.blue)
                                .cornerRadius(20)
                                
                                Spacer()
                                
                                VStack {
                                 
                                }
                                .frame(width: 130, height: 130)
                                .background(Color.blue)
                                .cornerRadius(20)
                            }
                        }
                        .frame(maxWidth: 300)
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                        
                            }) {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(20)
                            }
                            Spacer()
                            
                            Button(action: {
                               
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
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 20) {
                            Button(action: {
                            
                            }) {
                                Image(systemName: "house.fill")
                                    .resizable()
                                    .scaledToFit()
                                  
                                    .frame(width: 30, height: 30)
                               
                                Text("Add Device")
                        
                                    
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                            }
                            
                            Button(action: {
                          
                            }) {
                                Image(systemName: "qrcode.viewfinder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text("Scan QR code")
                           
                           
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                            }
                        }.padding(20)
                       
                        
                     
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .frame(width: 250)
                    .position(x: geometry.size.width - 100, y: 105)
                    .transition(.opacity)
                    .zIndex(20)
                }
            }
            
          
        }
    }
}

#Preview {
    HomeView()
}

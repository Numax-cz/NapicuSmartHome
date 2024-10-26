//
//  MainView.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 23.10.2024.
//

import SwiftUI

struct DeviceInfoView: View {
    var body: some View {
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
    }
}

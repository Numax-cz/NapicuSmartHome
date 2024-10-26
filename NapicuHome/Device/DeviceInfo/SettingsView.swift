//
//  SettingsView.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 23.10.2024.
//

import SwiftUI

struct SettingsInfoBox: View {
    private var info_text_padding: CGFloat = 20
    private var info_box_height: CGFloat = 60
    
    public var boxTitle: String
    public var boxDescription: String
    
     init(boxTitle: String, boxDescription: String) {
         self.boxTitle = boxTitle
         self.boxDescription = boxDescription
     }

    var body: some View {
        GeometryReader { geometry in
            VStack() {
                HStack {
                    Text(boxTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Text(boxDescription)
                }.padding(info_text_padding)
            }
            .frame(width: geometry.size.width * 0.8, height: info_box_height)
            .background(NapicuStyles.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(NapicuStyles.boxCornerRadius)
            .frame(maxWidth: .infinity)
        }  .frame(maxWidth: .infinity, maxHeight: info_box_height)
    }
}


struct SettingsView: View {
  
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack() {
                    Text("NapicuDevice")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.8, height: 150)
                .background(NapicuStyles.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(NapicuStyles.boxCornerRadius)
                
                
                VStack {
                    Text("Device Info")
                        .font(.system(size: 20))
                        .frame(width: geometry.size.width * 0.8, alignment: .leading)
                   
                    
 
                         SettingsInfoBox(boxTitle: "Name", boxDescription: "NapiucHome >")
                         SettingsInfoBox(boxTitle: "Fimware version", boxDescription: "1.0.0")
                 
           


           
                } .padding(.top, 20)
                
                
              
             
           
                
                
            }.frame(maxWidth: .infinity)
              
            
        }

    }
}

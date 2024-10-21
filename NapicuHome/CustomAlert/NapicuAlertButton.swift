//
//  NapicuAlertButton.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 20.10.2024.
//

import SwiftUI

struct NapicuAlertButton: View {


    let title: LocalizedStringKey
    var action: (() -> Void)? = nil
    
    

    var body: some View {
        Button {
          action?()
        
        } label: {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
        }
        .frame(height: 30)
        .background(Color.blue)
        .cornerRadius(8)
    }
}

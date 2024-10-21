//
//  NapicuAlertModifer.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 20.10.2024.
//

import SwiftUI

struct NapicuAlertModifier {

    // MARK: - Value
    // MARK: Private
    @Binding private var isPresented: Bool

    // MARK: Private
    private let title: String
    private let message: String
    private let dismissButton: NapicuAlertButton?
    private let primaryButton: NapicuAlertButton?
    private let secondaryButton: NapicuAlertButton?
}


extension NapicuAlertModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
        GeometryReader { geometry in
            ZStack() {
                
                Color.clear
                .edgesIgnoringSafeArea(.all)
    
               if(isPresented) {
                   NapicuAlert(title: title, message: message, dismissButton: dismissButton, primaryButton: primaryButton, secondaryButton: secondaryButton)
               }
                    
                
            }
               
        }
    }
}

extension NapicuAlertModifier {

    init(title: String = "", message: String = "", dismissButton: NapicuAlertButton, isPresented: Binding<Bool>) {
        self.title         = title
        self.message       = message
        self.dismissButton = dismissButton
    
        self.primaryButton   = nil
        self.secondaryButton = nil
    
        _isPresented = isPresented
    }

    init(title: String = "", message: String = "", primaryButton: NapicuAlertButton, secondaryButton: NapicuAlertButton? = nil, isPresented: Binding<Bool>) {
        self.title           = title
        self.message         = message
        self.primaryButton   = primaryButton
        self.secondaryButton = secondaryButton
    
        self.dismissButton = nil
    
        _isPresented = isPresented
    }
}

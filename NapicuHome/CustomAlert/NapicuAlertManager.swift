//
//  NapicuAlertManager.swift
//  NapicuHome
//
//  Created by Marcel Mikoláš on 21.10.2024.
//
import SwiftUI

class NapicuAlertManager: ObservableObject {
    @Published var isAlertPresented = false
    @Published var title = "NULL"
    @Published var message = "NULL"
    @Published var primaryButtonAction: NapicuAlertButton =
        NapicuAlertButton(title: "NULL")
    @Published var secondaryButtonAction: NapicuAlertButton? = nil
    
    init() {}
    
    init(title: String = "", message: String = "", primaryButtonAction: NapicuAlertButton, secondaryButtonAction: NapicuAlertButton? = nil) {
        self.title = title
        self.message = message
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonAction = secondaryButtonAction
    }
    
    public func show() {
        self.isAlertPresented = true
    }
}

//
//  Classes.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/15.
//

import Foundation
import SwiftUI
import MessageUI

class UserSettings: ObservableObject {
    @Published var loggedIn: Bool = UserDefaults.standard.bool(forKey: "loggedIn")
}

class UserOnboard: ObservableObject {
    // Include this only if a tutorial is used
    @Published var onboardComplete: Bool = true
}

class UserDetails: ObservableObject {
    var firstNames: String = ""
    var surname: String = ""
    var email: String = ""
}

class ChangedValues: ObservableObject {
    // Stores each of the changed key-value pairs of the questions and answers in the form
    @Published var changedValues: Dictionary<String, Any> = [:]
    @Published var hasChanged: Bool = false
    
    func updateKeyValue(_ key: String, value: Any) {
        changedValues.updateValue(value, forKey: key)
        hasChanged.toggle()
        //print("print - changedValues: \(changedValues)")
    }
    
    func removeValue(forKey key: String) {
        changedValues.removeValue(forKey: key)
        hasChanged.toggle()
        print("print - changedValues: \(changedValues)")
    }
    
    func cleanChangedValues() {
        changedValues.removeAll()
        hasChanged.toggle()
    }
}

class ApplicationDetails: ObservableObject {
    var appID: UUID = UUID()
}

class ApplicationCreation: ObservableObject {
    @Published var application: Application = Application()
    @Published var assetsLiabilitiesSaved: Bool = false
    @Published var residencyContactSaved: Bool = false
    @Published var personalDetailsSaved: Bool = false
    @Published var generalDetailsSaved: Bool = false
    @Published var subsidyCreditSaved: Bool = false
    @Published var documentScansSaved: Bool = false
    @Published var notificationSaved: Bool = false
    @Published var employmentSaved: Bool = false
    @Published var expensesSaved: Bool = false
    @Published var incomeSaved: Bool = false
    
    func makeApplication() {
        self.application = Application(context: PersistenceController.shared.container.viewContext)
    }
    
    func removeApplicationFromMemory() {
        self.application = Application()
        self.generalDetailsSaved = false
        self.assetsLiabilitiesSaved = false
        self.residencyContactSaved = false
        self.personalDetailsSaved = false
        self.subsidyCreditSaved = false
        self.notificationSaved = false
        self.employmentSaved = false
        self.expensesSaved = false
        self.incomeSaved = false
    }
}

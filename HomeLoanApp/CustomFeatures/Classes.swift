//
//  Classes.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/15.
//

import SwiftUI

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
    @Published var changedValues: Dictionary<String, Any> = [:] /*{
        didSet {
            print("print - changedValues: \(changedValues)")
        }
    }*/
    
    func updateKeyValue(_ key: String, value: Any) {
        changedValues.updateValue(value, forKey: key)
    }
    
    func cleanChangedValues() {
        changedValues.removeAll()
    }
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
    @Published var idxSaved: Bool = false
    @Published var poASaved: Bool = false
    
    func makeApplication() {
        application = Application(context: PersistenceController.shared.container.viewContext)
    }
    
    func removeApplicationFromMemory() {
        application = Application()
        generalDetailsSaved = false
        assetsLiabilitiesSaved = false
        residencyContactSaved = false
        personalDetailsSaved = false
        subsidyCreditSaved = false
        notificationSaved = false
        employmentSaved = false
        expensesSaved = false
        incomeSaved = false
        idxSaved = false
        poASaved = false
    }
}

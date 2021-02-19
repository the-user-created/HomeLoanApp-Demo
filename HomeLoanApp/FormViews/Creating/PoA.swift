//
//  PoA.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/19.
//

import SwiftUI

struct PoA: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    @State var poAName: String = ""
    @State var poAIdentityNumber: String = ""
    @State var poALocation: String = ""
    @State var poAContact: String = ""
    
    @State var signatureDone: Bool = false
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @Binding var isDone: Bool
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Text("POWER OF ATTORNEY FOR REQUESTING AND OBTAINING PERSONAL CREDIT RECORDS")
                    .font(.title3)
                    .bold()
                
                FormVStackTextField(iD: "poAName",
                                    question: "Full name and surname:",
                                    placeholder: "",
                                    text: $poAName)
                
                FormVStackTextField(iD: "poAIdentityNumber",
                                    question: "Identity/Passport/Registration Number",
                                    placeholder: "",
                                    text: $poAIdentityNumber)
                
                FormVStackTextField(iD: "poALocation",
                                    infoButton: true,
                                    question: "What is your current location",
                                    placeholder: "e.g. current suburb",
                                    text: $poALocation)
            }
            
            Section {
                Text("1. Do hereby appoint \(applicationCreation.application.salesConsultant ?? "") (“our Representative at evo”) to be our lawful representative and agent in our name, place and stead, to obtain a copy of our personal credit reports (“PCR”) from Experian South Africa (Pty) Ltd (“Experian”), to be used solely for the purpose of providing us with advice or assistance with managing our credit, by having reference to the content of our PCR’s.")
                
                Text("2. We consent to Experian releasing a copy of our PCR to our Representative and to our Representative having sight of the content of our PCR’s for the above purpose.")
            }
            
            Section {
                Text("Contact Details:")
                    .bold()
                
                Text("Cell number / other contact number:")
                    .font(.caption)
                
                FormTextField(iD: "poAContact",
                              question: "",
                              placeholder: "",
                              text: $poAContact)
            }
            
            Section(header: Text("Signature")) {
                SignatureView(loanID: applicationCreation.application.loanID?.uuidString,
                              signatureType: "poa", signatureDone: $signatureDone, alertMessage: $alertMessage, showingAlert: $showingAlert)
                    .frame(height: 300)
            }
            
            Section {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save changes")
                }
            }
        }
        .navigationBarTitle("Power of Attorney")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        
        if signatureDone && !poAName.isEmpty && !poAIdentityNumber.isEmpty && !poAContact.isEmpty && !poALocation.isEmpty {
            isComplete = true
        }
        
        return isComplete
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        isDone = determineComplete()
        
        if isDone {
            updateApplication()
            let loanID: String = applicationCreation.application.loanID?.uuidString ?? ""
            let details: [String: String] = ["NAME": poAName, "IDENTITY_NUMBER": poAIdentityNumber, "CONTACT": poAContact, "LOCATION": poALocation, "loanID": loanID]
             
            let result = PoACreator().exportToPDF(fileName: "poa_\(loanID).pdf", details: details)
             
            if result.0 {
                presentationMode.wrappedValue.dismiss()
            } else {
                alertMessage = result.1 ?? "Unknown error while saving PDF."
                showingAlert = true
            }
        } else if poAName.isEmpty {
            alertMessage = "Please add your full name and surname."
            showingAlert = true
        } else if poAIdentityNumber.isEmpty {
            alertMessage = "Please add your identity/passport/registration number."
            showingAlert = true
        } else if poALocation.isEmpty {
            alertMessage = "Please add a rough detail of your location (e.g. current suburb)."
            showingAlert = true
        } else if poAContact.isEmpty {
            alertMessage = "Please add your contact info."
            showingAlert = true
        } else if !signatureDone {
            alertMessage = "Please add your signature."
            showingAlert = true
        } else {
            alertMessage = "Please complete the form before attempting to save."
            showingAlert = true
        }
    }
    
    // MARK: - updateApplication
    private func updateApplication() {
        for (key, value) in changedValues.changedValues {
            applicationCreation.application.setValue(value, forKey: key)
        }
        
        do {
            try viewContext.save()
            print("print - Application Entity Updated")
            applicationCreation.poASaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}


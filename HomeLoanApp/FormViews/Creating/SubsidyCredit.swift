//
//  SubsidyCredit.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/11/30.
//

import SwiftUI

struct SubsidyCredit: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    // MARK: - State Variables
    @State var subsidyForHome = ""
    @State var applyingSubsidy = ""
    @State var housingScheme = ""
    @State var currentAdmin = ""
    @State var previousAdmin = ""
    @State var judgement = ""
    @State var debtReview = ""
    @State var debtReArrange = ""
    @State var insolvent = ""
    @State var creditBureau = ""
    @State var creditListings = ""
    @State var suretyAgreements = ""
    
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var isActive: Bool = false
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("SUBSIDY")) {
                FormYesNo(iD: "subsidyForHome",
                          question: formQuestions[3][0] ?? "MISSING",
                          selected: $subsidyForHome)
                
                FormYesNo(iD: "applyingSubsidy",
                          question: formQuestions[3][1] ?? "MISSING",
                          selected: $applyingSubsidy)
                
                FormYesNo(iD: "housingScheme",
                          question: formQuestions[3][2] ?? "MISSING",
                          selected: $housingScheme)
            }
            
            Section(header: Text("CREDIT HISTORY")) {
                FormYesNo(iD: "currentAdmin",
                          question: formQuestions[3][3] ?? "MISSING",
                          selected: $currentAdmin)
                
                FormYesNo(iD: "previousAdmin",
                          question: formQuestions[3][4] ?? "MISSING",
                          selected: $previousAdmin)
                
                FormYesNo(iD: "judgement",
                          question: formQuestions[3][5] ?? "MISSING",
                          selected: $judgement)
                
                FormYesNo(iD: "debtReview",
                          question: formQuestions[3][6] ?? "MISSING",
                          selected: $debtReview)
                
                FormYesNo(iD: "debtReArrange",
                          question: formQuestions[3][7] ?? "MISSING",
                          selected: $debtReArrange)
                
                FormYesNo(iD: "insolvent",
                          question: formQuestions[3][8] ?? "MISSING",
                          selected: $insolvent)
                
                FormYesNo(iD: "creditBureau",
                          question: formQuestions[3][9] ?? "MISSING",
                          selected: $creditBureau)
                
                FormYesNo(iD: "creditListings",
                          question: formQuestions[3][10] ?? "MISSING",
                          selected: $creditListings)
                
                FormYesNo(iD: "suretyAgreements",
                          question: formQuestions[3][11] ?? "MISSING",
                          selected: $suretyAgreements)
            }
            
            Section() {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Subsidy & Credit")
        .onReceive(resignPub) { _ in
            if isActive {
                handleSaving()
            }
        }
        .onDisappear() {
            isActive = false
        }
        .onAppear() {
            isActive = true
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        if !subsidyForHome.isEmpty && !applyingSubsidy.isEmpty && !housingScheme.isEmpty && !currentAdmin.isEmpty && !previousAdmin.isEmpty && !judgement.isEmpty && !debtReview.isEmpty && !debtReArrange.isEmpty && !insolvent.isEmpty && !creditBureau.isEmpty && !creditListings.isEmpty && !suretyAgreements.isEmpty {
            isComplete = true
        }
        
        changedValues.changedValues.updateValue(isComplete, forKey: "subsidyCreditDone")
        return isComplete
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if !changedValues.changedValues.isEmpty {
            isDone = determineComplete()
            saveApplication()
            presentationMode.wrappedValue.dismiss()
        } else {
            alertMessage = "Please complete some questions before attempting to save."
            showingAlert = true
        }
    }
    
    // MARK: - saveApplication
    private func saveApplication() {
        UIApplication.shared.endEditing()
        for (key, value) in changedValues.changedValues {
            applicationCreation.application.setValue(value, forKey: key)
        }
        
        do {
            try viewContext.save()
            print("print - Application Entity Updated")
            applicationCreation.subsidyCreditSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

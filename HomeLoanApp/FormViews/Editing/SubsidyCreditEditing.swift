//
//  SubsidyCreditEditing.swift
//  HomeLoanApp
//
//  Created by David Young on 2021/01/10.
//

import SwiftUI

struct SubsidyCreditEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
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
    
    @State var sender: Sender
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: Sender) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._subsidyForHome = State(wrappedValue: self.application.subsidyForHome ?? "")
        self._applyingSubsidy = State(wrappedValue: self.application.applyingSubsidy ?? "")
        self._housingScheme = State(wrappedValue: self.application.housingScheme ?? "")
        self._currentAdmin = State(wrappedValue: self.application.currentAdmin ?? "")
        self._previousAdmin = State(wrappedValue: self.application.previousAdmin ?? "")
        self._judgement = State(wrappedValue: self.application.judgement ?? "")
        self._debtReview = State(wrappedValue: self.application.debtReview ?? "")
        self._debtReArrange = State(wrappedValue: self.application.debtReArrange ?? "")
        self._insolvent = State(wrappedValue: self.application.insolvent ?? "")
        self._creditBureau = State(wrappedValue: self.application.creditBureau ?? "")
        self._creditListings = State(wrappedValue: self.application.creditListings ?? "")
        self._suretyAgreements = State(wrappedValue: self.application.suretyAgreements ?? "")
    }
    
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
                    Text("Save changes")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
                .disabled(changedValues.changedValues.isEmpty ? true : false)
            }
        }
        .navigationBarTitle("Subsidy & Credit")
        .onTapGesture(count: 2) {
            UIApplication.shared.endEditing()
        }
        .onReceive(resignPub) { _ in
            handleSaving()
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        /*if {
            return true
        }*/
        
        return false
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if !changedValues.changedValues.isEmpty {
            isDone = determineComplete()
            addToApplication()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - addToApplication()
    private func addToApplication() {
        UIApplication.shared.endEditing()
        
        for (key, value) in changedValues.changedValues {
            if sender == .creator {
                applicationCreation.application.setValue(value, forKey: key)
            } else {
                application.setValue(value, forKey: key)
            }
        }
        
        do {
            try viewContext.save()
            print("Application Entity Updated")
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

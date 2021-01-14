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
    
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let handleChangedValues = HandleChangedValues()
    
    var body: some View {
        Form() {
            Section(header: Text("SUBSIDY")) {
                FormYesNo(iD: "subsidyForHome", pageNum: 3,
                          question: formQuestions[3][0] ?? "MISSING",
                          selected: $subsidyForHome)
                
                FormYesNo(iD: "applyingSubsidy", pageNum: 3,
                          question: formQuestions[3][1] ?? "MISSING",
                          selected: $applyingSubsidy)
                
                FormYesNo(iD: "housingScheme", pageNum: 3,
                          question: formQuestions[3][2] ?? "MISSING",
                          selected: $housingScheme)
            }
            
            Section(header: Text("CREDIT HISTORY")) {
                FormYesNo(iD: "currentAdmin", pageNum: 3,
                          question: formQuestions[3][3] ?? "MISSING",
                          selected: $currentAdmin)
                
                FormYesNo(iD: "previousAdmin", pageNum: 3,
                          question: formQuestions[3][4] ?? "MISSING",
                          selected: $previousAdmin)
                
                FormYesNo(iD: "judgement", pageNum: 3,
                          question: formQuestions[3][5] ?? "MISSING",
                          selected: $judgement)
                
                FormYesNo(iD: "debtReview", pageNum: 3,
                          question: formQuestions[3][6] ?? "MISSING",
                          selected: $debtReview)
                
                FormYesNo(iD: "debtReArrange", pageNum: 3,
                          question: formQuestions[3][7] ?? "MISSING",
                          selected: $debtReArrange)
                
                FormYesNo(iD: "insolvent", pageNum: 3,
                          question: formQuestions[3][8] ?? "MISSING",
                          selected: $insolvent)
                
                FormYesNo(iD: "creditBureau", pageNum: 3,
                          question: formQuestions[3][9] ?? "MISSING",
                          selected: $creditBureau)
                
                FormYesNo(iD: "creditListings", pageNum: 3,
                          question: formQuestions[3][10] ?? "MISSING",
                          selected: $creditListings)
                
                FormYesNo(iD: "suretyAgreements", pageNum: 3,
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
                .disabled(changedValues.isEmpty ? true : false)
            }
        }
        .navigationBarTitle("Subsidy & Credit")
        .onTapGesture(count: 2, perform: UIApplication.shared.endEditing)
        .onReceive(resignPub) { _ in
            handleSaving()
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        /*if  {
            return true
        }*/
        
        return false
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if !changedValues.isEmpty {
            isDone = determineComplete()
            saveApplication()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - saveApplication
    private func saveApplication() {
        UIApplication.shared.endEditing()
        for (key, value) in changedValues {
            applicationCreation.application.setValue(value, forKey: key)
        }
        
        do {
            try viewContext.save()
            print("print - Application Entity Updated")
            applicationCreation.subsidyCreditSaved = true
            handleChangedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

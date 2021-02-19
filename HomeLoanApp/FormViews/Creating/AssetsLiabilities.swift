//
//  AssetsLiabilities.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/01.
//

import SwiftUI

struct AssetsLiabilities: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    // MARK: - State Variables
    @State var fixedProperty = ""
    @State var vehicles = ""
    @State var furnitureFittings = ""
    @State var assetLiabilityInvestments = ""
    @State var cashOnHand = ""
    @State var otherAsset = ""
    @State var otherAssetText = ""
    @State var mortgageBonds = ""
    @State var installmentSales = ""
    @State var creditCards = ""
    @State var currentAcc = ""
    @State var personalLoans = ""
    @State var retailAcc = ""
    @State var otherDebt = ""
    @State var otherAcc = ""
    @State var otherAccText = ""
    @State var otherLiabilities = ""
    @State var otherLiabilitiesText = ""
    
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var isActive: Bool = false
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    var body: some View {
        Form {
            Section(header: AssetLiabilityInfo(whichInfo: "assets")) {
                Group {
                    FormRandTextField(iD: "fixedProperty",
                                      question: formQuestions[7][0] ?? "MISSING",
                                      text: $fixedProperty)
                    
                    FormRandTextField(iD: "vehicles",
                                      question: formQuestions[7][1] ?? "MISSING",
                                      text: $vehicles)
                    
                    FormRandTextField(iD: "furnitureFittings",
                                      question: formQuestions[7][2] ?? "MISSING",
                                      text: $furnitureFittings)
                    
                    FormRandTextField(iD: "assetLiabilityInvestments",
                                      question: formQuestions[7][3] ?? "MISSING",
                                      text: $assetLiabilityInvestments)
                    
                    FormRandTextField(iD: "cashOnHand",
                                      question: formQuestions[7][4] ?? "MISSING",
                                      text: $cashOnHand)
                    
                    FormOtherRand(iD: "otherAsset",
                                      question: formQuestions[7][5] ?? "MISSING",
                                      other: $otherAsset,
                                      otherText: $otherAssetText)
                }
            }
            
            Section(header: AssetLiabilityInfo(whichInfo: "liabilities")) {
                Group {
                    FormRandTextField(iD: "mortgageBonds",
                                      question: formQuestions[7][6] ?? "MISSING",
                                      text: $mortgageBonds)
                    
                    FormRandTextField(iD: "installmentSales",
                                      question: formQuestions[7][7] ?? "MISSING",
                                      text: $installmentSales)
                    
                    FormRandTextField(iD: "creditCards",
                                      question: formQuestions[7][8] ?? "MISSING",
                                      text: $creditCards)
                    
                    FormRandTextField(iD: "currentAcc",
                                      question: formQuestions[7][9] ?? "MISSING",
                                      text: $currentAcc)
                }
                
                Group {
                    FormRandTextField(iD: "personalLoans",
                                      question: formQuestions[7][10] ?? "MISSING",
                                      text: $personalLoans)
                    
                    FormRandTextField(iD: "retailAcc",
                                      question: formQuestions[7][11] ?? "MISSING",
                                      text: $retailAcc)
                    
                    FormRandTextField(iD: "otherDebt",
                                      question: formQuestions[7][12] ?? "MISSING",
                                      text: $otherDebt)
                    
                    FormOtherRand(iD: "otherAcc",
                                  question: formQuestions[7][13] ?? "MISSING",
                                  other: $otherAcc,
                                  otherText: $otherAccText)
                    
                    FormOtherRand(iD: "otherLiabilities",
                                  question: formQuestions[7][14] ?? "MISSING",
                                  other: $otherLiabilities,
                                  otherText: $otherLiabilitiesText)
                }
            }
            
            Section {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Assets & Liabilities")
        .onReceive(resignPub) { _ in
            if isActive {
                handleSaving()
            }
        }
        .onDisappear {
            isActive = false
        }
        .onAppear {
            isActive = true
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        
        let assetResult = otherQuestionCheck(other: otherAsset, otherText: otherAssetText)
        let accountResult = otherQuestionCheck(other: otherAcc, otherText: otherAccText)
        let liabilityResult = otherQuestionCheck(other: otherLiabilities, otherText: otherLiabilitiesText)
        
        let groupResult = !fixedProperty.dropFirst().isEmpty || !vehicles.dropFirst().isEmpty || !furnitureFittings.dropFirst().isEmpty || !assetLiabilityInvestments.dropFirst().isEmpty || !cashOnHand.dropFirst().isEmpty || !mortgageBonds.dropFirst().isEmpty || !installmentSales.dropFirst().isEmpty || !creditCards.dropFirst().isEmpty || !currentAcc.dropFirst().isEmpty || !personalLoans.dropFirst().isEmpty || !retailAcc.dropFirst().isEmpty || !otherDebt.dropFirst().isEmpty
        
        if assetResult == .one || accountResult == .one || liabilityResult == .one { // If any are half-complete, the section is incomplete
            isComplete = false
        } else if assetResult == .both || accountResult == .both || liabilityResult == .both { // will never be reached if one 'other' question is half-complete, therefore one (or more) of the 'other' questions are complete
            isComplete = true
        } else if groupResult { // If all 'other' questions are .neither and there is a input somewhere, the section is complete
            isComplete = true
        }
        // else isComplete = false
        
        changedValues.changedValues.updateValue(isComplete, forKey: "assetsLiabilitiesDone")
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
            applicationCreation.assetsLiabilitiesSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

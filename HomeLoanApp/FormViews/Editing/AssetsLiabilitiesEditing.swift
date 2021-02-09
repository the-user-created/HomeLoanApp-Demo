//
//  AssetsLiabilitiesEditing.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/14.
//

import SwiftUI

struct AssetsLiabilitiesEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
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
    
    @State var initValues: Dictionary<String, AnyHashable> = [:]
    @State var savingValues: Dictionary<String, AnyHashable> = [:]
    @State var sender: Sender
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: Sender) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._fixedProperty = State(wrappedValue: self.application.fixedProperty ?? "")
        self._vehicles = State(wrappedValue: self.application.vehicles ?? "")
        self._furnitureFittings = State(wrappedValue: self.application.furnitureFittings ?? "")
        self._assetLiabilityInvestments = State(wrappedValue: self.application.assetLiabilityInvestments ?? "")
        self._cashOnHand = State(wrappedValue: self.application.cashOnHand ?? "")
        self._mortgageBonds = State(wrappedValue: self.application.mortgageBonds ?? "")
        self._installmentSales = State(wrappedValue: self.application.installmentSales ?? "")
        self._creditCards = State(wrappedValue: self.application.creditCards ?? "")
        self._currentAcc = State(wrappedValue: self.application.currentAcc ?? "")
        self._personalLoans = State(wrappedValue: self.application.personalLoans ?? "")
        self._retailAcc = State(wrappedValue: self.application.retailAcc ?? "")
        self._otherDebt = State(wrappedValue: self.application.otherDebt ?? "")
        
        if let otherAsset = self.application.otherAsset {
            let openBracketIndices = findNth("[", text: otherAsset)
            let closeBracketIndices = findNth("]", text: otherAsset)
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._otherAssetText = State(wrappedValue: String(otherAsset[otherAsset.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._otherAsset = State(wrappedValue: String(otherAsset[otherAsset.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
        
        if let otherAcc = self.application.otherAcc {
            let openBracketIndices = findNth("[", text: otherAcc)
            let closeBracketIndices = findNth("]", text: otherAcc)
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._otherAccText = State(wrappedValue: String(otherAcc[otherAcc.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._otherAcc = State(wrappedValue: String(otherAcc[otherAcc.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
        
        if let otherLiabilities = self.application.otherLiabilities {
            let openBracketIndices = findNth("[", text: otherLiabilities)
            let closeBracketIndices = findNth("]", text: otherLiabilities)
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._otherLiabilitiesText = State(wrappedValue: String(otherLiabilities[otherLiabilities.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._otherLiabilities = State(wrappedValue: String(otherLiabilities[otherLiabilities.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
        
        self._initValues = State(wrappedValue: ["fixedProperty": fixedProperty, "vehicles": vehicles, "furnitureFittings": furnitureFittings,
                                                "assetLiabilityInvestments": assetLiabilityInvestments, "cashOnHand": cashOnHand,
                                                "otherAsset": "[\(otherAsset)][\(otherAssetText)]", "mortgageBonds": mortgageBonds,
                                                "installmentSales": installmentSales, "creditCards": creditCards, "currentAcc": currentAcc,
                                                "personalLoans": personalLoans, "retailAcc": retailAcc, "otherDebt": otherDebt,
                                                "otherAcc": "[\(otherAcc)][\(otherAccText)]",
                                                "otherLiabilities": "[\(otherLiabilities)][\(otherLiabilitiesText)]"])
    }
    
    // MARK: - body
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
                    Text("Save changes")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Assets & Liabilities")
        .onReceive(resignPub) { _ in
            handleSaving()
        }
        .onDisappear {
            UIApplication.shared.endEditing()
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
    
    // MARK: - hasChanged
    private func hasChanged() -> Bool {
        self.savingValues = ["fixedProperty": fixedProperty, "vehicles": vehicles, "furnitureFittings": furnitureFittings, "assetLiabilityInvestments": assetLiabilityInvestments, "cashOnHand": cashOnHand, "otherAsset": "[\(otherAsset)][\(otherAssetText)]", "mortgageBonds": mortgageBonds, "installmentSales": installmentSales, "creditCards": creditCards, "currentAcc": currentAcc, "personalLoans": personalLoans, "retailAcc": retailAcc, "otherDebt": otherDebt, "otherAcc": "[\(otherAcc)][\(otherAccText)]", "otherLiabilities": "[\(otherLiabilities)][\(otherLiabilitiesText)]"]
        
        if savingValues != initValues {
            return true
        }
        
        alertMessage = "No answers were changed."
        showingAlert = true
        return false
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if hasChanged() {
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

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
    
    @State var sender: ChoosePageVer
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let handleChangedValues = HandleChangedValues()
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: ChoosePageVer) {
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
    }
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("Assets")) {
                FormRandTextField(iD: "fixedProperty", pageNum: 7,
                                  question: formQuestions[7][0] ?? "MISSING",
                                  text: $fixedProperty)
                
                FormRandTextField(iD: "vehicles", pageNum: 7,
                                  question: formQuestions[7][1] ?? "MISSING",
                                  text: $vehicles)
                
                FormRandTextField(iD: "furnitureFittings", pageNum: 7,
                                  question: formQuestions[7][2] ?? "MISSING",
                                  text: $furnitureFittings)
                
                FormRandTextField(iD: "assetLiabilityInvestments", pageNum: 7,
                                  question: formQuestions[7][3] ?? "MISSING",
                                  text: $assetLiabilityInvestments)
                
                FormRandTextField(iD: "cashOnHand", pageNum: 7,
                                  question: formQuestions[7][4] ?? "MISSING",
                                  text: $cashOnHand)
                
                FormOtherQuestion(iD: "otherAsset", pageNum: 7,
                                  question: formQuestions[7][5] ?? "MISSING",
                                  other: $otherAsset,
                                  otherText: $otherAssetText)
            }
            
            Section(header: Text("Liabilities")) {
                Group {
                    FormRandTextField(iD: "mortgageBonds", pageNum: 7,
                                      question: formQuestions[7][6] ?? "MISSING",
                                      text: $mortgageBonds)
                    
                    FormRandTextField(iD: "installmentSales", pageNum: 7,
                                      question: formQuestions[7][7] ?? "MISSING",
                                      text: $installmentSales)
                    
                    FormRandTextField(iD: "creditCards", pageNum: 7,
                                      question: formQuestions[7][8] ?? "MISSING",
                                      text: $creditCards)
                    
                    FormRandTextField(iD: "currentAcc", pageNum: 7,
                                      question: formQuestions[7][9] ?? "MISSING",
                                      text: $currentAcc)
                }
                
                Group {
                    FormRandTextField(iD: "personalLoans", pageNum: 7,
                                      question: formQuestions[7][10] ?? "MISSING",
                                      text: $personalLoans)
                    
                    FormRandTextField(iD: "retailAcc", pageNum: 7,
                                      question: formQuestions[7][11] ?? "MISSING",
                                      text: $retailAcc)
                    
                    FormRandTextField(iD: "otherDebt", pageNum: 7,
                                      question: formQuestions[7][12] ?? "MISSING",
                                      text: $otherDebt)
                    
                    FormOtherQuestion(iD: "otherAcc", pageNum: 7,
                                      question: formQuestions[7][13] ?? "MISSING",
                                      other: $otherAcc,
                                      otherText: $otherAccText)
                    
                    FormOtherQuestion(iD: "otherLiabilities", pageNum: 7,
                                      question: formQuestions[7][14] ?? "MISSING",
                                      other: $otherLiabilities,
                                      otherText: $otherLiabilitiesText)
                }
            }
            
            Section() {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save changes")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
                .disabled(changedValues.isEmpty ? true : false)
            }
        }
        .navigationBarTitle("Assets & Liabilities")
        .onTapGesture(count: 2, perform: UIApplication.shared.endEditing)
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
        if !changedValues.isEmpty {
            isDone = determineComplete()
            addToApplication()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - addToApplication()
    private func addToApplication() {
        UIApplication.shared.endEditing()
        
        for (key, value) in changedValues {
            if sender == .creator {
                applicationCreation.application.setValue(value, forKey: key)
            } else {
                application.setValue(value, forKey: key)
            }
        }
        
        do {
            try viewContext.save()
            print("Application Entity Updated")
            handleChangedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

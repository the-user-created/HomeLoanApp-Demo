//
//  AssetsLiabilities.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/01.
//

import SwiftUI

struct AssetsLiabilities: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
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
    
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    var body: some View {
        Form() {
            Section(header: Text("Assets")) {
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
            
            Section(header: Text("Liabilities")) {
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
            
            Section() {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
                .disabled(changedValues.changedValues.isEmpty ? true : false)
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
        /*if  {
            return true
        }*/
        
        return false
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if !changedValues.changedValues.isEmpty {
            isDone = determineComplete()
            saveApplication()
            presentationMode.wrappedValue.dismiss()
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

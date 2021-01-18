//
//  Expenses.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/01.
//

import SwiftUI

struct Expenses: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    // MARK: - State Variables
    @State var rental = ""
    @State var expensesInvestments = ""
    @State var ratesTaxes = ""
    @State var waterLights = ""
    @State var homeMain = ""
    @State var petrolCar = ""
    @State var insurance = ""
    @State var assurance = ""
    @State var timeshare = ""
    @State var groceries = ""
    @State var clothing = ""
    @State var levies = ""
    @State var domesticWages = ""
    @State var education = ""
    @State var expensesEntertainment = ""
    @State var security = ""
    @State var propertyRentExp = ""
    @State var medical = ""
    @State var donations = ""
    @State var cellphone = ""
    @State var mNetDSTV = ""
    @State var telephoneISP = ""
    @State var expensesMaintenanceAlimony = ""
    @State var installmentExp = ""
    @State var otherExpenses = ""
    @State var otherExpensesText = ""
    
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("EXPENSES")) {
                Group {
                    FormRandTextField(iD: "rental",
                                      question: formQuestions[6][0] ?? "MISSING",
                                      text: $rental)
                    
                    FormRandTextField(iD: "expensesInvestments",
                                      question: formQuestions[6][1] ?? "MISSING",
                                      text: $expensesInvestments)
                    
                    FormRandTextField(iD: "ratesTaxes",
                                      question: formQuestions[6][2] ?? "MISSING",
                                      text: $ratesTaxes)
                    
                    FormRandTextField(iD: "waterLights",
                                      question: formQuestions[6][3] ?? "MISSING",
                                      text: $waterLights)
                    
                    FormRandTextField(iD: "homeMain",
                                      question: formQuestions[6][4] ?? "MISSING",
                                      text: $homeMain)
                }
                
                Group {
                    FormRandTextField(iD: "petrolCar",
                                      question: formQuestions[6][5] ?? "MISSING",
                                      text: $petrolCar)
                    
                    FormRandTextField(iD: "insurance",
                                      question: formQuestions[6][6] ?? "MISSING",
                                      text: $insurance)
                    
                    FormRandTextField(iD: "assurance",
                                      question: formQuestions[6][7] ?? "MISSING",
                                      text: $assurance)
                    
                    FormRandTextField(iD: "timeshare",
                                      question: formQuestions[6][8] ?? "MISSING",
                                      text: $timeshare)
                    
                    FormRandTextField(iD: "groceries",
                                      question: formQuestions[6][9] ?? "MISSING",
                                      text: $groceries)
                }
                
                Group {
                    FormRandTextField(iD: "clothing",
                                      question: formQuestions[6][10] ?? "MISSING",
                                      text: $clothing)
                    
                    FormRandTextField(iD: "levies",
                                      question: formQuestions[6][11] ?? "MISSING",
                                      text: $levies)
                    
                    FormRandTextField(iD: "domesticWages",
                                      question: formQuestions[6][12] ?? "MISSING",
                                      text: $domesticWages)
                    
                    FormRandTextField(iD: "education",
                                      question: formQuestions[6][13] ?? "MISSING",
                                      text: $education)
                    
                    FormRandTextField(iD: "expensesEntertainment",
                                      question: formQuestions[6][14] ?? "MISSING",
                                      text: $expensesEntertainment)
                }
                
                Group {
                    FormRandTextField(iD: "security",
                                      question: formQuestions[6][15] ?? "MISSING",
                                      text: $security)
                    
                    FormRandTextField(iD: "propertyRentExp",
                                      question: formQuestions[6][16] ?? "MISSING",
                                      text: $propertyRentExp)
                    
                    FormRandTextField(iD: "medical",
                                      question: formQuestions[6][17] ?? "MISSING",
                                      text: $medical)
                    
                    FormRandTextField(iD: "donations",
                                      question: formQuestions[6][18] ?? "MISSING",
                                      text: $donations)
                    
                    FormRandTextField(iD: "cellphone",
                                      question: formQuestions[6][19] ?? "MISSING",
                                      text: $cellphone)
                }
                
                Group {
                    FormRandTextField(iD: "telephoneISP",
                                      question: formQuestions[6][20] ?? "MISSING",
                                      text: $telephoneISP)
                    
                    FormRandTextField(iD: "expensesMaintenanceAlimony",
                                      question: formQuestions[6][21] ?? "MISSING",
                                      text: $expensesMaintenanceAlimony)
                    
                    FormRandTextField(iD: "installmentExp",
                                      question: formQuestions[6][22] ?? "MISSING",
                                      text: $installmentExp)
                    
                    FormOtherRand(iD: "otherExpenses",
                                      question: formQuestions[6][23] ?? "MISSING",
                                      other: $otherExpenses,
                                      otherText: $otherExpensesText)
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
        .navigationBarTitle("Expenses")
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
            applicationCreation.expensesSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

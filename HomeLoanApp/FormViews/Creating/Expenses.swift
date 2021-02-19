//
//  Expenses.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/01.
//

import SwiftUI

struct Expenses: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
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
    
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var isActive: Bool = false
    @State var calculatedExpenses: String = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - body
    var body: some View {
        Form {
            Section(header: Text("EXPENSES")) {
                Section(header: Text("Total Expenses").font(.headline)) {
                    Text("R\(calculatedExpenses)")
                }
                
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
                    FormRandTextField(iD: "mNetDSTV",
                                      question: formQuestions[6][20] ?? "MISSING",
                                      text: $mNetDSTV)
                    
                    FormRandTextField(iD: "telephoneISP",
                                      question: formQuestions[6][21] ?? "MISSING",
                                      text: $telephoneISP)
                    
                    FormRandTextField(iD: "expensesMaintenanceAlimony",
                                      question: formQuestions[6][22] ?? "MISSING",
                                      text: $expensesMaintenanceAlimony)
                    
                    FormRandTextField(iD: "installmentExp",
                                      question: formQuestions[6][23] ?? "MISSING",
                                      text: $installmentExp)
                    
                    FormOtherRand(iD: "otherExpenses",
                                      question: formQuestions[6][24] ?? "MISSING",
                                      other: $otherExpenses,
                                      otherText: $otherExpensesText)
                }
                
                Section(header: Text("Total Expenses").font(.headline)) {
                    Text("R\(calculatedExpenses)")
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
        .navigationBarTitle("Expenses")
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
        .onChange(of: [rental, expensesInvestments, ratesTaxes, waterLights, homeMain, petrolCar, insurance, assurance, timeshare, groceries, clothing, levies, domesticWages, education, expensesEntertainment, security, propertyRentExp, medical, donations, cellphone, mNetDSTV, telephoneISP, expensesMaintenanceAlimony, installmentExp, otherExpenses]) { _ in
            calculatedExpenses = calculateExpenses()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        
        let expensesResult = otherQuestionCheck(other: otherExpenses, otherText: otherExpensesText)
        
        let groupResult = !rental.dropFirst().isEmpty || !expensesInvestments.dropFirst().isEmpty || !ratesTaxes.dropFirst().isEmpty || !waterLights.dropFirst().isEmpty || !homeMain.dropFirst().isEmpty || !petrolCar.dropFirst().isEmpty || !insurance.dropFirst().isEmpty || !assurance.dropFirst().isEmpty || !timeshare.dropFirst().isEmpty || !groceries.dropFirst().isEmpty || !clothing.dropFirst().isEmpty || !levies.dropFirst().isEmpty || !domesticWages.dropFirst().isEmpty || !education.dropFirst().isEmpty || !expensesEntertainment.dropFirst().isEmpty  || !security.dropFirst().isEmpty || !propertyRentExp.dropFirst().isEmpty || !medical.dropFirst().isEmpty || !donations.dropFirst().isEmpty || !cellphone.dropFirst().isEmpty || !mNetDSTV.dropFirst().isEmpty || !telephoneISP.dropFirst().isEmpty || !expensesMaintenanceAlimony.dropFirst().isEmpty || !installmentExp.dropFirst().isEmpty
        
        if expensesResult == .both {
            isComplete = true
        } else if groupResult && expensesResult != .one{
            isComplete = true
        }
        
        changedValues.changedValues.updateValue(isComplete, forKey: "expensesDone")
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
    
    // MARK: - calculateExpenses
    private func calculateExpenses() -> String {
        var totalIncome: Float = 0.0
        let incomeList: [String] = [String(rental.dropFirst()), String(expensesInvestments.dropFirst()), String(ratesTaxes.dropFirst()), String(waterLights.dropFirst()), String(homeMain.dropFirst()), String(petrolCar.dropFirst()), String(insurance.dropFirst()), String(assurance.dropFirst()), String(timeshare.dropFirst()), String(groceries.dropFirst()), String(clothing.dropFirst()), String(levies.dropFirst()), String(domesticWages.dropFirst()), String(education.dropFirst()), String(expensesEntertainment.dropFirst()), String(security.dropFirst()), String(propertyRentExp.dropFirst()), String(medical.dropFirst()), String(donations.dropFirst()), String(cellphone.dropFirst()), String(mNetDSTV.dropFirst()), String(telephoneISP.dropFirst()), String(expensesMaintenanceAlimony.dropFirst()), String(installmentExp.dropFirst()), String(otherExpenses.dropFirst())]
        
        for income in incomeList {
            totalIncome = totalIncome.advanced(by: Float(income.replacingOccurrences(of: ",", with: ".")) ?? 0.0)
        }
        
        return String(format: "%.2f", totalIncome)
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

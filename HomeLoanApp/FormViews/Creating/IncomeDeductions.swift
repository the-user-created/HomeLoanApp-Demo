//
//  Income.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/11/30.
//

import SwiftUI

struct IncomeDeductions: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    // MARK: - State Variables
    @State var basicSalary = ""
    @State var wages = ""
    @State var averageComm = ""
    @State var investments = ""
    @State var rentIncome = ""
    @State var futureRentIncome = ""
    @State var housingSub = ""
    @State var averageOvertime = ""
    @State var monthCarAllowance = ""
    @State var interestIncome = ""
    @State var travelAllowance = ""
    @State var entertainment = ""
    @State var incomeFromSureties = ""
    @State var maintenanceAlimony = ""
    @State var otherIncome = ""
    @State var otherIncomeText = ""
    @State var tax = ""
    @State var pension = ""
    @State var uIF = ""
    @State var medicalAid = ""
    @State var otherDeduction = ""
    @State var otherDeductionText = ""
    
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var isActive: Bool = false
    @State var calculatedIncome: String = ""
    @State var calculatedDeductions: String = ""
    @State var netSalary: String = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("INCOME")) {
                Group() {
                    FormRandTextField(iD: "basicSalary",
                                      question: formQuestions[5][0] ?? "MISSING",
                                      text: $basicSalary)
                
                    FormRandTextField(iD: "wages",
                                      question: formQuestions[5][1] ?? "MISSING",
                                      text: $wages)
                    
                    FormRandTextField(iD: "averageComm",
                                      question: formQuestions[5][2] ?? "MISSING",
                                      text: $averageComm)
                    
                    FormRandTextField(iD: "investments",
                                      question: formQuestions[5][3] ?? "MISSING",
                                      text: $investments)
                    
                    FormRandTextField(iD: "rentIncome",
                                      question: formQuestions[5][4] ?? "MISSING",
                                      text: $rentIncome)
                    
                    FormRandTextField(iD: "futureRentIncome",
                                      question: formQuestions[5][5] ?? "MISSING",
                                      text: $futureRentIncome)
                    
                    FormRandTextField(iD: "housingSub",
                                      question: formQuestions[5][6] ?? "MISSING",
                                      text: $housingSub)
                    
                    FormRandTextField(iD: "averageOvertime",
                                      question: formQuestions[5][7] ?? "MISSING",
                                      text: $averageOvertime)
                    
                    FormRandTextField(iD: "monthCarAllowance",
                                      question: formQuestions[5][8] ?? "MISSING",
                                      text: $monthCarAllowance)
                }
                
                Group() {
                    FormRandTextField(iD: "interestIncome",
                                      question: formQuestions[5][9] ?? "MISSING",
                                      text: $interestIncome)
                
                    FormRandTextField(iD: "travelAllowance",
                                      question: formQuestions[5][10] ?? "MISSING",
                                      text: $travelAllowance)
                    
                    FormRandTextField(iD: "entertainment",
                                      question: formQuestions[5][11] ?? "MISSING",
                                      text: $entertainment)
                    
                    FormRandTextField(iD: "incomeFromSureties",
                                      question: formQuestions[5][12] ?? "MISSING",
                                      text: $incomeFromSureties)
                    
                    FormRandTextField(iD: "maintenanceAlimony",
                                      question: formQuestions[5][13] ?? "MISSING",
                                      text: $maintenanceAlimony)
                    
                    FormOtherRand(iD: "otherIncome",
                                      question: formQuestions[5][14] ?? "MISSING",
                                      other: $otherIncome,
                                      otherText: $otherIncomeText)
                }
                
                Section(header: Text("Total Income").font(.headline)) {
                    Text("R\(calculatedIncome)")
                        .font(.headline)
                }
            }
            
            Section(header: Text("DEDUCTIONS")) {
                FormRandTextField(iD: "tax",
                                  question: formQuestions[5][15] ?? "MISSING",
                                  text: $tax)
                
                FormRandTextField(iD: "pension",
                                  question: formQuestions[5][16] ?? "MISSING",
                                  text: $pension)
                
                FormRandTextField(iD: "uIF",
                                  question: formQuestions[5][17] ?? "MISSING",
                                  text: $uIF)
                
                FormRandTextField(iD: "medicalAid",
                                  question: formQuestions[5][18] ?? "MISSING",
                                  text: $medicalAid)
                
                FormOtherRand(iD: "otherDeductions",
                                  question: formQuestions[5][19] ?? "MISSING",
                                  other: $otherDeduction,
                                  otherText: $otherDeductionText)
                
                Section(header: Text("Total Deductions").font(.headline)) {
                    Text("R\(calculatedDeductions)")
                        .font(.headline)
                }
            }
            
            Section(header: Text("Net Salary").font(.headline)) {
                Text("R\((Float(calculatedIncome) ?? 0 - (Float(calculatedDeductions) ?? 0)).removeZerosFromEnd())")
                    .font(.headline)
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
        .navigationBarTitle("Income & Deductions")
        .onTapGesture(count: 2, perform: UIApplication.shared.endEditing)
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
        .onChange(of: [basicSalary, wages, averageComm, investments, rentIncome, futureRentIncome, housingSub, averageOvertime, monthCarAllowance, interestIncome, travelAllowance, entertainment, incomeFromSureties, maintenanceAlimony, otherIncome]) { _ in
            calculatedIncome = calculateIncome()
            netSalary = String(format: "%.2f", (Float(self.calculatedIncome) ?? 0.0) - (Float(self.calculatedDeductions) ?? 0.0))
        }
        .onChange(of: [tax, pension, uIF, medicalAid, otherDeduction]) { _ in
            calculatedDeductions = calculateDeductions()
            netSalary = String(format: "%.2f", (Float(self.calculatedIncome) ?? 0.0) - (Float(self.calculatedDeductions) ?? 0.0))
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        
        let incomeResult = otherQuestionCheck(other: otherIncome, otherText: otherIncomeText)
        let deductionResult = otherQuestionCheck(other: otherDeduction, otherText: otherDeductionText)
        
        let groupResult = !basicSalary.dropFirst().isEmpty || !wages.dropFirst().isEmpty || !averageComm.dropFirst().isEmpty || !investments.dropFirst().isEmpty || !rentIncome.dropFirst().isEmpty || !futureRentIncome.dropFirst().isEmpty || !housingSub.dropFirst().isEmpty || !averageOvertime.dropFirst().isEmpty || !monthCarAllowance.dropFirst().isEmpty || !interestIncome.dropFirst().isEmpty || !travelAllowance.dropFirst().isEmpty || !entertainment.dropFirst().isEmpty || !incomeFromSureties.dropFirst().isEmpty || !maintenanceAlimony.dropFirst().isEmpty || !tax.dropFirst().isEmpty || !pension.dropFirst().isEmpty || !uIF.dropFirst().isEmpty || !medicalAid.dropFirst().isEmpty
        
        if incomeResult == .one || deductionResult == .one {
            isComplete = false
        } else if incomeResult == .both || deductionResult == .both {
            isComplete = true
        } else if groupResult {
            isComplete = true
        }
        
        changedValues.changedValues.updateValue(isComplete, forKey: "incomeDeductionsDone")
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
    
    // MARK: - calculateIncome
    private func calculateIncome() -> String {
        var totalIncome: Float = 0.0
        let incomeList: [String] = [String(basicSalary.dropFirst()), String(wages.dropFirst()), String(averageComm.dropFirst()), String(investments.dropFirst()), String(rentIncome.dropFirst()), String(futureRentIncome.dropFirst()), String(housingSub.dropFirst()), String(averageOvertime.dropFirst()), String(monthCarAllowance.dropFirst()), String(interestIncome.dropFirst()), String(travelAllowance.dropFirst()), String(entertainment.dropFirst()), String(incomeFromSureties.dropFirst()), String(maintenanceAlimony.dropFirst()), String(otherIncome.dropFirst())]
        
        for income in incomeList {
            totalIncome = totalIncome.advanced(by: Float(income.replacingOccurrences(of: ",", with: ".")) ?? 0.0)
        }
        
        return String(format: "%.2f", totalIncome)
    }
    
    // MARK: - calculateDeductions
    private func calculateDeductions() -> String {
        var totalIncome: Float = 0.0
        let incomeList: [String] = [String(tax.dropFirst()), String(pension.dropFirst()), String(uIF.dropFirst()), String(medicalAid.dropFirst()), String(otherDeduction.dropFirst())]
        
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
            applicationCreation.incomeSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//
//  IncomeEditing.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/14.
//

import SwiftUI

struct IncomeDeductionsEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
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
    
    @State var initValues: Dictionary<String, AnyHashable> = [:]
    @State var savingValues: Dictionary<String, AnyHashable> = [:]
    @State var sender: Sender
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @State var calculatedIncome: String = ""
    @State var calculatedDeductions: String = ""
    @State var netSalary: String = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: Sender) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._basicSalary = State(wrappedValue: self.application.basicSalary ?? "")
        self._wages = State(wrappedValue: self.application.wages ?? "")
        self._averageComm = State(wrappedValue: self.application.averageComm ?? "")
        self._investments = State(wrappedValue: self.application.investments ?? "")
        self._rentIncome = State(wrappedValue: self.application.rentIncome ?? "")
        self._futureRentIncome = State(wrappedValue: self.application.futureRentIncome ?? "")
        self._housingSub = State(wrappedValue: self.application.housingSub ?? "")
        self._averageOvertime = State(wrappedValue: self.application.averageOvertime ?? "")
        self._monthCarAllowance = State(wrappedValue: self.application.monthCarAllowance ?? "")
        self._interestIncome = State(wrappedValue: self.application.interestIncome ?? "")
        self._travelAllowance = State(wrappedValue: self.application.travelAllowance ?? "")
        self._entertainment = State(wrappedValue: self.application.entertainment ?? "")
        self._incomeFromSureties = State(wrappedValue: self.application.incomeFromSureties ?? "")
        self._maintenanceAlimony = State(wrappedValue: self.application.maintenanceAlimony ?? "")
        self._tax = State(wrappedValue: self.application.tax ?? "")
        self._pension = State(wrappedValue: self.application.pension ?? "")
        self._uIF = State(wrappedValue: self.application.uIF ?? "")
        self._medicalAid = State(wrappedValue: self.application.medicalAid ?? "")
        
        if let otherIncome = self.application.otherIncome {
            let openBracketIndices = findNth("[", text: otherIncome)
            let closeBracketIndices = findNth("]", text: otherIncome)
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._otherIncomeText = State(wrappedValue: String(otherIncome[otherIncome.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._otherIncome = State(wrappedValue: String(otherIncome[otherIncome.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
        
        if let otherDeductions = self.application.otherDeductions {
            let openBracketIndices = findNth("[", text: otherDeductions)
            let closeBracketIndices = findNth("]", text: otherDeductions)
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._otherDeductionText = State(wrappedValue: String(otherDeductions[otherDeductions.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._otherDeduction = State(wrappedValue: String(otherDeductions[otherDeductions.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
        
        self._initValues = State(wrappedValue: ["basicSalary": basicSalary, "wages": wages, "averageComm": averageComm, "investments": investments, "rentIncome": rentIncome, "futureRentIncome": futureRentIncome, "housingSub": housingSub, "averageOvertime": averageOvertime, "monthCarAllowance": monthCarAllowance, "interestIncome": interestIncome, "travelAllowance": travelAllowance, "entertainment": entertainment, "incomeFromSureties": incomeFromSureties, "maintenanceAlimony": maintenanceAlimony, "other": "[\(otherIncome)][\(otherIncomeText)]", "tax": tax, "pension": pension, "uIF": uIF, "medicalAid": medicalAid, "otherDeductions": "[\(otherDeduction)][\(otherDeductionText)]"])
        
        self._calculatedIncome = State(wrappedValue: calculateIncome())
        self._calculatedDeductions = State(wrappedValue: calculateDeductions())
        self._netSalary = State(wrappedValue: String(format: "%.2f", (Float(calculatedIncome) ?? 0.0) - (Float(calculatedDeductions) ?? 0.0)))
    }
    
    // MARK: - body
    var body: some View {
        Form {
            Section(header: Text("INCOME")) {
                Group {
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
                
                Group {
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
                Text("R\(netSalary)")
                    .font(.headline)
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
        .navigationBarTitle("Income & Deductions")
        .onReceive(resignPub) { _ in
            handleSaving()
        }
        .onDisappear {
            UIApplication.shared.endEditing()
        }
        .onChange(of: [basicSalary, wages, averageComm, investments, rentIncome, futureRentIncome, housingSub, averageOvertime, monthCarAllowance, interestIncome, travelAllowance, entertainment, incomeFromSureties, maintenanceAlimony, otherIncome]) { _ in
            calculatedIncome = calculateIncome()
            netSalary = String(format: "%.2f", (Float(calculatedIncome) ?? 0.0) - (Float(calculatedDeductions) ?? 0.0))
        }
        .onChange(of: [tax, pension, uIF, medicalAid, otherDeduction]) { _ in
            calculatedDeductions = calculateDeductions()
            netSalary = String(format: "%.2f", (Float(calculatedIncome) ?? 0.0) - (Float(calculatedDeductions) ?? 0.0))
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
    
    // MARK: - hasChanged
    private func hasChanged() -> Bool {
        self.savingValues = ["basicSalary": basicSalary, "wages": wages, "averageComm": averageComm, "investments": investments, "rentIncome": rentIncome, "futureRentIncome": futureRentIncome, "housingSub": housingSub, "averageOvertime": averageOvertime, "monthCarAllowance": monthCarAllowance, "interestIncome": interestIncome, "travelAllowance": travelAllowance, "entertainment": entertainment, "incomeFromSureties": incomeFromSureties, "maintenanceAlimony": maintenanceAlimony, "other": "[\(otherIncome)][\(otherIncomeText)]", "tax": tax, "pension": pension, "uIF": uIF, "medicalAid": medicalAid, "otherDeductions": "[\(otherDeduction)][\(otherDeductionText)]"]
        
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

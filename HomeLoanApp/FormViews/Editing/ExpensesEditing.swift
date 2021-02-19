//
//  ExpensesEditing.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/14.
//

import SwiftUI

struct ExpensesEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
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
    
    @State var initValues: Dictionary<String, AnyHashable> = [:]
    @State var savingValues: Dictionary<String, AnyHashable> = [:]
    @State var sender: Sender
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @State var calculatedExpenses: String = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: Sender) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._rental = State(wrappedValue: self.application.rental ?? "")
        self._expensesInvestments = State(wrappedValue: self.application.expensesInvestments ?? "")
        self._ratesTaxes = State(wrappedValue: self.application.ratesTaxes ?? "")
        self._waterLights = State(wrappedValue: self.application.waterLights ?? "")
        self._homeMain = State(wrappedValue: self.application.homeMain ?? "")
        self._petrolCar = State(wrappedValue: self.application.petrolCar ?? "")
        self._insurance = State(wrappedValue: self.application.insurance ?? "")
        self._assurance = State(wrappedValue: self.application.assurance ?? "")
        self._timeshare = State(wrappedValue: self.application.timeshare ?? "")
        self._groceries = State(wrappedValue: self.application.groceries ?? "")
        self._clothing = State(wrappedValue: self.application.clothing ?? "")
        self._levies = State(wrappedValue: self.application.levies ?? "")
        self._domesticWages = State(wrappedValue: self.application.domesticWages ?? "")
        self._education = State(wrappedValue: self.application.education ?? "")
        self._expensesEntertainment = State(wrappedValue: self.application.expensesEntertainment ?? "")
        self._security = State(wrappedValue: self.application.security ?? "")
        self._propertyRentExp = State(wrappedValue: self.application.propertyRentExp ?? "")
        self._medical = State(wrappedValue: self.application.medical ?? "")
        self._donations = State(wrappedValue: self.application.donations ?? "")
        self._cellphone = State(wrappedValue: self.application.cellphone ?? "")
        self._mNetDSTV = State(wrappedValue: self.application.mNetDSTV ?? "")
        self._telephoneISP = State(wrappedValue: self.application.telephoneISP ?? "")
        self._expensesMaintenanceAlimony = State(wrappedValue: self.application.expensesMaintenanceAlimony ?? "")
        self._installmentExp = State(wrappedValue: self.application.installmentExp ?? "")
        
        if let otherExpenses = self.application.otherExpenses {
            let openBracketIndices = findNth("[", text: otherExpenses)
            let closeBracketIndices = findNth("]", text: otherExpenses)
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._otherExpensesText = State(wrappedValue: String(otherExpenses[otherExpenses.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._otherExpenses = State(wrappedValue: String(otherExpenses[otherExpenses.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
        
        self._calculatedExpenses = State(wrappedValue: calculateExpenses())
        
        self._initValues = State(wrappedValue: ["rental": rental, "expensesInvestments": expensesInvestments, "ratesTaxes": ratesTaxes, "waterLights": waterLights, "homeMain": homeMain, "petrolCar": petrolCar, "insurance": insurance, "assurance": assurance, "timeshare": timeshare, "groceries": groceries, "clothing": clothing, "levies": levies, "domesticWages": domesticWages, "education": education, "expensesEntertainment": expensesEntertainment, "security": security, "propertyRentExp": propertyRentExp, "medical": medical, "donations": donations, "cellphone": cellphone, "mNetDSTV": mNetDSTV, "telephoneISP": telephoneISP, "expensesMaintenanceAlimony": expensesMaintenanceAlimony, "installmentExp": installmentExp, "otherExpenses": "[\(otherExpenses)][\(otherExpensesText)]"])
    }
    
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
                    Text("Save changes")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Expenses")
        .onReceive(resignPub) { _ in
            handleSaving()
        }
        .onDisappear {
            UIApplication.shared.endEditing()
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
    
    // MARK: - hasChanged
    private func hasChanged() -> Bool {
        self.savingValues = ["rental": rental, "expensesInvestments": expensesInvestments, "ratesTaxes": ratesTaxes, "waterLights": waterLights, "homeMain": homeMain, "petrolCar": petrolCar, "insurance": insurance, "assurance": assurance, "timeshare": timeshare, "groceries": groceries, "clothing": clothing, "levies": levies, "domesticWages": domesticWages, "education": education, "expensesEntertainment": expensesEntertainment, "security": security, "propertyRentExp": propertyRentExp, "medical": medical, "donations": donations, "cellphone": cellphone, "mNetDSTV": mNetDSTV, "telephoneISP": telephoneISP, "expensesMaintenanceAlimony": expensesMaintenanceAlimony, "installmentExp": installmentExp, "otherExpenses": "[\(otherExpenses)][\(otherExpensesText)]"]
        
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
    
    // MARK: - calculateExpenses
    private func calculateExpenses() -> String {
        var totalIncome: Float = 0.0
        let incomeList: [String] = [String(rental.dropFirst()), String(expensesInvestments.dropFirst()), String(ratesTaxes.dropFirst()), String(waterLights.dropFirst()), String(homeMain.dropFirst()), String(petrolCar.dropFirst()), String(insurance.dropFirst()), String(assurance.dropFirst()), String(timeshare.dropFirst()), String(groceries.dropFirst()), String(clothing.dropFirst()), String(levies.dropFirst()), String(domesticWages.dropFirst()), String(education.dropFirst()), String(expensesEntertainment.dropFirst()), String(security.dropFirst()), String(propertyRentExp.dropFirst()), String(medical.dropFirst()), String(donations.dropFirst()), String(cellphone.dropFirst()), String(mNetDSTV.dropFirst()), String(telephoneISP.dropFirst()), String(expensesMaintenanceAlimony.dropFirst()), String(installmentExp.dropFirst()), String(otherExpenses.dropFirst())]
        
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

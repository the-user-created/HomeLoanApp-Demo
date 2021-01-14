//
//  ExpensesEditing.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/14.
//

import SwiftUI

struct ExpensesEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
    
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
        self._rental = State(wrappedValue: self.application.rental ?? "")
        self._expensesInvestments = State(wrappedValue: self.application.rental ?? "")
        self._ratesTaxes = State(wrappedValue: self.application.rental ?? "")
        self._waterLights = State(wrappedValue: self.application.rental ?? "")
        self._homeMain = State(wrappedValue: self.application.rental ?? "")
        self._petrolCar = State(wrappedValue: self.application.rental ?? "")
        self._insurance = State(wrappedValue: self.application.rental ?? "")
        self._assurance = State(wrappedValue: self.application.rental ?? "")
        self._timeshare = State(wrappedValue: self.application.rental ?? "")
        self._groceries = State(wrappedValue: self.application.rental ?? "")
        self._clothing = State(wrappedValue: self.application.rental ?? "")
        self._levies = State(wrappedValue: self.application.rental ?? "")
        self._domesticWages = State(wrappedValue: self.application.rental ?? "")
        self._education = State(wrappedValue: self.application.rental ?? "")
        self._expensesEntertainment = State(wrappedValue: self.application.rental ?? "")
        self._security = State(wrappedValue: self.application.rental ?? "")
        self._propertyRentExp = State(wrappedValue: self.application.rental ?? "")
        self._medical = State(wrappedValue: self.application.rental ?? "")
        self._donations = State(wrappedValue: self.application.rental ?? "")
        self._cellphone = State(wrappedValue: self.application.rental ?? "")
        self._telephoneISP = State(wrappedValue: self.application.rental ?? "")
        self._expensesMaintenanceAlimony = State(wrappedValue: self.application.rental ?? "")
        self._installmentExp = State(wrappedValue: self.application.rental ?? "")
        
        if let otherExpenses = self.application.otherExpenses {
            let openBracketIndices = findNth("[", text: otherExpenses)
            let closeBracketIndices = findNth("]", text: otherExpenses)
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._otherExpensesText = State(wrappedValue: String(otherExpenses[otherExpenses.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._otherExpenses = State(wrappedValue: String(otherExpenses[otherExpenses.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
    }
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("EXPENSES")) {
                Group {
                    FormRandTextField(iD: "rental", pageNum: 6,
                                      question: formQuestions[6][0] ?? "MISSING",
                                      text: $rental)
                    
                    FormRandTextField(iD: "expensesInvestments", pageNum: 6,
                                      question: formQuestions[6][1] ?? "MISSING",
                                      text: $expensesInvestments)
                    
                    FormRandTextField(iD: "ratesTaxes", pageNum: 6,
                                      question: formQuestions[6][2] ?? "MISSING",
                                      text: $ratesTaxes)
                    
                    FormRandTextField(iD: "waterLights", pageNum: 6,
                                      question: formQuestions[6][3] ?? "MISSING",
                                      text: $waterLights)
                    
                    FormRandTextField(iD: "homeMain", pageNum: 6,
                                      question: formQuestions[6][4] ?? "MISSING",
                                      text: $homeMain)
                }
                
                Group {
                    FormRandTextField(iD: "petrolCar", pageNum: 6,
                                      question: formQuestions[6][5] ?? "MISSING",
                                      text: $petrolCar)
                    
                    FormRandTextField(iD: "insurance", pageNum: 6,
                                      question: formQuestions[6][6] ?? "MISSING",
                                      text: $insurance)
                    
                    FormRandTextField(iD: "assurance", pageNum: 6,
                                      question: formQuestions[6][7] ?? "MISSING",
                                      text: $assurance)
                    
                    FormRandTextField(iD: "timeshare", pageNum: 6,
                                      question: formQuestions[6][8] ?? "MISSING",
                                      text: $timeshare)
                    
                    FormRandTextField(iD: "groceries", pageNum: 6,
                                      question: formQuestions[6][9] ?? "MISSING",
                                      text: $groceries)
                }
                
                Group {
                    FormRandTextField(iD: "clothing", pageNum: 6,
                                      question: formQuestions[6][10] ?? "MISSING",
                                      text: $clothing)
                    
                    FormRandTextField(iD: "levies", pageNum: 6,
                                      question: formQuestions[6][11] ?? "MISSING",
                                      text: $levies)
                    
                    FormRandTextField(iD: "domesticWages", pageNum: 6,
                                      question: formQuestions[6][12] ?? "MISSING",
                                      text: $domesticWages)
                    
                    FormRandTextField(iD: "education", pageNum: 6,
                                      question: formQuestions[6][13] ?? "MISSING",
                                      text: $education)
                    
                    FormRandTextField(iD: "expensesEntertainment", pageNum: 6,
                                      question: formQuestions[6][14] ?? "MISSING",
                                      text: $expensesEntertainment)
                }
                
                Group {
                    FormRandTextField(iD: "security", pageNum: 6,
                                      question: formQuestions[6][15] ?? "MISSING",
                                      text: $security)
                    
                    FormRandTextField(iD: "propertyRentExp", pageNum: 6,
                                      question: formQuestions[6][16] ?? "MISSING",
                                      text: $propertyRentExp)
                    
                    FormRandTextField(iD: "medical", pageNum: 6,
                                      question: formQuestions[6][17] ?? "MISSING",
                                      text: $medical)
                    
                    FormRandTextField(iD: "donations", pageNum: 6,
                                      question: formQuestions[6][18] ?? "MISSING",
                                      text: $donations)
                    
                    FormRandTextField(iD: "cellphone", pageNum: 6,
                                      question: formQuestions[6][19] ?? "MISSING",
                                      text: $cellphone)
                }
                
                Group {
                    FormRandTextField(iD: "telephoneISP", pageNum: 6,
                                      question: formQuestions[6][20] ?? "MISSING",
                                      text: $telephoneISP)
                    
                    FormRandTextField(iD: "expensesMaintenanceAlimony", pageNum: 6,
                                      question: formQuestions[6][21] ?? "MISSING",
                                      text: $expensesMaintenanceAlimony)
                    
                    FormRandTextField(iD: "installmentExp", pageNum: 6,
                                      question: formQuestions[6][22] ?? "MISSING",
                                      text: $installmentExp)
                    
                    FormOtherQuestion(iD: "otherExpenses", pageNum: 6,
                                      question: formQuestions[6][23] ?? "MISSING",
                                      other: $otherExpenses,
                                      otherText: $otherExpensesText)
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
        .navigationBarTitle("Expenses")
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

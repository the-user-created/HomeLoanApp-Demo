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
    let handleChangedValues = HandleChangedValues()
    
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
                    Text("Save")
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
        /*if  {
            return true
        }*/
        
        return false
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if !changedValues.isEmpty {
            isDone = determineComplete()
            saveApplication()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - saveApplication
    private func saveApplication() {
        UIApplication.shared.endEditing()
        for (key, value) in changedValues {
            applicationCreation.application.setValue(value, forKey: key)
        }
        
        do {
            try viewContext.save()
            print("print - Application Entity Updated")
            applicationCreation.expensesSaved = true
            handleChangedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

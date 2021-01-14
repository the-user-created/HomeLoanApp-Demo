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
    
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let handleChangedValues = HandleChangedValues()
    
    var body: some View {
        Form() {
            Section(header: Text("INCOME")) {
                FormRandTextField(iD: "basicSalary", pageNum: 5,
                                  question: formQuestions[5][0] ?? "MISSING",
                                  text: $basicSalary)
            
                FormRandTextField(iD: "wages", pageNum: 5,
                                  question: formQuestions[5][1] ?? "MISSING",
                                  text: $wages)
                
                FormRandTextField(iD: "averageComm", pageNum: 5,
                                  question: formQuestions[5][2] ?? "MISSING",
                                  text: $averageComm)
                
                FormRandTextField(iD: "investments", pageNum: 5,
                                  question: formQuestions[5][3] ?? "MISSING",
                                  text: $investments)
                
                FormRandTextField(iD: "rentIncome", pageNum: 5,
                                  question: formQuestions[5][4] ?? "MISSING",
                                  text: $rentIncome)
                
                FormRandTextField(iD: "futureRentIncome", pageNum: 5,
                                  question: formQuestions[5][5] ?? "MISSING",
                                  text: $futureRentIncome)
                
                FormRandTextField(iD: "housingSub", pageNum: 5,
                                  question: formQuestions[5][6] ?? "MISSING",
                                  text: $housingSub)
                
                FormRandTextField(iD: "averageOvertime", pageNum: 5,
                                  question: formQuestions[5][7] ?? "MISSING",
                                  text: $averageOvertime)
                
                FormRandTextField(iD: "monthCarAllowance", pageNum: 5,
                                  question: formQuestions[5][8] ?? "MISSING",
                                  text: $monthCarAllowance)
                
                Group() {
                    FormRandTextField(iD: "interestIncome", pageNum: 5,
                                      question: formQuestions[5][9] ?? "MISSING",
                                      text: $interestIncome)
                
                    FormRandTextField(iD: "travelAllowance", pageNum: 5,
                                      question: formQuestions[5][10] ?? "MISSING",
                                      text: $travelAllowance)
                    
                    FormRandTextField(iD: "entertainment", pageNum: 5,
                                      question: formQuestions[5][11] ?? "MISSING",
                                      text: $entertainment)
                    
                    FormRandTextField(iD: "incomeFromSureties", pageNum: 5,
                                      question: formQuestions[5][12] ?? "MISSING",
                                      text: $incomeFromSureties)
                    
                    FormRandTextField(iD: "maintenanceAlimony", pageNum: 5,
                                      question: formQuestions[5][13] ?? "MISSING",
                                      text: $maintenanceAlimony)
                    
                    FormOtherQuestion(iD: "other", pageNum: 5,
                                      question: formQuestions[5][14] ?? "MISSING",
                                      other: $otherIncome,
                                      otherText: $otherIncomeText)
                }
            }
            
            Section(header: Text("DEDUCTIONS")) {
                FormRandTextField(iD: "tax", pageNum: 5,
                                  question: formQuestions[5][15] ?? "MISSING",
                                  text: $tax)
                
                FormRandTextField(iD: "pension", pageNum: 5,
                                  question: formQuestions[5][16] ?? "MISSING",
                                  text: $pension)
                
                FormRandTextField(iD: "uIF", pageNum: 5,
                                  question: formQuestions[5][17] ?? "MISSING",
                                  text: $uIF)
                
                FormRandTextField(iD: "medicalAid", pageNum: 5,
                                  question: formQuestions[5][18] ?? "MISSING",
                                  text: $medicalAid)
                
                FormOtherQuestion(iD: "otherDeductions", pageNum: 5,
                                  question: formQuestions[5][19] ?? "MISSING",
                                  other: $otherDeduction,
                                  otherText: $otherDeductionText)
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
        .navigationBarTitle("Income")
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
            applicationCreation.incomeSaved = true
            handleChangedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

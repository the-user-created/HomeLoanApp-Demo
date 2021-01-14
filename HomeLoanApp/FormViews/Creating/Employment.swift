//
//  Employment.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/11/30.
//

import SwiftUI

struct Employment: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    
    // MARK: - State Variables
    @State var occupationalStatus = 0
    @State var payingScheme = 0
    @State var incomeSource = 0
    @State var natureOfOccupation = ""
    @State var occupationLevel = 0
    @State var employmentSector = 0
    @State var natureOfBusiness = ""
    @State var employer = ""
    @State var companyRegNum = ""
    @State var employeeNum = ""
    @State var employmentPeriodYears = ""
    @State var employmentPeriodMonths = ""
    @State var employerCountry = 0
    @State var employerLine1 = ""
    @State var employerLine2 = ""
    @State var employerSuburb = ""
    @State var employerCity = ""
    @State var employerProvince = ""
    @State var employerStreetCode = ""
    @State var workPhoneNum = ""
    @State var purchaseJobChange = ""
    @State var workInZA = ""
    @State var previouslyEmployed = ""
    @State var previousEmployer = ""
    @State var pEContact = ""
    @State var pEDurationYears = ""
    @State var pEDurationMonths = ""
    
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let handleChangedValues = HandleChangedValues()
    
    let occupationalStatusSelection = ["--select--", "Full-time employed (non-Professional)", "--TBA--"]
    let payingSchemeSelection = ["--select--", "Monthly", "--TBA--"]
    let sourceIncome = ["--select--", "Salary", "--TBA--"]
    let occupationLevelSelection = ["--select--", "Skilled Worker", "--TBA--"]
    let employmentSectorSelection = ["--select--", "Other", "--TBA--"]
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("OCCUPATION")) {
                FormPicker(iD: "occupationalStatus", pageNum: 4,
                           question: formQuestions[4][0] ?? "MISSING",
                           selectionOptions: occupationalStatusSelection,
                           selection: $occupationalStatus)
                
                FormPicker(iD: "payingScheme", pageNum: 4,
                           question: formQuestions[4][1] ?? "MISSING",
                           selectionOptions: payingSchemeSelection,
                           selection: $payingScheme)
                
                FormPicker(iD: "incomeSource", pageNum: 4,
                           question: formQuestions[4][2] ?? "MISSING",
                           selectionOptions: sourceIncome,
                           selection: $incomeSource)
                
                FormTextField(iD: "natureOfOccupation", pageNum: 4,
                              question: formQuestions[4][3] ?? "MISSING",
                              placeholder: "something",
                              text: $natureOfOccupation)
                
                FormPicker(iD: "occupationLevel", pageNum: 4,
                           question: formQuestions[4][4] ?? "MISSING",
                           selectionOptions: occupationLevelSelection,
                           selection: $occupationLevel)
                
                FormPicker(iD: "employmentSector", pageNum: 4,
                           question: formQuestions[4][5] ?? "MISSING",
                           selectionOptions: employmentSectorSelection,
                           selection: $employmentSector)
                
                Group() {
                    FormTextField(iD: "natureOfBusiness", pageNum: 4,
                                  question: formQuestions[4][6] ?? "MISSING",
                                  placeholder: "something",
                                  text: $natureOfBusiness)
                    
                    FormTextField(iD: "employer", pageNum: 4,
                                  question: formQuestions[4][7] ?? "MISSING",
                                  placeholder: "something",
                                  text: $employer)
                    
                    FormTextField(iD: "companyRegNum", pageNum: 4,
                                  question: formQuestions[4][8] ?? "MISSING",
                                  placeholder: "something",
                                  text: $companyRegNum)
                    
                    FormTextField(iD: "employeeNum", pageNum: 4,
                                  question: formQuestions[4][9] ?? "MISSING",
                                  placeholder: "something",
                                  text: $employeeNum)
                    
                    FormLenAt(iD: "employmentPeriod", pageNum: 4,
                              question: formQuestions[4][10] ?? "MISSING",
                              yearsText: $employmentPeriodYears,
                              monthsText: $employmentPeriodMonths)
                }
            }
            
            Section(header: Text("EMPLOYER ADDRESS")) {
                FormPicker(iD: "employerCountry", pageNum: 4,
                           question: formQuestions[4][11] ?? "MISSING",
                           selectionOptions: countries,
                           selection: $employerCountry)
                
                FormTextField(iD: "employerLine1", pageNum: 4,
                              question: formQuestions[4][12] ?? "MISSING",
                              placeholder: "something",
                              text: $employerLine1)
                
                FormTextField(iD: "employerLine2", pageNum: 4,
                              question: formQuestions[4][13] ?? "MISSING",
                              placeholder: "something",
                              text: $employerLine2)
                
                FormTextField(iD: "employerSuburb", pageNum: 4,
                              question: formQuestions[4][14] ?? "MISSING",
                              placeholder: "something",
                              text: $employerSuburb)
                
                FormTextField(iD: "employerCity", pageNum: 4,
                              question: formQuestions[4][15] ?? "MISSING",
                              placeholder: "something",
                              text: $employerCity)
                
                FormTextField(iD: "employerProvince", pageNum: 4,
                              question: formQuestions[4][16] ?? "MISSING",
                              placeholder: "something",
                              text: $employerProvince)
                
                FormTextField(iD: "employerStreetCode", pageNum: 4,
                              question: formQuestions[4][17] ?? "MISSING",
                              placeholder: "something",
                              text: $employerStreetCode)
                
                FormTextField(iD: "workPhoneNum", pageNum: 4,
                              question: formQuestions[4][18] ?? "MISSING",
                              placeholder: "something",
                              text: $workPhoneNum).keyboardType(.phonePad)
                
                Group {
                    FormYesNo(iD: "purchaseJobChange", pageNum: 4,
                              question: formQuestions[4][19] ?? "MISSING",
                              selected: $purchaseJobChange)
                    
                    FormYesNo(iD: "workInZA", pageNum: 4,
                              question: formQuestions[4][20] ?? "MISSING",
                              selected: $workInZA)
                    
                    FormYesNo(iD: "previouslyEmployed", pageNum: 4,
                              question: formQuestions[4][21] ?? "MISSING",
                              selected: $previouslyEmployed)
                }
            }
            
            if previouslyEmployed == "Yes" {
                Section(header: Text("PREVIOUS EMPLOYER")) {
                    FormTextField(iD: "previousEmployer", pageNum: 4,
                                  question: formQuestions[4][21.1] ?? "MISSING",
                                  placeholder: "something",
                                  text: $previousEmployer)
                    
                    FormTextField(iD: "pEContact", pageNum: 4,
                                  question: formQuestions[4][21.2] ?? "MISSING",
                                  placeholder: "something",
                                  text: $pEContact)
                        .keyboardType(.phonePad)
                    
                    FormLenAt(iD: "pEDuration", pageNum: 4,
                              question: formQuestions[4][21.3] ?? "MISSING",
                              yearsText: $pEDurationYears,
                              monthsText: $pEDurationMonths)
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
        .navigationBarTitle("Employment")
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
            applicationCreation.employmentSaved = true
            handleChangedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

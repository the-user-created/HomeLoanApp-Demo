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
    @EnvironmentObject var changedValues: ChangedValues
    
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
    
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var isActive: Bool = false
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    let occupationalStatuses = ["--select--", "Full-time employed (non-Professional)", "Full-time employed (Professional)", "Housewife", "Part-time employed", "Pensioner", "Scholar", "Self employed (non-Professional)", "Self employed (Professional)", "Student", "Temporary employed", "Unemployed"]
    let payingSchemes = ["--select--", "Annually", "Monthly", "Quarterly", "Weekly"]
    let incomeSources = ["--select--", "Salary", "Pension", "Retirement Annuity", "Investments", "Donation/Gift", "Allowance", "Commission", "Inheritance", "Maintenance / Alimony", "Social Grant", "Bonus", "Insurance Claim", "Profit from Own Business", "Prize Winnings", "Asset Disposal"]
    let occupationLevels = ["--select--", "Junior position", "Management", "Semi-skilled worker", "Senior Management", "Skilled Worker", "Supervisor", "Unskilled worker"]
    let employmentSectors = ["--select--", "Animal Specialist", "Armed Forces", "Catering and entertainment", "Civil Service", "Construction", "Education", "Finance", "Forestry", "Health / Medical", "Industry", "Information Technology", "Legal Profession", "Media", "Other", "Science", "Security", "Selling", "Transportation", "Welfare"]
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("OCCUPATION")) {
                FormPicker(iD: "occupationalStatus",
                           question: formQuestions[4][0] ?? "MISSING",
                           selectionOptions: occupationalStatuses,
                           selection: $occupationalStatus)
                
                FormPicker(iD: "payingScheme",
                           question: formQuestions[4][1] ?? "MISSING",
                           selectionOptions: payingSchemes,
                           selection: $payingScheme)
                
                FormPicker(iD: "incomeSource",
                           question: formQuestions[4][2] ?? "MISSING",
                           selectionOptions: incomeSources,
                           selection: $incomeSource)
                
                FormTextField(iD: "natureOfOccupation",
                              question: formQuestions[4][3] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[4][3] ?? "MISSING",
                              text: $natureOfOccupation, sender: .editor)
                
                FormPicker(iD: "occupationLevel",
                           question: formQuestions[4][4] ?? "MISSING",
                           selectionOptions: occupationLevels,
                           selection: $occupationLevel)
                
                FormPicker(iD: "employmentSector",
                           question: formQuestions[4][5] ?? "MISSING",
                           selectionOptions: employmentSectors,
                           selection: $employmentSector)
                
                Group() {
                    FormTextField(iD: "natureOfBusiness",
                                  question: formQuestions[4][6] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[4][6] ?? "MISSING",
                                  text: $natureOfBusiness, sender: .editor)
                    
                    FormTextField(iD: "employer",
                                  question: formQuestions[4][7] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[4][7] ?? "MISSING",
                                  text: $employer, sender: .editor)
                    
                    FormTextField(iD: "companyRegNum",
                                  question: formQuestions[4][8] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[4][8] ?? "MISSING",
                                  text: $companyRegNum, sender: .editor)
                    
                    FormTextField(iD: "employeeNum",
                                  question: formQuestions[4][9] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[4][9] ?? "MISSING",
                                  text: $employeeNum, sender: .editor)
                    
                    FormLenAt(iD: "employmentPeriod",
                              question: formQuestions[4][10] ?? "MISSING",
                              yearsText: $employmentPeriodYears,
                              monthsText: $employmentPeriodMonths)
                }
            }
            
            Section(header: Text("EMPLOYER ADDRESS")) {
                FormPicker(iD: "employerCountry",
                           question: formQuestions[4][11] ?? "MISSING",
                           selectionOptions: countries,
                           selection: $employerCountry)
                
                FormTextField(iD: "employerLine1",
                              question: formQuestions[4][12] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[4][12] ?? "MISSING",
                              text: $employerLine1, sender: .editor)
                
                FormTextField(iD: "employerLine2",
                              question: formQuestions[4][13] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[4][13] ?? "MISSING",
                              text: $employerLine2, sender: .editor)
                
                FormTextField(iD: "employerSuburb",
                              question: formQuestions[4][14] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[4][14] ?? "MISSING",
                              text: $employerSuburb, sender: .editor)
                
                FormTextField(iD: "employerCity",
                              question: formQuestions[4][15] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[4][15] ?? "MISSING",
                              text: $employerCity, sender: .editor)
                
                FormTextField(iD: "employerProvince",
                              question: formQuestions[4][16] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[4][16] ?? "MISSING",
                              text: $employerProvince, sender: .editor)
                
                FormTextField(iD: "employerStreetCode",
                              question: formQuestions[4][17] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[4][17] ?? "MISSING",
                              text: $employerStreetCode, sender: .editor)
                
                FormTextField(iD: "workPhoneNum",
                              question: formQuestions[4][18] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[4][18] ?? "MISSING",
                              text: $workPhoneNum, sender: .editor)
                    .keyboardType(.phonePad)
                
                Group {
                    FormYesNo(iD: "purchaseJobChange",
                              question: formQuestions[4][19] ?? "MISSING",
                              selected: $purchaseJobChange)
                    
                    FormYesNo(iD: "workInZA",
                              question: formQuestions[4][20] ?? "MISSING",
                              selected: $workInZA)
                    
                    FormYesNo(iD: "previouslyEmployed",
                              question: formQuestions[4][21] ?? "MISSING",
                              selected: $previouslyEmployed)
                }
            }
            
            if previouslyEmployed == "Yes" {
                Section(header: Text("PREVIOUS EMPLOYER")) {
                    FormTextField(iD: "previousEmployer",
                                  question: formQuestions[4][21.1] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[4][21.1] ?? "MISSING",
                                  text: $previousEmployer, sender: .editor)
                    
                    FormTextField(iD: "pEContact",
                                  question: formQuestions[4][21.2] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[4][21.2] ?? "MISSING",
                                  text: $pEContact, sender: .editor)
                        .keyboardType(.phonePad)
                    
                    FormLenAt(iD: "pEDuration",
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
            }
        }
        .navigationBarTitle("Employment")
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
        .onChange(of: previouslyEmployed) { _ in
            if previouslyEmployed != "Yes" {
                self.previousEmployer = ""
                self.pEContact = ""
                self.pEDurationYears = ""
                self.pEDurationMonths = ""
                changedValues.changedValues.merge(dict: ["previousEmployer": "", "pEContact": "", "pEDuration": "[][]"])
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        if occupationalStatus != 0 && payingScheme != 0 && incomeSource != 0 && !natureOfOccupation.isEmpty && occupationLevel != 0 && employmentSector != 0 && !natureOfBusiness.isEmpty && !employer.isEmpty && !companyRegNum.isEmpty && (!employmentPeriodYears.isEmpty || !employmentPeriodMonths.isEmpty) && employerCountry != 0 && !employerLine1.isEmpty && !employerSuburb.isEmpty && !employerCity.isEmpty && !employerProvince.isEmpty && !employerStreetCode.isEmpty && !workPhoneNum.isEmpty && !purchaseJobChange.isEmpty && !workInZA.isEmpty && !previouslyEmployed.isEmpty {
            
            if previouslyEmployed == "Yes" && (!previousEmployer.isEmpty && !pEContact.isEmpty && (!pEDurationYears.isEmpty || !pEDurationMonths.isEmpty)) {
                isComplete = true
            } else if previouslyEmployed == "No" {
                isComplete = true
            }
        }
        
        changedValues.changedValues.updateValue(isComplete, forKey: "employmentDone")
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
    
    // MARK: - saveApplication
    private func saveApplication() {
        UIApplication.shared.endEditing()
        for (key, value) in changedValues.changedValues {
            applicationCreation.application.setValue(value, forKey: key)
        }
        
        do {
            try viewContext.save()
            print("print - Application Entity Updated")
            applicationCreation.employmentSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

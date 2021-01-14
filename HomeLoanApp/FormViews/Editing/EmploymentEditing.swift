//
//  EmploymentEditing.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/14.
//

import SwiftUI

struct EmploymentEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
    
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
    
    @State var sender: ChoosePageVer
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let handleChangedValues = HandleChangedValues()
    
    let occupationalStatusSelection = ["--select--", "Full-time employed (non-Professional)", "--TBA--"]
    let payingSchemeSelection = ["--select--", "Monthly", "--TBA--"]
    let sourceIncome = ["--select--", "Salary", "--TBA--"]
    let occupationLevelSelection = ["--select--", "Skilled Worker", "--TBA--"]
    let employmentSectorSelection = ["--select--", "Other", "--TBA--"]
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: ChoosePageVer) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._occupationalStatus = State(wrappedValue: occupationalStatusSelection.firstIndex(of: self.application.occupationalStatus ?? "--select--") ?? 0)
        self._payingScheme = State(wrappedValue: payingSchemeSelection.firstIndex(of: self.application.payingScheme ?? "--select--") ?? 0)
        self._incomeSource = State(wrappedValue: sourceIncome.firstIndex(of: self.application.incomeSource ?? "--select--") ?? 0)
        self._natureOfOccupation = State(wrappedValue: self.application.natureOfOccupation ?? "")
        self._occupationLevel = State(wrappedValue: occupationLevelSelection.firstIndex(of: self.application.occupationLevel ?? "--select--") ?? 0)
        self._employmentSector = State(wrappedValue: employmentSectorSelection.firstIndex(of: self.application.employmentSector ?? "--select--") ?? 0)
        self._natureOfBusiness = State(wrappedValue: self.application.natureOfBusiness ?? "")
        self._employer = State(wrappedValue: self.application.employer ?? "")
        self._companyRegNum = State(wrappedValue: self.application.companyRegNum ?? "")
        self._employeeNum = State(wrappedValue: self.application.employeeNum ?? "")
        self._employerCountry = State(wrappedValue: countries.firstIndex(of: self.application.employerCountry ?? "--select--") ?? 0)
        self._employerLine1 = State(wrappedValue: self.application.employerLine1 ?? "")
        self._employerLine2 = State(wrappedValue: self.application.employerLine2 ?? "")
        self._employerSuburb = State(wrappedValue: self.application.employerSuburb ?? "")
        self._employerCity = State(wrappedValue: self.application.employerCity ?? "")
        self._employerProvince = State(wrappedValue: self.application.employerProvince ?? "")
        self._employerStreetCode = State(wrappedValue: self.application.employerStreetCode ?? "")
        self._workPhoneNum = State(wrappedValue: self.application.workPhoneNum ?? "")
        self._purchaseJobChange = State(wrappedValue: self.application.purchaseJobChange ?? "")
        self._workInZA = State(wrappedValue: self.application.workInZA ?? "")
        self._previouslyEmployed = State(wrappedValue: self.application.previouslyEmployed ?? "")
        self._previousEmployer = State(wrappedValue: self.application.previousEmployer ?? "")
        self._pEContact = State(wrappedValue: self.application.pEContact ?? "")
        
        if let employmentPeriod = self.application.employmentPeriod {
            let openBracketIndices = findNth("[", text: employmentPeriod)
            let closeBracketIndices = findNth("]", text: employmentPeriod)
            
            self._employmentPeriodYears = State(wrappedValue: String(employmentPeriod[employmentPeriod.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
            self._employmentPeriodMonths = State(wrappedValue: String(employmentPeriod[employmentPeriod.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
        }
        
        if let pEDuration = self.application.pEDuration {
            let openBracketIndices = findNth("[", text: pEDuration)
            let closeBracketIndices = findNth("]", text: pEDuration)
            
            self._pEDurationYears = State(wrappedValue: String(pEDuration[pEDuration.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
            self._pEDurationMonths = State(wrappedValue: String(pEDuration[pEDuration.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
        }
    }
    
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
                    Text("Save changes")
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
            addToApplication()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - addToApplication
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
            print("print - Application Entity Updated")
            handleChangedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}


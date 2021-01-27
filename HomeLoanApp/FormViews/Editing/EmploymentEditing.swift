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
    
    @State var initValues: Dictionary<String, AnyHashable> = [:]
    @State var savingValues: Dictionary<String, AnyHashable> = [:]
    @State var sender: Sender
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    let occupationalStatuses = ["--select--", "Full-time employed (non-Professional)", "Full-time employed (Professional)", "Housewife", "Part-time employed", "Pensioner", "Scholar", "Self employed (non-Professional)", "Self employed (Professional)", "Student", "Temporary employed", "Unemployed"]
    let payingSchemes = ["--select--", "Annually", "Monthly", "Quarterly", "Weekly"]
    let incomeSources = ["--select--", "Salary", "Pension", "Retirement Annuity", "Investments", "Donation/Gift", "Allowance", "Commission", "Inheritance", "Maintenance / Alimony", "Social Grant", "Bonus", "Insurance Claim", "Profit from Own Business", "Prize Winnings", "Asset Disposal"]
    let occupationLevels = ["--select--", "Junior position", "Management", "Semi-skilled worker", "Senior Management", "Skilled Worker", "Supervisor", "Unskilled worker"]
    let employmentSectors = ["--select--", "Animal Specialist", "Armed Forces", "Catering and entertainment", "Civil Service", "Construction", "Education", "Finance", "Forestry", "Health / Medical", "Industry", "Information Technology", "Legal Profession", "Media", "Other", "Science", "Security", "Selling", "Transportation", "Welfare"]
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: Sender) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._occupationalStatus = State(wrappedValue: occupationalStatuses.firstIndex(of: self.application.occupationalStatus ?? "--select--") ?? 0)
        self._payingScheme = State(wrappedValue: payingSchemes.firstIndex(of: self.application.payingScheme ?? "--select--") ?? 0)
        self._incomeSource = State(wrappedValue: incomeSources.firstIndex(of: self.application.incomeSource ?? "--select--") ?? 0)
        self._natureOfOccupation = State(wrappedValue: self.application.natureOfOccupation ?? "")
        self._occupationLevel = State(wrappedValue: occupationLevels.firstIndex(of: self.application.occupationLevel ?? "--select--") ?? 0)
        self._employmentSector = State(wrappedValue: employmentSectors.firstIndex(of: self.application.employmentSector ?? "--select--") ?? 0)
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
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._employmentPeriodYears = State(wrappedValue: String(employmentPeriod[employmentPeriod.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._employmentPeriodMonths = State(wrappedValue: String(employmentPeriod[employmentPeriod.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
        
        if let pEDuration = self.application.pEDuration {
            let openBracketIndices = findNth("[", text: pEDuration)
            let closeBracketIndices = findNth("]", text: pEDuration)
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._pEDurationYears = State(wrappedValue: String(pEDuration[pEDuration.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._pEDurationMonths = State(wrappedValue: String(pEDuration[pEDuration.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
        
        self._initValues = State(wrappedValue: ["occupationalStatus": self.occupationalStatus, "payingScheme": self.payingScheme, "incomeSource": self.incomeSource, "natureOfOccupation": self.natureOfOccupation, "occupationLevel": self.occupationLevel, "employmentSector": self.employmentSector, "natureOfBusiness": self.natureOfBusiness, "employer": self.employer, "companyRegNum": self.companyRegNum, "employeeNum": self.employeeNum, "employmentPeriod": "[\(self.employmentPeriodYears)][\(self.employmentPeriodMonths)]", "employerCountry": self.employerCountry, "employerLine1": self.employerLine1, "employerLine2": self.employerLine2, "employerSuburb": self.employerSuburb, "employerCity": self.employerCity, "employerProvince": self.employerProvince, "employerStreetCode": self.employerStreetCode, "workPhoneNum": self.workPhoneNum, "purchaseJobChange": self.purchaseJobChange, "workInZA": self.workInZA, "previouslyEmployed": self.previouslyEmployed, "previousEmployer": self.previousEmployer, "pEContact": self.pEContact, "pEDuration": "[\(self.pEDurationYears)][\(self.pEDurationMonths)]"])
    }
    
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
                                  question: formQuestions[4][22] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[4][22] ?? "MISSING",
                                  text: $previousEmployer, sender: .editor)
                    
                    FormTextField(iD: "pEContact",
                                  question: formQuestions[4][23] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[4][23] ?? "MISSING",
                                  text: $pEContact, sender: .editor)
                        .keyboardType(.phonePad)
                    
                    FormLenAt(iD: "pEDuration",
                              question: formQuestions[4][24] ?? "MISSING",
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
            }
        }
        .navigationBarTitle("Employment")
        .onTapGesture(count: 2, perform: UIApplication.shared.endEditing)
        .onReceive(resignPub) { _ in
            handleSaving()
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
    
    // MARK: - hasChanged
    private func hasChanged() -> Bool {
        self.savingValues = ["occupationalStatus": self.occupationalStatus, "payingScheme": self.payingScheme, "incomeSource": self.incomeSource, "natureOfOccupation": self.natureOfOccupation, "occupationLevel": self.occupationLevel, "employmentSector": self.employmentSector, "natureOfBusiness": self.natureOfBusiness, "employer": self.employer, "companyRegNum": self.companyRegNum, "employeeNum": self.employeeNum, "employmentPeriod": "[\(self.employmentPeriodYears)][\(self.employmentPeriodMonths)]", "employerCountry": self.employerCountry, "employerLine1": self.employerLine1, "employerLine2": self.employerLine2, "employerSuburb": self.employerSuburb, "employerCity": self.employerCity, "employerProvince": self.employerProvince, "employerStreetCode": self.employerStreetCode, "workPhoneNum": self.workPhoneNum, "purchaseJobChange": self.purchaseJobChange, "workInZA": self.workInZA, "previouslyEmployed": self.previouslyEmployed, "previousEmployer": self.previousEmployer, "pEContact": self.pEContact, "pEDuration": "[\(self.pEDurationYears)][\(self.pEDurationMonths)]"]
        
        if self.savingValues != self.initValues {
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
    
    // MARK: - addToApplication
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
            print("print - Application Entity Updated")
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}


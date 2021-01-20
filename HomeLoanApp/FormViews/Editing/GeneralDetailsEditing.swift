//
//  GeneralDetailsEditing.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/21.
//

import SwiftUI
import CoreData
import Combine

struct GeneralDetailsEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    @ObservedObject var application: Application
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let salesConsultants = ["--select--","Gavin Young", "--TBA--"]
    let applicationType = ["--select--","New loan", "--TBA--"]
    let applicantType = ["--select--","Individual", "--TBA--"]
    let loanPurpose = ["--select--","Buy an existing home", "--TBA--"]
    let propertyType = ["--select--","Normal residential", "--TBA--"]
    
    // MARK: - State Variables
    @State var salesConsultantIndex = 0
    @State var applicationTypeIndex = 0
    @State var applicantTypeIndex = 0
    @State var propertyTypeIndex = 0
    @State var loanPurposeIndex = 0
    
    @State var numberOfApplicants = ""
    @State var coApplicantOneName = ""
    @State var coApplicantTwoName = ""
    @State var coApplicantThreeName = ""
    
    @State var initValues: Dictionary<String, AnyHashable> = [:]
    @State var savingValues: Dictionary<String, AnyHashable> = [:]
    @State var sender: Sender
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @Binding var isDone: Bool
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: Sender) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._salesConsultantIndex = State(wrappedValue: salesConsultants.firstIndex(of: self.application.salesConsultant ?? "--select--") ?? 0)
        self._applicationTypeIndex = State(wrappedValue: applicationType.firstIndex(of: self.application.applicationType ?? "--select--") ?? 0)
        self._applicantTypeIndex = State(wrappedValue: applicantType.firstIndex(of: self.application.applicantType ?? "--select--") ?? 0)
        self._loanPurposeIndex = State(wrappedValue: loanPurpose.firstIndex(of: self.application.loanPurpose ?? "--select--") ?? 0)
        self._propertyTypeIndex = State(wrappedValue: propertyType.firstIndex(of: self.application.propertyType ?? "--select--") ?? 0)
        self._numberOfApplicants = State(wrappedValue: self.application.numberOfApplicants ?? "")
        self._coApplicantOneName = State(wrappedValue: self.application.coApplicantOneName ?? "")
        self._coApplicantTwoName = State(wrappedValue: self.application.coApplicantTwoName ?? "")
        self._coApplicantThreeName = State(wrappedValue: self.application.coApplicantThreeName ?? "")
        
        self._initValues = State(wrappedValue: ["salesConsultant": self.salesConsultantIndex, "applicationType": self.applicationTypeIndex, "applicantType": self.applicantTypeIndex, "loanPurpose": self.loanPurposeIndex, "propertyType": self.propertyTypeIndex, "numberOfApplicants": self.numberOfApplicants, "coApplicantOneName": self.coApplicantOneName, "coApplicantTwoName": self.coApplicantTwoName, "coApplicantThreeName": self.coApplicantThreeName])
    }
    
    var body: some View {
        Form() {
            Section(header: Text("GENERAL")) {
                FormPicker(iD: "salesConsultant",
                           question: formQuestions[0][0] ?? "MISSING",
                           selectionOptions: salesConsultants,
                           infoButton: true,
                           selection: $salesConsultantIndex)
                
                FormPicker(iD: "applicationType",
                           question: formQuestions[0][1] ?? "MISSING",
                           selectionOptions: applicationType,
                           selection: $applicationTypeIndex)
                
                FormPicker(iD: "applicantType",
                           question: formQuestions[0][2] ?? "MISSING",
                           selectionOptions: applicantType,
                           selection: $applicantTypeIndex)
                
                FormPicker(iD: "loanPurpose",
                           question: formQuestions[0][3] ?? "MISSING",
                           selectionOptions: loanPurpose,
                           selection: $loanPurposeIndex)
                
                FormPicker(iD: "propertyType",
                           question: formQuestions[0][4] ?? "MISSING",
                           selectionOptions: propertyType,
                           selection: $propertyTypeIndex)
            }
            
            Section() {
                FormTextField(iD: "numberOfApplicants",
                              question: formQuestions[0][5] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[0][5] ?? "MISSING",
                              text: $numberOfApplicants, sender: .editor)
                    .keyboardType(.numberPad)
            }
            
            if numberOfApplicants != "" && numberOfApplicants != "1" {
                Section(header: Text("CO-APPLICANTS")) {
                    VStack() {
                        switch numberOfApplicants {
                            case "2":
                                FormTextField(iD: "coApplicantOneName",
                                              question: "Co-Applicant #1: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantOneName, sender: .editor)
                                
                            case "3":
                                FormTextField(iD: "coApplicantOneName",
                                              question: "Co-Applicant #1: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantOneName, sender: .editor)
                                FormTextField(iD: "coApplicantTwoName",
                                              question: "Co-Applicant #2: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantTwoName, sender: .editor)
                                
                            case "4":
                                FormTextField(iD: "coApplicantOneName",
                                              question: "Co-Applicant #1: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantOneName, sender: .editor)
                                FormTextField(iD: "coApplicantTwoName",
                                              question: "Co-Applicant #2: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantTwoName, sender: .editor)
                                FormTextField(iD: "coApplicantThreeName",
                                              question: "Co-Applicant #3: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantThreeName, sender: .editor)
                                
                            case let x where Int(x) ?? 0 < 1:
                                Text("Please enter a valid number of applicants.")
                            case let x where Int(x) ?? 5 > 4:
                                Text("We currently only support in-app applications of up to 4 applicants. Please proceed to contact the Sales Consultant directly to get your application started.")
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.blue)
                            default:
                                EmptyView()
                        }
                    }
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
        .onTapGesture(count: 2, perform: UIApplication.shared.endEditing)
        .navigationBarTitle("General")
        .onReceive(resignPub) { _ in
            handleSaving()
        }
        .onChange(of: numberOfApplicants) { value in
            switch Int(value) {
                case 1:
                    self.coApplicantOneName = ""
                    self.coApplicantTwoName = ""
                    self.coApplicantThreeName = ""
                    changedValues.changedValues.merge(dict: ["coApplicantOneName": "", "coApplicantTwoName": "", "coApplicantThreeName": ""])
                case 2:
                    self.coApplicantTwoName = ""
                    self.coApplicantThreeName = ""
                    changedValues.changedValues.merge(dict: ["coApplicantTwoName": "", "coApplicantThreeName": ""])
                case 3:
                    self.coApplicantThreeName = ""
                    changedValues.updateKeyValue("coApplicantThreeName", value: "")
                default:
                    return
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        if salesConsultantIndex != 0 && applicationTypeIndex != 0 && applicantTypeIndex != 0 && loanPurposeIndex != 0 && propertyTypeIndex != 0 && determineValidNumOfApplicants() {
            isComplete = true
        }
        
        changedValues.changedValues.updateValue(isComplete, forKey: "generalDetailsDone")
        return isComplete
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        let result: Bool = determineValidNumOfApplicants()
        
        if hasChanged() && result {
            isDone = determineComplete()
            addToApplication()
            presentationMode.wrappedValue.dismiss()
        } else if !result {
            showingAlert = true
        }
    }
    
    // MARK: - hasChanged
    private func hasChanged() -> Bool {
        self.savingValues = ["salesConsultant": self.salesConsultantIndex, "applicationType": self.applicationTypeIndex, "applicantType": self.applicantTypeIndex, "loanPurpose": self.loanPurposeIndex, "propertyType": self.propertyTypeIndex, "numberOfApplicants": self.numberOfApplicants, "coApplicantOneName": self.coApplicantOneName, "coApplicantTwoName": self.coApplicantTwoName, "coApplicantThreeName": self.coApplicantThreeName]
        
        if self.savingValues != self.initValues {
            return true
        }
        
        alertMessage = "No answers were changed."
        showingAlert = true
        return false
    }
    
    // MARK: - determineValidNumOfApplicants
    private func determineValidNumOfApplicants() -> Bool {
        var result: Bool = false
        switch Int(self.numberOfApplicants) {
            case 1:
                result = true
            case 2:
                if !self.coApplicantOneName.isEmpty {
                    result = true
                } else {
                    alertMessage = "Please add the name of co-applicant #1."
                }
            case 3:
                if !self.coApplicantOneName.isEmpty && !self.coApplicantTwoName.isEmpty {
                    result = true
                } else {
                    alertMessage = !coApplicantOneName.isEmpty ? "Please add the name of co-applicant #2." : (!coApplicantTwoName.isEmpty ? "Please add the name of co-applicant #1." : "Please add the names of co-applicant #1 and co-applicant #2.")
                }
            case 4:
                if !self.coApplicantOneName.isEmpty && !self.coApplicantTwoName.isEmpty && !self.coApplicantThreeName.isEmpty {
                    result = true
                } else if !self.coApplicantOneName.isEmpty && self.coApplicantTwoName.isEmpty && self.coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the names of co-applicant #2 and co-applicant #3."
                } else if self.coApplicantOneName.isEmpty && !self.coApplicantTwoName.isEmpty && self.coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the names of co-applicant #1 and co-applicant #3."
                } else if self.coApplicantOneName.isEmpty && self.coApplicantTwoName.isEmpty && !self.coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the names of co-applicant #1 and co-applicant #2."
                } else if !self.coApplicantOneName.isEmpty && !self.coApplicantTwoName.isEmpty && self.coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the name of co-applicant #3."
                } else if !self.coApplicantOneName.isEmpty && self.coApplicantTwoName.isEmpty && !self.coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the name of co-applicant #2."
                } else if self.coApplicantOneName.isEmpty && !self.coApplicantTwoName.isEmpty && !self.coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the name of co-applicant #1."
                } else {
                    alertMessage = "Please add the names of the co-applicants"
                }
            default:
                alertMessage = "Please specify the number of applicants."
        }
        
        return result
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

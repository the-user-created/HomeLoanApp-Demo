//
//  GeneralDetails.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/10/07.
//

import SwiftUI
import CoreData
//import Firebase

struct GeneralDetails: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
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
    
    @State var isActive: Bool = false
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - body
    var body: some View {
        Form {
            Section(header: Text("GENERAL")) {
                FormPicker(iD: "salesConsultant",
                           question: formQuestions[0][0] ?? "MISSING",
                           selectionOptions: salesConsultants,
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
            
            Section {
                FormTextField(iD: "numberOfApplicants",
                              question: formQuestions[0][5] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[0][5] ?? "MISSING",
                              text: $numberOfApplicants)
                    .keyboardType(.numberPad)
            }
            
            if numberOfApplicants != "" && numberOfApplicants != "1" {
                Section(header: Text("CO-APPLICANTS")) {
                    VStack {
                        switch numberOfApplicants {
                            case "2":
                                FormTextField(iD: "coApplicantOneName",
                                              question: "Co-Applicant #1: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantOneName)
                                
                            case "3":
                                FormTextField(iD: "coApplicantOneName",
                                              question: "Co-Applicant #1: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantOneName)
                                FormTextField(iD: "coApplicantTwoName",
                                              question: "Co-Applicant #2: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantTwoName)
                                
                            case "4":
                                FormTextField(iD: "coApplicantOneName",
                                              question: "Co-Applicant #1: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantOneName)
                                FormTextField(iD: "coApplicantTwoName",
                                              question: "Co-Applicant #2: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantTwoName)
                                FormTextField(iD: "coApplicantThreeName",
                                              question: "Co-Applicant #3: ",
                                              placeholder: "Steve Jobs",
                                              text: $coApplicantThreeName)
                                
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
            
            Section {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("General")
        .onReceive(resignPub) { _ in
            if isActive {
                handleSaving()
            }
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
        .onDisappear {
            isActive = false
        }
        .onAppear {
            isActive = true
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
        if determineValidNumOfApplicants() {
            isDone = determineComplete()
            saveApplication()
            presentationMode.wrappedValue.dismiss()
        } else {
            showingAlert = true
        }
    }
    
    // MARK: - determineValidNumOfApplicants
    private func determineValidNumOfApplicants() -> Bool {
        var result: Bool = false
        switch Int(numberOfApplicants) {
            case 1:
                result = true
            case 2:
                if !coApplicantOneName.isEmpty {
                    result = true
                } else {
                    alertMessage = "Please add the name of co-applicant #1."
                }
            case 3:
                if !coApplicantOneName.isEmpty && !coApplicantTwoName.isEmpty {
                    result = true
                } else {
                    alertMessage = !coApplicantOneName.isEmpty ? "Please add the name of co-applicant #2." : (!coApplicantTwoName.isEmpty ? "Please add the name of co-applicant #1." : "Please add the names of co-applicant #1 and co-applicant #2.")
                }
            case 4:
                if !coApplicantOneName.isEmpty && !coApplicantTwoName.isEmpty && !coApplicantThreeName.isEmpty {
                    result = true
                } else if !coApplicantOneName.isEmpty && coApplicantTwoName.isEmpty && coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the names of co-applicant #2 and co-applicant #3."
                } else if coApplicantOneName.isEmpty && !coApplicantTwoName.isEmpty && coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the names of co-applicant #1 and co-applicant #3."
                } else if coApplicantOneName.isEmpty && coApplicantTwoName.isEmpty && !coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the names of co-applicant #1 and co-applicant #2."
                } else if !coApplicantOneName.isEmpty && !coApplicantTwoName.isEmpty && coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the name of co-applicant #3."
                } else if !coApplicantOneName.isEmpty && coApplicantTwoName.isEmpty && !coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the name of co-applicant #2."
                } else if coApplicantOneName.isEmpty && !coApplicantTwoName.isEmpty && !coApplicantThreeName.isEmpty {
                    alertMessage = "Please add the name of co-applicant #1."
                } else {
                    alertMessage = "Please add the names of the co-applicants"
                }
            default:
                alertMessage = "Please specify the number of applicants."
        }
        
        return result
    }
    
    // MARK: - saveApplication
    private func saveApplication() {
        UIApplication.shared.endEditing()
        applicationCreation.makeApplication()
        
        for (key, value) in changedValues.changedValues {
            applicationCreation.application.setValue(value, forKey: key)
        }
        
        applicationCreation.application.loanID = UUID.init()
        applicationCreation.application.loanCreatedDate = Date()
        applicationCreation.application.loanStatus = Status.unsubmitted.rawValue
        
        do {
            try viewContext.save()
            print("print - New Application Saved")
            applicationCreation.generalDetailsSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print("print - \(error.localizedDescription)")
        }
    }
}

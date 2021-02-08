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
    @Environment(\.managedObjectContext) private var viewContext
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
    
    let salesConsultants = ["--select--", "Gavin Young", "--TBA--"]
    let applicationType = ["--select--", "Further Loan", "New loan"]//, "Pledge Application", "Switch from other institution"]
    let applicantType = ["--select--","Closed Corporation", "Clubs", "Estate Late Client", "Incorporated Company", "Individual", "Joint with other person", "Joint with other persons", "Joint with spouse", "Joint with spouse and other person", "Joint with spouse and other persons", "Non-Profit Organisations and Friendly Societies", "Partnerships", "Private Company", "Public Company", "Schools", "Sole Proprietor", "Trust"]
    let loanPurpose = ["--select--", "Bond Existing Home/Unbonded", "Build a new home", "Buy an existing home", "Buy vacant land", "Further Advance (ordinary)", "Home improvements"]
    let propertyType = ["--select--", "Duets - Sectional Title", "Normal residential", "Sectional title", "Small Holdings Residential", "Vacant land"]
    
    // MARK: - body
    var body: some View {
        Form() {
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
                    Text("Save")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .onTapGesture(count: 2, perform: UIApplication.shared.endEditing)
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
        .onDisappear() {
            isActive = false
        }
        .onAppear() {
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

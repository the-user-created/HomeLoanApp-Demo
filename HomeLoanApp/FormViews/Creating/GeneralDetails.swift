//
//  GeneralDetails.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/10/07.
//

import SwiftUI
import CoreData
import Firebase

struct GeneralDetails: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    
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
    
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let handleChangedValues = HandleChangedValues()
    
    let loanPurpose = ["--select--","Buy an existing home", "--TBA--"]
    let propertyType = ["--select--","Normal residential", "--TBA--"]
    let salesConsultants = ["--select--","Gavin Young", "--TBA--"]
    let applicationType = ["--select--","New loan", "--TBA--"]
    let applicantType = ["--select--","Individual", "--TBA--"]
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("GENERAL")) {
                FormPicker(iD: "salesConsultant", pageNum: 0,
                           question: formQuestions[0][0] ?? "MISSING",
                           selectionOptions: salesConsultants,
                           selection: $salesConsultantIndex)
                
                FormPicker(iD: "applicationType", pageNum: 0,
                           question: formQuestions[0][1] ?? "MISSING",
                           selectionOptions: applicationType,
                           selection: $applicationTypeIndex)
                
                FormPicker(iD: "applicantType", pageNum: 0,
                           question: formQuestions[0][2] ?? "MISSING",
                           selectionOptions: applicantType,
                           selection: $applicantTypeIndex)
                
                FormPicker(iD: "loanPurpose", pageNum: 0,
                           question: formQuestions[0][3] ?? "MISSING",
                           selectionOptions: loanPurpose,
                           selection: $loanPurposeIndex)
                
                FormPicker(iD: "propertyType", pageNum: 0,
                           question: formQuestions[0][4] ?? "MISSING",
                           selectionOptions: propertyType,
                           selection: $propertyTypeIndex)
            }
            
            Section() {
                FormTextField(iD: "numberOfApplicants", pageNum: 0,
                              question: formQuestions[0][5] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[0][5] ?? "MISSING",
                              text: $numberOfApplicants)
                    .keyboardType(.numberPad)
            }
            
            if numberOfApplicants != "" && numberOfApplicants != "1" {
                Section(header: Text("CO-APPLICANTS")) {
                    VStack() {
                        switch numberOfApplicants {
                        case "2":
                            FormTextField(iD: "coApplicantOneName", pageNum: 0,
                                          question: "Co-Applicant #1: ",
                                          placeholder: "Steve Jobs",
                                          text: $coApplicantOneName)
                            
                        case "3":
                            FormTextField(iD: "coApplicantOneName", pageNum: 0,
                                          question: "Co-Applicant #1: ",
                                          placeholder: "Steve Jobs",
                                          text: $coApplicantOneName)
                            FormTextField(iD: "coApplicantTwoName", pageNum: 0,
                                          question: "Co-Applicant #2: ",
                                          placeholder: "Steve Jobs",
                                          text: $coApplicantTwoName)
                            
                        case "4":
                            FormTextField(iD: "coApplicantOneName", pageNum: 0,
                                          question: "Co-Applicant #1: ",
                                          placeholder: "Steve Jobs",
                                          text: $coApplicantOneName)
                            FormTextField(iD: "coApplicantTwoName", pageNum: 0,
                                          question: "Co-Applicant #2: ",
                                          placeholder: "Steve Jobs",
                                          text: $coApplicantTwoName)
                            FormTextField(iD: "coApplicantThreeName", pageNum: 0,
                                          question: "Co-Applicant #3: ",
                                          placeholder: "Steve Jobs",
                                          text: $coApplicantThreeName)
                            
                        case let x where Int(x) ?? 0 < 1:
                            Text("Please enter a valid number of applicants.")
                                .foregroundColor(.blue)
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
            
            // Shows/Hides the Save button based on whether the number of applicants is valid
            if determineValidNumOfApplicants() {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
                .disabled(changedValues.isEmpty ? true : false)
                
            } else {
                    Text("Please specify the number of applicants to save.")
                        .foregroundColor(.blue)
            }
        }
        .onTapGesture(count: 2, perform: UIApplication.shared.endEditing)
        .navigationBarTitle("General")
        .onReceive(resignPub) { _ in
            handleSaving()
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        if salesConsultantIndex != 0 && applicationTypeIndex != 0 && applicantTypeIndex != 0 && loanPurposeIndex != 0 && propertyTypeIndex != 0 && determineValidNumOfApplicants() {
            return true
        }
        
        return false
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if !changedValues.isEmpty && determineValidNumOfApplicants() {
            isDone = determineComplete()
            saveApplication()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - determineValidNumOfApplicants
    private func determineValidNumOfApplicants() -> Bool {
        switch Int(self.numberOfApplicants) {
            case 1:
                return true
            case 2:
                if self.coApplicantOneName != "" {
                    return true
                }
            case 3:
                if self.coApplicantOneName != "" && self.coApplicantTwoName != "" {
                    return true
                }
            case 4:
                if self.coApplicantOneName != "" && self.coApplicantTwoName != "" && self.coApplicantThreeName != "" {
                    return true
                }
            default:
                return false
        }
        return false
    }
    
    // MARK: - saveApplication
    private func saveApplication() {
        UIApplication.shared.endEditing()
        applicationCreation.makeApplication()
        for (key, value) in changedValues {
            applicationCreation.application.setValue(value, forKey: key)
        }
        
        applicationCreation.application.loanID = UUID.init()
        applicationCreation.application.loanCreatedDate = Date()
        applicationCreation.application.loanStatus = Status.unsubmitted.rawValue
        
        do {
            try viewContext.save()
            print("print - New Application Saved")
            applicationCreation.generalDetailsSaved = true
            handleChangedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

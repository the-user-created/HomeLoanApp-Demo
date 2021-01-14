//
//  GeneralDetailsEditing.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/21.
//

import SwiftUI
import CoreData

struct GeneralDetailsEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let handleChangedValues = HandleChangedValues()
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
    
    @State var sender: ChoosePageVer
    @Binding var isDone: Bool
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: ChoosePageVer) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._salesConsultantIndex = State(wrappedValue: salesConsultants.firstIndex(of: self.application.salesConsultant ?? "--select--") ?? 0)
        self._applicationTypeIndex = State(wrappedValue: applicationType.firstIndex(of: self.application.applicationType ?? "--select--") ?? 0)
        self._applicantTypeIndex = State(wrappedValue: applicantType.firstIndex(of: self.application.applicantType ?? "--select--") ?? 0)
        self._loanPurposeIndex = State(wrappedValue: loanPurpose.firstIndex(of: self.application.loanPurpose ?? "--select--") ?? 0)
        self._propertyTypeIndex = State(wrappedValue: propertyType.firstIndex(of: self.application.propertyType ?? "--select--") ?? 0)
        self._numberOfApplicants = State(wrappedValue: String(self.application.numberOfApplicants))
        self._coApplicantOneName = State(wrappedValue: self.application.coApplicantOneName ?? "")
        self._coApplicantTwoName = State(wrappedValue: self.application.coApplicantTwoName ?? "")
        self._coApplicantThreeName = State(wrappedValue: self.application.coApplicantThreeName ?? "")
    }
    
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
                        case let x where Int(x) ?? 5 > 4:
                            Text("We currently only support in-app applications of up to 4 applicants. Please proceed to contact the Sales Consultant directly to get your application started.")
                                .multilineTextAlignment(.leading)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            
            // Shows/Hides the Next Page button based on where the number of applicants is valid
            if determineValidNumOfApplicants() {
                Section() {
                    Button(action: {
                        handleSaving()
                    }) {
                        Text("Save changes")
                            .foregroundColor(changedValues.isEmpty ? .gray : .blue)
                            .font(.headline)
                    }
                    .disabled(changedValues.isEmpty ? true : false)
                }
            } else {
                Section() {
                    Text("Please specify the number of applicants to save.")
                        .foregroundColor(.blue)
                }
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
            changedValues.updateValue(true, forKey: "generalDetailsDone")
            return true
        }
        
        return false
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if !changedValues.isEmpty && determineValidNumOfApplicants() {
            isDone = determineComplete()
            addToApplication()
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
    
    // MARK: - addToApplication
    private func addToApplication() {
        UIApplication.shared.endEditing()
        
        for (key, value) in changedValues {
            if sender == .creator {
                if key == "numberOfApplicants" {
                    applicationCreation.application.setValue(Int16(value as! String), forKey: key)
                } else {
                    applicationCreation.application.setValue(value, forKey: key)
                }
            } else {
                if key == "numberOfApplicants" {
                    application.setValue(Int16(value as! String), forKey: key)
                } else {
                    application.setValue(value, forKey: key)
                }
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

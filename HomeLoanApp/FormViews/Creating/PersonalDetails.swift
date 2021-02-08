//
//  PersonalDetails.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/11/01.
//

import SwiftUI
import CoreData
//import Firebase

struct PersonalDetails: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    // MARK: - State Variables
    @State var title = 0
    @State var surname = ""
    @State var firstNames = ""
    @State var gender = 0
    @State var dateOfBirth = Date()
    @State var identityType = 0
    @State var identityNumber = ""
    @State var passExpiryDate = Date()
    @State var taxNumber = ""
    @State var taxReturn = ""
    @State var educationLevel = 0
    @State var ethnicGroup = 0
    @State var singleHouse = ""
    @State var currentResStatus = 0
    @State var maritalStatus = 0
    @State var countryMarriage = 0
    @State var spouseIncome = ""
    @State var aNC = ""
    @State var numDependents = ""
    @State var mainResidence = ""
    @State var firstTimeHomeBuyer = ""
    @State var socialGrant = ""
    @State var publicOfficial = ""
    @State var relatedOfficial = ""
    
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var isActive: Bool = false
    @Binding var isDone: Bool
    @Binding var identityDoneBinding: Bool?
    
    // MARK: - Properties
    let resignPub: NotificationCenter.Publisher = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    let titles = ["--select--", "Dr", "Me", "Mej", "Mev", "Miss", "Mnr", "Mr", "Mrs", "Ms", "Prof"]
    let identityTypes = ["--select--", "ID Book", "Passport", "Recognised Refugee in SA (Section 24)", "SA Refugee Identity (Maroon ID)", "Smart ID Card"]
    let genderSelection = ["--select--", "Male", "Female"]
    let educationLevels = ["--select--", "Cretificate 24 Months", "Degree", "Diploma 1 Years", "Diploma 2 Years", "Diploma 3 Years", "Doctorate", "Honours", "Masters", "Matric", "No Matric", "Post Graduate Diploma"]
    let ethnicGroups = ["--select--", "Asian", "Black", "Coloured", "White"]
    let maritalStatuses = ["--select--", "Divorced", "Married Antenuptial Contract", "Married in Community of Property", "Other (Including Common Law)", "Single"]
    let currentResStatuses = ["--select--", "Other", "Owner", "Tenant"]
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("PERSONAL DETAILS")) {
                Group() {
                    FormPicker(iD: "title",
                               question: formQuestions[1][0] ?? "MISSING",
                               selectionOptions: titles,
                               selection: $title)
                    
                    FormTextField(iD: "surname",
                                  question: formQuestions[1][1] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[1][1] ?? "MISSING",
                                  text: $surname, sender: .editor)
                        .keyboardType(.alphabet)
                    
                    FormTextField(iD: "firstNames",
                                  question: formQuestions[1][2] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[1][2] ?? "MISSING",
                                  text: $firstNames, sender: .editor)
                        .keyboardType(.alphabet)
                    
                    FormPicker(iD: "gender",
                               question: formQuestions[1][3] ?? "MISSING",
                               selectionOptions: genderSelection,
                               selection: $gender)
                    
                    FormDatePicker(iD: "dateOfBirth",
                                   question: formQuestions[1][4] ?? "MISSING",
                                   dateRangeOption: 0,
                                   dateSelection: $dateOfBirth)
                    
                    FormPicker(iD: "identityType",
                               question: formQuestions[1][5] ?? "MISSING",
                               selectionOptions: identityTypes,
                               selection: $identityType)
                }
                
                FormTextField(iD: "identityNumber",
                              question: formQuestions[1][identityText(location: 6)] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[1][identityText(location: 6)] ?? "MISSING",
                              text: $identityNumber, sender: .editor)
                    .keyboardType(identityType == 1 || identityType == 5 ? .numberPad : .default)
                
                if identityType == 2 {
                    FormDatePicker(iD: "passExpiryDate",
                                   question: formQuestions[1][10] ?? "MISSING",
                                   dateRangeOption: 1,
                                   dateSelection: $passExpiryDate)
                }
                
            }
            
            Section() {
                FormTextField(iD: "taxNumber",
                              question: formQuestions[1][11] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[1][11] ?? "MISSING",
                              text: $taxNumber, sender: .editor)
                    .keyboardType(.numberPad)
                
                FormYesNo(iD: "taxReturn",
                          question: formQuestions[1][12] ?? "MISSING",
                          selected: $taxReturn)
                
                FormPicker(iD: "educationLevel",
                           question: formQuestions[1][13] ?? "MISSING",
                           selectionOptions: educationLevels,
                           selection: $educationLevel)
                
                FormPicker(iD: "ethnicGroup",
                           question: formQuestions[1][14] ?? "MISSING",
                           selectionOptions: ethnicGroups,
                           selection: $ethnicGroup)
                
                FormYesNo(iD: "singleHouse",
                          question: formQuestions[1][15] ?? "MISSING",
                          selected: $singleHouse)
                
                FormPicker(iD: "currentResStatus",
                           question: formQuestions[1][16] ?? "MISSING",
                           selectionOptions: currentResStatuses,
                           selection: $currentResStatus)
                
                FormPicker(iD: "maritalStatus",
                           question: formQuestions[1][17] ?? "MISSING",
                           selectionOptions: maritalStatuses,
                           selection: $maritalStatus)
                
            }
            
            if maritalStatus == 2 || maritalStatus == 3 || maritalStatus == 4 {
                Section(header: Text("MARRIAGE INFO")) {
                    FormPicker(iD: "countryMarriage",
                               question: formQuestions[1][18] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $countryMarriage)
                    
                    FormYesNo(iD: "spouseIncome",
                               question: formQuestions[1][19] ?? "MISSING",
                               selected: $spouseIncome)
                    
                    FormYesNo(iD: "aNC",
                              question: formQuestions[1][20] ?? "MISSING",
                              selected: $aNC)
                    
                    FormTextField(iD: "numDependents",
                                  question: formQuestions[1][21] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[1][21] ?? "MISSING",
                                  text: $numDependents, sender: .editor)
                        .keyboardType(.numberPad)
                    
                }
            }
            
            Section(header: Text("PERSONAL DETAILS")) {
                FormYesNo(iD: "mainResidence",
                          question: formQuestions[1][22] ?? "MISSING",
                          selected: $mainResidence)
                
                FormYesNo(iD: "firstTimeHomeBuyer",
                          question: formQuestions[1][23] ?? "MISSING",
                          selected: $firstTimeHomeBuyer)
                
                FormYesNo(iD: "socialGrant",
                          question: formQuestions[1][24] ?? "MISSING",
                          selected: $socialGrant)
                
                FormYesNo(iD: "publicOfficial",
                          question: formQuestions[1][25] ?? "MISSING",
                          selected: $publicOfficial)
                
                FormYesNo(iD: "relatedOfficial",
                          question: formQuestions[1][26] ?? "MISSING",
                          selected: $relatedOfficial)
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
        .navigationBarTitle("Personal Details")
        .onReceive(resignPub) { _ in
            if isActive {
                handleSaving()
            }
        }
        .onChange(of: maritalStatus) { value in
            if value != 2 {
                self.countryMarriage = 0
                self.spouseIncome = ""
                self.aNC = ""
                self.numDependents = ""
                changedValues.changedValues.merge(dict: ["countryMarriage": countries[0], "spouseIncome": "", "aNC": "", "numDependents": ""])
            }
        }
        .onChange(of: identityType) { value in
            if identityType != 2 {
                self.passExpiryDate = Date()
                changedValues.updateKeyValue("passExpiryDate", value: Date())
            }
        }
        .onDisappear() {
            isActive = false
        }
        .onAppear() {
            isActive = true
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        // Base checks
        if title != 0 && !surname.isEmpty && !firstNames.isEmpty && gender != 0 && identityType != 0 && !identityNumber.isEmpty && !taxNumber.isEmpty && !taxReturn.isEmpty && educationLevel != 0 && ethnicGroup != 0 && !singleHouse.isEmpty && maritalStatus != 0 && !mainResidence.isEmpty && !firstTimeHomeBuyer.isEmpty && !socialGrant.isEmpty && !publicOfficial.isEmpty && !relatedOfficial.isEmpty && dateOfBirth != Date() {
            
            // Marriage info check
            if [2, 3, 4].contains(maritalStatus) {
                if countryMarriage != 0 && !spouseIncome.isEmpty && !aNC.isEmpty && !numDependents.isEmpty {
                    isComplete = true
                }
            } else {
                isComplete = true
            }
            
            if identityType == 2 && passExpiryDate == Date() {
                isComplete = false
            }
        }
        
        changedValues.changedValues.updateValue(isComplete, forKey: "personalDetailsDone")
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
            if key == "identityType" {
                let value = value as? String
                identityDoneBinding = value != "--select--" && value != ""
            }
        }
        
        do {
            try viewContext.save()
            print("print - Application Entity Updated")
            applicationCreation.personalDetailsSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - identityText
    private func identityText(location: Int) -> Int {
        var location = location
        
        if identityType == 1 || identityType == 5 {
            location += 1
            return location
        } else if identityType == 2 {
            location += 2
            return location
        } else if identityType == 3 || identityType == 4 {
            location += 3
            return location
        } else {
            return location
        }
    }
}

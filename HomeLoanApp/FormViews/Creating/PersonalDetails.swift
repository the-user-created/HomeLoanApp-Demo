//
//  PersonalDetails.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/11/01.
//

import SwiftUI
import CoreData
import Firebase

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
    @State var iDType = 0
    @State var iDPassNumber = ""
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
    let scanButtonInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    
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
                    
                    FormPicker(iD: "iDType",
                               question: formQuestions[1][5] ?? "MISSING",
                               selectionOptions: identityTypes,
                               selection: $iDType)
                }
                
                FormTextField(iD: "iDPassNumber",
                              question: formQuestions[1][switchIDPassport(value: identityTypes[iDType], loc: 6)] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[1][6] ?? "MISSING",
                              text: $iDPassNumber, sender: .editor)
                    .keyboardType(identityTypes[iDType].contains("ID") ? .numberPad : .default)
                
                if iDType == 2 {
                    FormDatePicker(iD: "passExpiryDate",
                                   question: formQuestions[1][7] ?? "MISSING",
                                   dateRangeOption: 1,
                                   dateSelection: $passExpiryDate)
                }
                
            }
            
            Section() {
                FormTextField(iD: "taxNumber",
                              question: formQuestions[1][8] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[1][8] ?? "MISSING",
                              text: $taxNumber, sender: .editor)
                    .keyboardType(.numberPad)
                
                FormYesNo(iD: "taxReturn",
                          question: formQuestions[1][9] ?? "MISSING",
                          selected: $taxReturn)
                
                FormPicker(iD: "educationLevel",
                           question: formQuestions[1][10] ?? "MISSING",
                           selectionOptions: educationLevels,
                           selection: $educationLevel)
                
                FormPicker(iD: "ethnicGroup",
                           question: formQuestions[1][11] ?? "MISSING",
                           selectionOptions: ethnicGroups,
                           selection: $ethnicGroup)
                
                FormYesNo(iD: "singleHouse",
                          question: formQuestions[1][12] ?? "MISSING",
                          selected: $singleHouse)
                
                FormPicker(iD: "currentResStatus",
                           question: formQuestions[1][13] ?? "MISSING",
                           selectionOptions: currentResStatuses,
                           selection: $currentResStatus)
                
                FormPicker(iD: "maritalStatus",
                           question: formQuestions[1][14] ?? "MISSING",
                           selectionOptions: maritalStatuses,
                           selection: $maritalStatus)
                
            }
            
            if maritalStatuses[maritalStatus] == "Married" {
                Section(header: Text("MARRIAGE INFO")) {
                    FormPicker(iD: "countryMarriage",
                               question: formQuestions[1][14.1] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $countryMarriage)
                    
                    FormYesNo(iD: "spouseIncome",
                               question: formQuestions[1][14.2] ?? "MISSING",
                               selected: $spouseIncome)
                    
                    FormYesNo(iD: "aNC",
                              question: formQuestions[1][14.3] ?? "MISSING",
                              selected: $aNC)
                    
                    FormTextField(iD: "numDependents",
                                  question: formQuestions[1][14.4] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[1][14.4] ?? "MISSING",
                                  text: $numDependents, sender: .editor)
                        .keyboardType(.numberPad)
                    
                }
            }
            
            Section(header: Text("PERSONAL DETAILS")) {
                FormYesNo(iD: "mainResidence",
                          question: formQuestions[1][15] ?? "MISSING",
                          selected: $mainResidence)
                
                FormYesNo(iD: "firstTimeHomeBuyer",
                          question: formQuestions[1][16] ?? "MISSING",
                          selected: $firstTimeHomeBuyer)
                
                FormYesNo(iD: "socialGrant",
                          question: formQuestions[1][17] ?? "MISSING",
                          selected: $socialGrant)
                
                FormYesNo(iD: "publicOfficial",
                          question: formQuestions[1][18] ?? "MISSING",
                          selected: $publicOfficial)
                
                FormYesNo(iD: "relatedOfficial",
                          question: formQuestions[1][19] ?? "MISSING",
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
        .onTapGesture(count: 2, perform: UIApplication.shared.endEditing)
        .navigationBarTitle("Personal Details")
        .onReceive(resignPub) { _ in
            if isActive {
                handleSaving()
            }
        }
        .onChange(of: maritalStatus) { value in
            if maritalStatus != 2 {
                self.countryMarriage = 0
                self.spouseIncome = ""
                self.aNC = ""
                self.numDependents = ""
                changedValues.changedValues.merge(dict: ["countryMarriage": countries[0], "spouseIncome": "", "aNC": "", "numDependents": ""])
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
        if title != 0 && !surname.isEmpty && !firstNames.isEmpty && gender != 0 && iDType != 0 && !iDPassNumber.isEmpty && !taxNumber.isEmpty && !taxReturn.isEmpty && educationLevel != 0 && ethnicGroup != 0 && !singleHouse.isEmpty && maritalStatus != 0 && !mainResidence.isEmpty && !firstTimeHomeBuyer.isEmpty && !socialGrant.isEmpty && !publicOfficial.isEmpty && !relatedOfficial.isEmpty {
            
            // Marriage info check
            if maritalStatus == 2 {
                if countryMarriage != 0 && !spouseIncome.isEmpty && !aNC.isEmpty && !numDependents.isEmpty {
                    isComplete = true
                }
            } else {
                isComplete = true
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
            if key == "iDType" {
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
    
    private func deleteScans(initIDType: AnyHashable?) {
        let loanID: String = applicationCreation.application.loanID?.uuidString ?? ""
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let idType = initIDType?.description
        
        if idType == "3" && !loanID.isEmpty { // Deletes the scans for Smart ID Card scans
            for scanNumber in 0..<2 {
                let fileName = "passport_id_image_\(loanID)_\(scanNumber).png"
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                
                // Checks if file exists, removes it if so.
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileURL.path)
                        print("print - Removed old image")
                    } catch let removeError {
                        print("print - Couldn't remove file at path", removeError)
                    }

                }
            }
            
            applicationCreation.application.idPassScanned = false
        } else if (idType == "1" || idType == "2") && !loanID.isEmpty { // Deletes the scans for Passport or ID Book scans
            let fileName = "passport_id_image_\(loanID)_0.png"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            // Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("print - Removed old image")
                } catch let removeError {
                    print("print - Couldn't remove file at path", removeError)
                }

            }
            
            applicationCreation.application.idPassScanned = false
        }
    }
    
    // MARK: - switchIDPassport
    private func switchIDPassport(value: String, loc: Double)  -> Double {
        var location: Double = loc
        
        if value.lowercased().contains("id") {
            location += 0.1
            return location
        } else if value == "Passport" {
            location += 0.2
            return location
        } else {
            return location
        }
    }
}

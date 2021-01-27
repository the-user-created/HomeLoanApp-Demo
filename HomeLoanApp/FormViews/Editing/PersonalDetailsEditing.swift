//
//  PersonalDetailsEditing.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/21.
//

import SwiftUI
import CoreData

struct PersonalDetailsEditing: View {
    // MARK: - Property Wrapper variables
    @Environment(\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    @ObservedObject var application: Application
    
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
    @State var taxReturn1 = 0
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
    
    @State var initValues: Dictionary<String, AnyHashable> = [:]
    @State var savingValues: Dictionary<String, AnyHashable> = [:]
    @State var sender: Sender
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @Binding var isDone: Bool
    @Binding var identityDoneBinding: Bool?
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let scanButtonInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    
    let titles = ["--select--", "Dr", "Me", "Mej", "Mev", "Miss", "Mnr", "Mr", "Mrs", "Ms", "Prof"]
    let identityTypes = ["--select--", "ID Book", "Passport", "Recognised Refugee in SA (Section 24)", "SA Refugee Identity (Maroon ID)", "Smart ID Card"]
    let genderSelection = ["--select--", "Male", "Female"]
    let educationLevels = ["--select--", "Cretificate 24 Months", "Degree", "Diploma 1 Years", "Diploma 2 Years", "Diploma 3 Years", "Doctorate", "Honours", "Masters", "Matric", "No Matric", "Post Graduate Diploma"]
    let ethnicGroups = ["--select--", "Asian", "Black", "Coloured", "White"]
    let maritalStatuses = ["--select--", "Divorced", "Married Antenuptial Contract", "Married in Community of Property", "Other (Including Common Law)", "Single"]
    let currentResStatuses = ["--select--", "Other", "Owner", "Tenant"]
    
    // MARK: - init
    init(isDone: Binding<Bool>, identityDoneBinding: Binding<Bool?>, application: Application, sender: Sender) {
        self._isDone = isDone
        self._identityDoneBinding = identityDoneBinding
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._title = State(wrappedValue: titles.firstIndex(of: self.application.title ?? "--select--") ?? 0)
        self._surname = State(wrappedValue: self.application.surname ?? "")
        self._firstNames = State(wrappedValue: self.application.firstNames ?? "")
        self._gender = State(wrappedValue: genderSelection.firstIndex(of: self.application.gender ?? "--select--") ?? 0)
        self._dateOfBirth = State(wrappedValue: self.application.dateOfBirth ?? Date())
        self._identityType = State(wrappedValue: identityTypes.firstIndex(of: self.application.identityType ?? "--select--") ?? 0)
        self._identityNumber = State(wrappedValue: self.application.identityNumber ?? "")
        self._passExpiryDate = State(wrappedValue: self.application.passExpiryDate ?? Date())
        self._taxNumber = State(wrappedValue: self.application.taxNumber ?? "")
        self._taxReturn = State(wrappedValue: self.application.taxReturn ?? "")
        self._educationLevel = State(wrappedValue: educationLevels.firstIndex(of: self.application.educationLevel ?? "--select--") ?? 0)
        self._ethnicGroup = State(wrappedValue: ethnicGroups.firstIndex(of: self.application.ethnicGroup ?? "--select--") ?? 0)
        self._singleHouse = State(wrappedValue: self.application.singleHouse ?? "")
        self._currentResStatus = State(wrappedValue: currentResStatuses.firstIndex(of: self.application.currentResStatus ?? "--select--") ?? 0)
        self._maritalStatus = State(wrappedValue: maritalStatuses.firstIndex(of: self.application.maritalStatus ?? "--select--") ?? 0)
        self._countryMarriage = State(wrappedValue: countries.firstIndex(of: self.application.countryMarriage ?? "--select--") ?? 0)
        self._spouseIncome = State(wrappedValue: self.application.spouseIncome ?? "")
        self._aNC = State(wrappedValue: self.application.aNC ?? "")
        self._numDependents = State(wrappedValue: self.application.numDependents ?? "")
        self._mainResidence = State(wrappedValue: self.application.mainResidence ?? "")
        self._firstTimeHomeBuyer = State(wrappedValue: self.application.firstTimeHomeBuyer ?? "")
        self._socialGrant = State(wrappedValue: self.application.socialGrant ?? "")
        self._publicOfficial = State(wrappedValue: self.application.publicOfficial ?? "")
        self._relatedOfficial = State(wrappedValue: self.application.relatedOfficial ?? "")
        
        self._initValues = State(wrappedValue: ["title": self.title, "surname": self.surname, "firstNames": self.firstNames, "gender": self.gender, "dateOfBirth": self.dateOfBirth, "identityType": self.identityType, "identityNumber": self.identityNumber, "passExpiryDate": self.passExpiryDate, "taxNumber": self.taxNumber, "taxReturn": self.taxReturn, "educationLevel": self.educationLevel, "ethnicGroup": self.ethnicGroup, "singleHouse": self.singleHouse, "maritalStatus": self.maritalStatus, "countryMarriage": self.countryMarriage, "spouseIncome": self.spouseIncome, "aNC": self.aNC, "numDependents": self.numDependents, "mainResidence": self.mainResidence, "firstTimeHomeBuyer": self.firstTimeHomeBuyer, "socialGrant": self.socialGrant, "publicOfficial": self.publicOfficial, "relatedOfficial": self.relatedOfficial])
    }
    
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
                    Text("Save changes")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Personal Details")
        .onTapGesture(count: 2) {
            UIApplication.shared.endEditing()
        }
        .onReceive(resignPub) { _ in
            handleSaving()
        }
        .onChange(of: maritalStatus) { value in
            if maritalStatus != 2 && maritalStatus != 3 {
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
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        // Base checks
        if title != 0 && !surname.isEmpty && !firstNames.isEmpty && gender != 0 && identityType != 0 && !identityNumber.isEmpty && !taxNumber.isEmpty && !taxReturn.isEmpty && educationLevel != 0 && ethnicGroup != 0 && !singleHouse.isEmpty && maritalStatus != 0 && !mainResidence.isEmpty && !firstTimeHomeBuyer.isEmpty && !socialGrant.isEmpty && !publicOfficial.isEmpty && !relatedOfficial.isEmpty {
            
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
        if hasChanged() {
            isDone = determineComplete()
            addToApplication()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - hasChanged
    private func hasChanged() -> Bool {
        self.savingValues = ["title": self.title, "surname": self.surname, "firstNames": self.firstNames, "gender": self.gender, "dateOfBirth": self.dateOfBirth, "identityType": self.identityType, "identityNumber": self.identityNumber, "passExpiryDate": self.passExpiryDate, "taxNumber": self.taxNumber, "taxReturn": self.taxReturn, "educationLevel": self.educationLevel, "ethnicGroup": self.ethnicGroup, "singleHouse": self.singleHouse, "maritalStatus": self.maritalStatus, "countryMarriage": self.countryMarriage, "spouseIncome": self.spouseIncome, "aNC": self.aNC, "numDependents": self.numDependents, "mainResidence": self.mainResidence, "firstTimeHomeBuyer": self.firstTimeHomeBuyer, "socialGrant": self.socialGrant, "publicOfficial": self.publicOfficial, "relatedOfficial": self.relatedOfficial]
        
        if savingValues != initValues {
            let initidentityType = initValues["identityType"]
            if initidentityType != savingValues["identityType"] {
                deleteScans(initIdentityType: initidentityType)
            }
            
            return true
        }
        
        alertMessage = "No answers were changed."
        showingAlert = true
        return false
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
            
            if key == "identityType" {
                let value = value as? String
                identityDoneBinding = value != "--select--" && value != ""
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
    
    // MARK: - deleteScans
    private func deleteScans(initIdentityType: AnyHashable?) {
        let loanID: String = self.application.loanID?.uuidString ?? ""
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let identityType: String? = initIdentityType?.description
        print("print - identityType: \(String(describing: identityType))")
        if identityType == "5" && !loanID.isEmpty { // Deletes the scans for Smart ID Card scans
            for scanNumber in 0..<2 {
                let fileName = "identity_scan_\(loanID)_\(scanNumber).png"
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
            
            self.application.identityScanned = false
        } else if (identityType == "1" || identityType == "2" || identityType == "3" || identityType == "4") && !loanID.isEmpty { // Deletes the scans for Passport or ID Book scans
            let fileName = "identity_scan_\(loanID)_0.png"
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
            
            self.application.identityScanned = false
        }
    }
    
    // MARK: - identityText
    private func identityText(location: Double) -> Double {
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

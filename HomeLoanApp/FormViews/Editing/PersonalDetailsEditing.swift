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
    @ObservedObject var application: Application
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let scanButtonInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    let handleChangedValues = HandleChangedValues()
    
    let titles = ["--select--","Mr", "Mrs", "Ms", "Dr", "Prof", "--TBA--"]
    let identityType = ["--select--","Passport", "ID Book", "SmartCard ID", "--TBA--"]
    let genderSelection = ["--select--", "Male", "Female"]
    let educationLevels = ["--select--", "Matric", "Bachelor degree", "Masters degree", "Doctorate", "Diploma", "--TBA--"]
    let ethnicGroups = ["--select--", "Asian", "Black", "Caucasian", "Coloured", "Indian", "--TBA--"]
    let maritalStatuses = ["--select--", "Divorced", "Married", "Single", "--TBA--"]
    
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
    @State var taxReturn1 = 0
    @State var educationLevel = 0
    @State var ethnicGroup = 0
    @State var singleHouse = ""
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
    
    @State var isShowingScannerSheet: Bool = false
    @State var isShowingScannerHelp: Bool = false
    
    @State var sender: ChoosePageVer
    @Binding var isDone: Bool
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: ChoosePageVer) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._title = State(wrappedValue: titles.firstIndex(of: self.application.title ?? "--select--") ?? 0)
        self._surname = State(wrappedValue: self.application.surname ?? "")
        self._firstNames = State(wrappedValue: self.application.firstNames ?? "")
        self._gender = State(wrappedValue: genderSelection.firstIndex(of: self.application.gender ?? "--select--") ?? 0)
        self._dateOfBirth = State(wrappedValue: self.application.dateOfBirth ?? Date())
        self._iDType = State(wrappedValue: identityType.firstIndex(of: self.application.iDType ?? "--select--") ?? 0)
        self._iDPassNumber = State(wrappedValue: self.application.iDPassNumber ?? "")
        
        self._passExpiryDate = State(wrappedValue: self.application.passExpiryDate ?? Date())
        
        self._taxNumber = State(wrappedValue: self.application.taxNumber ?? "")
        self._taxReturn = State(wrappedValue: self.application.taxReturn ?? "")
        
        self._educationLevel = State(wrappedValue: educationLevels.firstIndex(of: self.application.educationLevel ?? "--select--") ?? 0)
        self._ethnicGroup = State(wrappedValue: ethnicGroups.firstIndex(of: self.application.ethnicGroup ?? "--select--") ?? 0)
        
        self._singleHouse = State(wrappedValue: self.application.singleHouse ?? "")
        
        self._maritalStatus = State(wrappedValue: maritalStatuses.firstIndex(of: self.application.maritalStatus ?? "--select--") ?? 0)
        self._countryMarriage = State(wrappedValue: countries.firstIndex(of: self.application.countryMarriage ?? "--select--") ?? 0)
        
        self._spouseIncome = State(wrappedValue: self.application.spouseIncome ?? "")
        self._aNC = State(wrappedValue: self.application.aNC ?? "")
        self._numDependents = State(wrappedValue: String(self.application.numDependents))
        self._mainResidence = State(wrappedValue: self.application.mainResidence ?? "")
        self._firstTimeHomeBuyer = State(wrappedValue: self.application.firstTimeHomeBuyer ?? "")
        self._socialGrant = State(wrappedValue: self.application.socialGrant ?? "")
        self._publicOfficial = State(wrappedValue: self.application.publicOfficial ?? "")
        self._relatedOfficial = State(wrappedValue: self.application.relatedOfficial ?? "")
    }
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("PERSONAL DETAILS")) {
                FormPicker(iD: "title", pageNum: 1,
                           question: formQuestions[1][0] ?? "MISSING",
                           selectionOptions: titles,
                           selection: $title)
                
                FormTextField(iD: "surname", pageNum: 1,
                              question: formQuestions[1][1] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[1][1] ?? "MISSING",
                              text: $surname).keyboardType(.alphabet)
                
                FormTextField(iD: "firstNames", pageNum: 1,
                              question: formQuestions[1][2] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[1][2] ?? "MISSING",
                              text: $firstNames).keyboardType(.alphabet)
                
                FormPicker(iD: "gender", pageNum: 1,
                           question: formQuestions[1][3] ?? "MISSING",
                           selectionOptions: genderSelection,
                           selection: $gender)
                
                FormDatePicker(iD: "dateOfBirth", pageNum: 1,
                               question: formQuestions[1][4] ?? "MISSING",
                               dateRangeOption: 0,
                               dateSelection: $dateOfBirth)
                
                FormPicker(iD: "iDType", pageNum: 1,
                           question: formQuestions[1][5] ?? "MISSING",
                           selectionOptions: identityType,
                           selection: $iDType)
                
                HStack() {
                    Button(scanString()) {
                        self.isShowingScannerSheet = true
                    }
                    
                    Spacer()
                    
                    Button(action: { self.isShowingScannerHelp = true }) {
                        Image(systemName: "info.circle")
                    }
                    
                }
                .foregroundColor(.blue)
                .buttonStyle(BorderlessButtonStyle())
                
                FormTextField(iD: "iDPassNumber", pageNum: 1,
                              question: formQuestions[1][switchIDPassport(value: identityType[iDType], loc: 6)] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[1][6] ?? "MISSING",
                              text: $iDPassNumber)
                    .keyboardType(identityType[iDType].contains("ID") ? .numberPad : .default)
                
                if !identityType[iDType].lowercased().contains("id") {
                    FormDatePicker(iD: "passExpiryDate", pageNum: 1,
                                   question: formQuestions[1][7] ?? "MISSING",
                                   dateRangeOption: 1,
                                   dateSelection: $passExpiryDate)
                }
                
            }
            
            Section() {
                FormTextField(iD: "taxNumber", pageNum: 1,
                              question: formQuestions[1][8] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[1][8] ?? "MISSING",
                              text: $taxNumber)
                    .keyboardType(.numberPad)
                
                FormYesNo(iD: "taxReturn", pageNum: 1,
                          question: formQuestions[1][9] ?? "MISSING",
                          selected: $taxReturn)
                
                FormPicker(iD: "educationLevel", pageNum: 1,
                           question: formQuestions[1][10] ?? "MISSING",
                           selectionOptions: educationLevels,
                           selection: $educationLevel)
                
                FormPicker(iD: "ethnicGroup", pageNum: 1,
                           question: formQuestions[1][11] ?? "MISSING",
                           selectionOptions: ethnicGroups,
                           selection: $ethnicGroup)
                
                FormYesNo(iD: "singleHouse", pageNum: 1,
                          question: formQuestions[1][12] ?? "MISSING",
                          selected: $singleHouse)
                
                FormPicker(iD: "maritalStatus", pageNum: 1,
                           question: formQuestions[1][13] ?? "MISSING",
                           selectionOptions: maritalStatuses,
                           selection: $maritalStatus)
                
            }
            
            if maritalStatuses[maritalStatus] == "Married" {
                Section(header: Text("MARRIAGE INFO")) {
                    FormPicker(iD: "countryMarriage", pageNum: 1,
                               question: formQuestions[1][13.1] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $countryMarriage)
                    
                    FormYesNo(iD: "spouseIncome", pageNum: 1,
                               question: formQuestions[1][13.2] ?? "MISSING",
                               selected: $spouseIncome)
                    
                    FormYesNo(iD: "aNC", pageNum: 1,
                              question: formQuestions[1][13.3] ?? "MISSING",
                              selected: $aNC)
                    
                    FormTextField(iD: "numDependents", pageNum: 1,
                                  question: formQuestions[1][13.4] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[1][13.4] ?? "MISSING",
                                  text: $numDependents)
                        .keyboardType(.numberPad)
                    
                }
            }
            
            Section(header: Text("PERSONAL DETAILS")) {
                FormYesNo(iD: "mainResidence", pageNum: 1,
                          question: formQuestions[1][14] ?? "MISSING",
                          selected: $mainResidence)
                
                FormYesNo(iD: "firstTimeHomeBuyer", pageNum: 1,
                          question: formQuestions[1][15] ?? "MISSING",
                          selected: $firstTimeHomeBuyer)
                
                FormYesNo(iD: "socialGrant", pageNum: 1,
                          question: formQuestions[1][16] ?? "MISSING",
                          selected: $socialGrant)
                
                FormYesNo(iD: "publicOfficial", pageNum: 1,
                          question: formQuestions[1][17] ?? "MISSING",
                          selected: $publicOfficial)
                
                FormYesNo(iD: "relatedOfficial", pageNum: 1,
                          question: formQuestions[1][18] ?? "MISSING",
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
                .disabled(changedValues.isEmpty ? true : false)
            }
        }
        .navigationBarTitle("Personal Details")
        .sheet(isPresented: self.$isShowingScannerSheet) {
            ScannerView(completion: {
                _ in self.isShowingScannerSheet = false
            }, scanName: "passport_id")
        }
        .sheet(isPresented: self.$isShowingScannerHelp) {
            Text("Steps on taking a good scan")
        }
        .onTapGesture(count: 2) {
            UIApplication.shared.endEditing()
        }
        .onReceive(resignPub) { _ in
            handleSaving()
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        /*if {
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
    
    // MARK: - addToApplication()
    private func addToApplication() {
        UIApplication.shared.endEditing()
        
        for (key, value) in changedValues {
            if sender == .creator {
                if key == "numDependents" {
                    applicationCreation.application.setValue(Int16(value as! String), forKey: key)
                } else {
                    applicationCreation.application.setValue(value, forKey: key)
                }
            } else {
                if key == "numDependents" {
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
    
    // MARK: - scanString()
    private func scanString() -> String {
        var outString: String = "Scan your "
        if iDType != 0 {
            outString += identityType[iDType].contains("ID") ? "ID" : "Passport"
        } else {
            outString += "passport/ID"
        }
        
        return outString
    }
    
    // MARK: - switchIDPassport()
    private func switchIDPassport(value: String, loc: Double)  -> Double {
        var location: Double = loc
        
        if value.lowercased().contains("id") {
            location += 0.1
            return location
        } else if value.lowercased().contains("passport") {
            location += 0.2
            return location
        } else {
            return location
        }
    }
}

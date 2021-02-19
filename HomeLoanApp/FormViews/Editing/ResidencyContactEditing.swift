//
//  ResidencyContact.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/11/28.
//

import SwiftUI
import CoreData

struct ResidencyContactEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
    @EnvironmentObject var changedValues: ChangedValues
    
    // MARK: - State Variables
    @State var sACitizen = ""
    @State var nationality = 0
    @State var countryPassport = 0
    @State var countryBirth = 0
    @State var cityOfBirth = ""
    @State var permanentResident = ""
    @State var countryOfPermanentResidence = 0
    @State var homeLanguage = 0
    @State var correspondenceLanguage = 0
    @State var cellNumber = ""
    @State var emailAddress = ""
    @State var resCountry = 0
    @State var resLine1 = ""
    @State var resLine2 = ""
    @State var resSuburb = ""
    @State var resCity = ""
    @State var resProvince = ""
    @State var resStreetCode = ""
    @State var lengthAtAddressYears = ""
    @State var lengthAtAddressMonths = ""
    @State var resIsPostal = ""
    @State var postalCountry = 0
    @State var postalLine1 = ""
    @State var postalLine2 = ""
    @State var postalSuburb = ""
    @State var postalCity = ""
    @State var postalProvince = ""
    @State var postalStreetCode = ""
    
    @State var initValues: Dictionary<String, AnyHashable> = [:]
    @State var savingValues: Dictionary<String, AnyHashable> = [:]
    @State var sender: Sender
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: Sender) {
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self.application = application
        self._sACitizen = State(wrappedValue: self.application.sACitizen ?? "")
        self._nationality = State(wrappedValue: countries.firstIndex(of: self.application.nationality ?? "--select--") ?? 0)
        self._countryPassport = State(wrappedValue: countries.firstIndex(of: self.application.countryPassport ?? "--select--") ?? 0)
        self._countryBirth = State(wrappedValue: countries.firstIndex(of: self.application.countryBirth ?? "--select--") ?? 0)
        self._cityOfBirth = State(wrappedValue: self.application.cityOfBirth ?? "")
        self._permanentResident = State(wrappedValue: self.application.permanentResident ?? "")
        self._countryOfPermanentResidence = State(wrappedValue: countries.firstIndex(of: self.application.countryOfPermanentResidence ?? "--select--") ?? 0)
        self._homeLanguage = State(wrappedValue: languages.firstIndex(of: self.application.homeLanguage ?? "--select--") ?? 0)
        self._correspondenceLanguage = State(wrappedValue: correspondenceLanguages.firstIndex(of: self.application.correspondenceLanguage ?? "--select--") ?? 0)
        self._cellNumber = State(wrappedValue: self.application.cellNumber ?? "")
        self._emailAddress = State(wrappedValue: self.application.emailAddress ?? "")
        self._resCountry = State(wrappedValue: countries.firstIndex(of: self.application.resCountry ?? "--select--") ?? 0)
        self._resLine1 = State(wrappedValue: self.application.resLine1 ?? "")
        self._resLine2 = State(wrappedValue: self.application.resLine2 ?? "")
        self._resSuburb = State(wrappedValue: self.application.resSuburb ?? "")
        self._resCity = State(wrappedValue: self.application.resCity ?? "")
        self._resProvince = State(wrappedValue: self.application.resProvince ?? "")
        self._resStreetCode = State(wrappedValue: self.application.resStreetCode ?? "")
        self._resIsPostal = State(wrappedValue: self.application.resIsPostal ?? "")
        self._postalCountry = State(wrappedValue: countries.firstIndex(of: self.application.postalCountry ?? "--select--") ?? 0)
        self._postalLine1 = State(wrappedValue: self.application.postalLine1 ?? "")
        self._postalLine2 = State(wrappedValue: self.application.postalLine2 ?? "")
        self._postalSuburb = State(wrappedValue: self.application.postalSuburb ?? "")
        self._postalCity = State(wrappedValue: self.application.postalCity ?? "")
        self._postalProvince = State(wrappedValue: self.application.postalProvince ?? "")
        self._postalStreetCode = State(wrappedValue: self.application.postalStreetCode ?? "")
        
        if let lengthAtAddress = self.application.lengthAtAddress {
            let openBracketIndices = findNth("[", text: lengthAtAddress)
            let closeBracketIndices = findNth("]", text: lengthAtAddress)
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                self._lengthAtAddressYears = State(wrappedValue: String(lengthAtAddress[lengthAtAddress.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
                self._lengthAtAddressMonths = State(wrappedValue: String(lengthAtAddress[lengthAtAddress.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
            }
        }
        
        self._initValues = State(wrappedValue: ["sACitizen": sACitizen, "nationality": nationality, "countryPassport": countryPassport, "countryBirth": countryBirth, "cityOfBirth": cityOfBirth, "permanentResident": permanentResident, "countryOfPermanentResidence": countryOfPermanentResidence, "homeLanguage": homeLanguage, "correspondenceLanguage": correspondenceLanguage, "cellNumber": cellNumber, "emailAddress": emailAddress, "resCountry": resCountry, "resLine1": resLine1, "resLine2": resLine2, "resSuburb": resSuburb, "resCity": resCity, "resProvince": resProvince, "resStreetCode": resStreetCode, "lengthAtAddress": "[\(lengthAtAddressYears)][\(lengthAtAddressMonths)]", "resIsPostal": resIsPostal, "postalCountry": postalCountry, "postalLine1": postalLine1, "postalLine2": postalLine2, "postalSuburb": postalSuburb, "postalCity": postalCity, "postalProvince": postalProvince, "postalStreetCode": postalStreetCode])
    }
    
    // MARK: - body
    var body: some View {
        Form {
            Section(header: Text("RESIDENCY")) {
                FormYesNo(iD: "sACitizen",
                          question: formQuestions[2][0] ?? "MISSING",
                          selected: $sACitizen)
                
                if sACitizen == "No" {
                    FormPicker(iD: "nationality",
                               question: formQuestions[2][1] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $nationality)
                    
                    FormPicker(iD: "countryPassport",
                               question: formQuestions[2][2] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $countryPassport)
                }
                
                FormPicker(iD: "countryBirth",
                           question: formQuestions[2][3] ?? "MISSING",
                           selectionOptions: countries,
                           selection: $countryBirth)
                
                FormTextField(iD: "cityOfBirth",
                              question: formQuestions[2][4] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][4] ?? "MISSING",
                              text: $cityOfBirth, sender: .editor)
                
                if sACitizen == "No" {
                FormYesNo(iD: "permanentResident",
                          question: formQuestions[2][5] ?? "MISSING",
                          selected: $permanentResident)
                
                    if permanentResident == "No" {
                        FormPicker(iD: "countryOfPermanentResidence",
                                   question: formQuestions[2][6] ?? "MISSING",
                                   selectionOptions: countries,
                                   selection: $countryOfPermanentResidence)
                    }
                }
                
            }
            
            Section(header: Text("CONTACT")) {
                FormPicker(iD: "homeLanguage",
                           question: formQuestions[2][7] ?? "MISSING",
                           selectionOptions: languages,
                           selection: $homeLanguage)
                
                FormPicker(iD: "correspondenceLanguage",
                           question: formQuestions[2][8] ?? "MISSING",
                           selectionOptions: correspondenceLanguages,
                           selection: $correspondenceLanguage)
                
                FormTextField(iD: "cellNumber",
                              question: formQuestions[2][9] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][9] ?? "MISSING",
                              text: $cellNumber, sender: .editor)
                    .keyboardType(.phonePad)
                
                FormTextField(iD: "emailAddress",
                              question: formQuestions[2][10] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][10] ?? "MISSING",
                              text: $emailAddress, sender: .editor)
                    .keyboardType(.emailAddress)
                
            }
            
            Section(header: Text("RESIDENTIAL ADDRESS")) {
                FormPicker(iD: "resCountry",
                           question: formQuestions[2][11] ?? "MISSING",
                           selectionOptions: countries,
                           selection: $resCountry)
                
                FormTextField(iD: "resLine1",
                              question: formQuestions[2][12] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][12] ?? "MISSING",
                              text: $resLine1, sender: .editor)
                
                FormTextField(iD: "resLine2",
                              question: formQuestions[2][13] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][13] ?? "MISSING",
                              text: $resLine2, sender: .editor)
                
                FormTextField(iD: "resSuburb",
                              question: formQuestions[2][14] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][14] ?? "MISSING",
                              text: $resSuburb, sender: .editor)
                
                FormTextField(iD: "resCity",
                              question: formQuestions[2][15] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15] ?? "MISSING",
                              text: $resCity, sender: .editor)
                
                FormTextField(iD: "resProvince",
                              question: formQuestions[2][16] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][16] ?? "MISSING",
                              text: $resProvince, sender: .editor)
                
                FormTextField(iD: "resStreetCode",
                              question: formQuestions[2][17] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][17] ?? "MISSING",
                              text: $resStreetCode, sender: .editor)
                    //.keyboardType(.numberPad)
                
                FormLenAt(iD: "lengthAtAddress",
                          question: formQuestions[2][18] ?? "MISSING",
                          yearsText: $lengthAtAddressYears,
                          monthsText: $lengthAtAddressMonths)
                
            }
            
            Section(header: Text("POSTAL ADDRESS")) {
                FormYesNo(iD: "resIsPostal",
                          question: formQuestions[2][19] ?? "MISSING",
                          selected: $resIsPostal)
                
                if resIsPostal == "No" {
                    FormPicker(iD: "postalCountry",
                               question: formQuestions[2][11] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $postalCountry)
                    
                    FormTextField(iD: "postalLine1",
                                  question: formQuestions[2][12] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][12] ?? "MISSING",
                                  text: $postalLine1, sender: .editor)
                    
                    FormTextField(iD: "postalLine2",
                                  question: formQuestions[2][13] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][13] ?? "MISSING",
                                  text: $postalLine2, sender: .editor)
                    
                    FormTextField(iD: "postalSuburb",
                                  question: formQuestions[2][14] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][14] ?? "MISSING",
                                  text: $postalSuburb, sender: .editor)
                    
                    FormTextField(iD: "postalCity",
                                  question: formQuestions[2][15] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15] ?? "MISSING",
                                  text: $postalCity, sender: .editor)
                    
                    FormTextField(iD: "postalProvince",
                                  question: formQuestions[2][16] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][16] ?? "MISSING",
                                  text: $postalProvince, sender: .editor)
                    
                    FormTextField(iD: "postalStreetCode",
                                  question: formQuestions[2][17] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][17] ?? "MISSING",
                                  text: $postalStreetCode, sender: .editor)
                        //.keyboardType(.numberPad)
                }
            }
            
            Section {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save changes")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Residency & Contact")
        .onReceive(resignPub) { _ in
            handleSaving()
        }
        .onChange(of: sACitizen) { _ in
            if sACitizen != "No" {
                self.nationality = 0
                self.countryPassport = 0
                self.permanentResident = ""
                self.countryOfPermanentResidence = 0
                changedValues.changedValues.merge(dict: ["nationality": countries[0], "countryPassport": countries[0], "permanentResident": "", "countryOfPermanentResidence": countries[0]])
            }
        }
        .onChange(of: permanentResident) { _ in
            if permanentResident != "No" {
                self.countryOfPermanentResidence = 0
                changedValues.updateKeyValue("countryOfPermanentResidence", value: countries[0])
            }
        }
        .onChange(of: resIsPostal) { _ in
            if resIsPostal != "No" {
                self.postalCountry = 0
                self.postalLine1 = ""
                self.postalLine2 = ""
                self.postalSuburb = ""
                self.postalCity = ""
                self.postalProvince = ""
                self.postalStreetCode = ""
                changedValues.changedValues.merge(dict: ["postalCountry": countries[0], "postalLine1": "", "postalLine2": "", "postalSuburb": "", "postalCity": "", "postalProvince": "", "postalStreetCode": ""])
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        
        // Handle the non-optional questions
        if !sACitizen.isEmpty && countryBirth != 0 && !cityOfBirth.isEmpty && homeLanguage != 0 && correspondenceLanguage != 0 && !cellNumber.isEmpty && !emailAddress.isEmpty && resCountry != 0 && !resLine1.isEmpty && !resSuburb.isEmpty && !resCity.isEmpty && !resProvince.isEmpty && !resStreetCode.isEmpty && (!lengthAtAddressYears.isEmpty || !lengthAtAddressMonths.isEmpty) && !resIsPostal.isEmpty {
            
            if sACitizen == "No" && resIsPostal == "No" {
                if nationality != 0 && countryPassport != 0 && postalCountry != 0 && !postalLine1.isEmpty && !postalSuburb.isEmpty && !postalCity.isEmpty && !postalProvince.isEmpty && !postalStreetCode.isEmpty && ((permanentResident == "No" && countryOfPermanentResidence != 0) || permanentResident == "Yes") {
                    isComplete = true
                }
                // else isComplete = false
            } else if sACitizen == "No" && resIsPostal == "Yes" {
                if nationality != 0 && countryPassport != 0 && ((permanentResident == "No" && countryOfPermanentResidence != 0) || permanentResident == "Yes") {
                    isComplete = true
                }
                // else isComplete = false
            } else if sACitizen == "Yes" && resIsPostal == "No" {
                if postalCountry != 0 && !postalLine1.isEmpty && !postalSuburb.isEmpty && !postalCity.isEmpty && !postalProvince.isEmpty && !postalStreetCode.isEmpty {
                    isComplete = true
                }
                // else isComplete = false
            } else if sACitizen == "Yes" && resIsPostal == "Yes" {
                isComplete = true
            }
            // else isComplete = false
        }
        // else isComplete = false
        
        changedValues.changedValues.updateValue(isComplete, forKey: "residencyContactDone")
        return isComplete
    }
    
    // MARK: - hasChanged
    private func hasChanged() -> Bool {
        self.savingValues = ["sACitizen": sACitizen, "nationality": nationality, "countryPassport": countryPassport, "countryBirth": countryBirth, "cityOfBirth": cityOfBirth, "permanentResident": permanentResident, "countryOfPermanentResidence": countryOfPermanentResidence, "homeLanguage": homeLanguage, "correspondenceLanguage": correspondenceLanguage, "cellNumber": cellNumber, "emailAddress": emailAddress, "resCountry": resCountry, "resLine1": resLine1, "resLine2": resLine2, "resSuburb": resSuburb, "resCity": resCity, "resProvince": resProvince, "resStreetCode": resStreetCode, "lengthAtAddress": "[\(lengthAtAddressYears)][\(lengthAtAddressMonths)]", "resIsPostal": resIsPostal, "postalCountry": postalCountry, "postalLine1": postalLine1, "postalLine2": postalLine2, "postalSuburb": postalSuburb, "postalCity": postalCity, "postalProvince": postalProvince, "postalStreetCode": postalStreetCode]
        
        if savingValues != initValues {
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
    
    // MARK: - addToApplication()
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
            print("Application Entity Updated")
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

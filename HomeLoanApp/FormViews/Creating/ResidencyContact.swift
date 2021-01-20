//
//  ResidencyContact.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/11/28.
//

import SwiftUI
import CoreData

struct ResidencyContact: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    // MARK: - State Variables
    @State var sACitizen = ""
    @State var nationality = 0
    @State var countryPassport = 0
    @State var countryBirth = 0
    @State var cityOfBirth = ""
    @State var permanentResident = ""
    @State var countryOfPermanentResidence = 0
    @State var permitType = 0
    @State var countryOfPermit = 0
    @State var permitIssueDate = Date()
    @State var permitExpiryDate = Date()
    @State var contractIssueDate = Date()
    @State var contractExpiryDate = Date()
    @State var workPermitNumber = ""
    @State var homeLanguage = 0
    @State var corresLanguage = 0
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
    
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var isActive: Bool = false
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    let permitTypes = ["--select--", "Work permit", "--TBA--"]
    let languages = ["--select--", "English", "Afrikaans", "--TBA--"]
    let correslanguages = ["--select--", "English", "Afrikaans"]
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("RESIDENCY")) {
                FormYesNo(iD: "sACitizen",
                          question: formQuestions[2][0] ?? "MISSING",
                          selected: $sACitizen)
                
                if sACitizen == "No" {
                    FormPicker(iD: "nationality",
                               question: formQuestions[2][0.1] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $nationality)
                    
                    FormPicker(iD: "countryPassport",
                               question: formQuestions[2][0.2] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $countryPassport)
                }
                
                FormPicker(iD: "countryBirth",
                           question: formQuestions[2][1] ?? "MISSING",
                           selectionOptions: countries,
                           selection: $countryBirth)
                
                FormTextField(iD: "cityOfBirth",
                              question: formQuestions[2][2] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][2] ?? "MISSING",
                              text: $cityOfBirth)
                
                if sACitizen == "No" {
                    FormYesNo(iD: "permanentResident",
                              question: formQuestions[2][3] ?? "MISSING",
                              selected: $permanentResident)
                
                    if permanentResident == "No" {
                        FormPicker(iD: "countryOfPermanentResidence",
                                   question: formQuestions[2][3.1] ?? "MISSING",
                                   selectionOptions: countries,
                                   selection: $countryOfPermanentResidence)
                    }
                    
                    Group() {
                        FormPicker(iD: "permitType",
                                   question: formQuestions[2][4] ?? "MISSING",
                                   selectionOptions: permitTypes,
                                   selection: $permitType)
                        
                        FormPicker(iD: "countryOfPermit",
                                   question: formQuestions[2][5] ?? "MISSING",
                                   selectionOptions: countries,
                                   selection: $countryOfPermit)
                        
                        FormDatePicker(iD: "permitIssueDate",
                                       question: formQuestions[2][6] ?? "MISSING",
                                       dateRangeOption: 0,
                                       dateSelection: $permitIssueDate)
                        
                        FormDatePicker(iD: "permitExpiryDate",
                                       question: formQuestions[2][7] ?? "MISSING",
                                       dateRangeOption: 1,
                                       dateSelection: $permitExpiryDate)
                        
                        FormDatePicker(iD: "contractIssueDate",
                                       question: formQuestions[2][8] ?? "MISSING",
                                       dateRangeOption: 0,
                                       dateSelection: $contractIssueDate)
                        
                        FormDatePicker(iD: "contractExpiryDate",
                                       question: formQuestions[2][9] ?? "MISSING",
                                       dateRangeOption: 1,
                                       dateSelection: $contractExpiryDate)
                        
                        FormTextField(iD: "workPermitNumber",
                                      question: formQuestions[2][10] ?? "MISSING",
                                      placeholder: formTextFieldPlaceholders[2][10] ?? "MISSING",
                                      text: $workPermitNumber)
                        
                    }
                }
                
            }
            
            Section(header: Text("CONTACT")) {
                FormPicker(iD: "homeLanguage",
                           question: formQuestions[2][11] ?? "MISSING",
                           selectionOptions: languages,
                           selection: $homeLanguage)
                
                FormPicker(iD: "corresLanguage",
                           question: formQuestions[2][12] ?? "MISSING",
                           selectionOptions: correslanguages,
                           selection: $corresLanguage)
                
                FormTextField(iD: "cellNumber",
                              question: formQuestions[2][13] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][13] ?? "MISSING",
                              text: $cellNumber)
                    .keyboardType(.phonePad)
                
                FormTextField(iD: "emailAddress",
                              question: formQuestions[2][14] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][14] ?? "MISSING",
                              text: $emailAddress)
                    .keyboardType(.emailAddress)
                
            }
            
            Section(header: Text("RESIDENTIAL ADDRESS")) {
                FormPicker(iD: "resCountry",
                           question: formQuestions[2][15] ?? "MISSING",
                           selectionOptions: countries,
                           selection: $resCountry)
                
                FormTextField(iD: "resLine1",
                              question: formQuestions[2][15.1] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.1] ?? "MISSING",
                              text: $resLine1)
                
                FormTextField(iD: "resLine2",
                              question: formQuestions[2][15.2] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.2] ?? "MISSING",
                              text: $resLine2)
                
                FormTextField(iD: "resSuburb",
                              question: formQuestions[2][15.3] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.3] ?? "MISSING",
                              text: $resSuburb)
                
                FormTextField(iD: "resCity",
                              question: formQuestions[2][15.4] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.4] ?? "MISSING",
                              text: $resCity)
                
                FormTextField(iD: "resProvince",
                              question: formQuestions[2][15.5] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.5] ?? "MISSING",
                              text: $resProvince)
                
                FormTextField(iD: "resStreetCode",
                              question: formQuestions[2][15.6] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.6] ?? "MISSING",
                              text: $resStreetCode)
                    .keyboardType(.numberPad)
                
                FormLenAt(iD: "lengthAtAddress",
                          question: formQuestions[2][15.7] ?? "MISSING",
                          yearsText: $lengthAtAddressYears,
                          monthsText: $lengthAtAddressMonths)
                
            }
            
            Section(header: Text("POSTAL ADDRESS")) {
                FormYesNo(iD: "resIsPostal",
                          question: formQuestions[2][16] ?? "MISSING",
                          selected: $resIsPostal)
                
                if resIsPostal == "No" {
                    FormPicker(iD: "postalCountry",
                               question: formQuestions[2][15] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $postalCountry)
                    
                    FormTextField(iD: "postalLine1",
                                  question: formQuestions[2][15.1] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.1] ?? "MISSING",
                                  text: $postalLine1)
                    
                    FormTextField(iD: "postalLine2",
                                  question: formQuestions[2][15.2] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.2] ?? "MISSING",
                                  text: $postalLine2)
                    
                    FormTextField(iD: "postalSuburb",
                                  question: formQuestions[2][15.3] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.3] ?? "MISSING",
                                  text: $postalSuburb)
                    
                    FormTextField(iD: "postalCity",
                                  question: formQuestions[2][15.4] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.4] ?? "MISSING",
                                  text: $postalCity)
                    
                    FormTextField(iD: "postalProvince",
                                  question: formQuestions[2][15.5] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.5] ?? "MISSING",
                                  text: $postalProvince)
                    
                    FormTextField(iD: "postalStreetCode",
                                  question: formQuestions[2][15.6] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.6] ?? "MISSING",
                                  text: $postalStreetCode)
                        .keyboardType(.numberPad)
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
        .navigationBarTitle("Residency & Contact")
        .onReceive(resignPub) { _ in
            if isActive {
                handleSaving()
            }
        }
        .onChange(of: sACitizen) { _ in
            if sACitizen != "No" {
                self.nationality = 0
                self.countryPassport = 0
                self.permanentResident = ""
                self.countryOfPermanentResidence = 0
                self.permitType = 0
                self.countryOfPermit = 0
                self.permitIssueDate = Date()
                self.permitExpiryDate = Date()
                self.contractIssueDate = Date()
                self.contractExpiryDate = Date()
                self.workPermitNumber = ""
                changedValues.changedValues.merge(dict: ["nationality": countries[0], "countryPassport": countries[0], "permanentResident": "", "countryOfPermanentResidence": countries[0], "permitType": permitTypes[0], "countryOfPermit": countries[0], "permitIssueDate": Date(), "permitExpiryDate": Date(), "contractIssueDate": Date(), "contractExpiryDate": Date(), "workPermitNumber": ""])
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
        
        // Handle the non-optional questions
        if !sACitizen.isEmpty && countryBirth != 0 && !cityOfBirth.isEmpty && homeLanguage != 0 && corresLanguage != 0 && !cellNumber.isEmpty && !emailAddress.isEmpty && resCountry != 0 && !resLine1.isEmpty && !resLine2.isEmpty && !resSuburb.isEmpty && !resCity.isEmpty && !resProvince.isEmpty && !resStreetCode.isEmpty && (!lengthAtAddressYears.isEmpty || !lengthAtAddressMonths.isEmpty) && !resIsPostal.isEmpty {
            
            if sACitizen == "No" && resIsPostal == "No" {
                if nationality != 0 && countryPassport != 0 && permitType != 0 && countryOfPermit != 0 && !workPermitNumber.isEmpty && postalCountry != 0 && !postalLine1.isEmpty && !postalLine2.isEmpty && !postalSuburb.isEmpty && !postalCity.isEmpty && !postalProvince.isEmpty && !postalStreetCode.isEmpty && ((permanentResident == "No" && countryOfPermanentResidence != 0) || permanentResident == "Yes") {
                    isComplete = true
                }
                // else isComplete = false
            } else if sACitizen == "No" && resIsPostal == "Yes" {
                if nationality != 0 && countryPassport != 0 && permitType != 0 && countryOfPermit != 0 && !workPermitNumber.isEmpty && ((permanentResident == "No" && countryOfPermanentResidence != 0) || permanentResident == "Yes") {
                    isComplete = true
                }
                // else isComplete = false
            } else if sACitizen == "Yes" && resIsPostal == "No" {
                if postalCountry != 0 && !postalLine1.isEmpty && !postalLine2.isEmpty && !postalSuburb.isEmpty && !postalCity.isEmpty && !postalProvince.isEmpty && !postalStreetCode.isEmpty {
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
        }
        
        do {
            try viewContext.save()
            print("print - New Application Saved")
            applicationCreation.residencyContactSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

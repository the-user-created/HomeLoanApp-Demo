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
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
    
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
    
    @State var sender: ChoosePageVer
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    let handleChangedValues = HandleChangedValues()
    
    let permitTypes = ["--select--", "Work permit", "--TBA--"]
    let languages = ["--select--", "English"]
    
    // MARK: - init
    init(isDone: Binding<Bool>, application: Application, sender: ChoosePageVer) {
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
        self._permitType = State(wrappedValue: permitTypes.firstIndex(of: self.application.permitType ?? "--select--") ?? 0)
        self._countryOfPermit = State(wrappedValue: countries.firstIndex(of: self.application.countryOfPermit ?? "--select--") ?? 0)
        self._permitIssueDate = State(wrappedValue: self.application.permitIssueDate ?? Date())
        self._permitExpiryDate = State(wrappedValue: self.application.permitExpiryDate ?? Date())
        self._contractIssueDate = State(wrappedValue: self.application.contractIssueDate ?? Date())
        self._contractExpiryDate = State(wrappedValue: self.application.contractExpiryDate ?? Date())
        self._workPermitNumber = State(wrappedValue: self.application.workPermitNumber ?? "")
        self._homeLanguage = State(wrappedValue: languages.firstIndex(of: self.application.homeLanguage ?? "--select--") ?? 0)
        self._corresLanguage = State(wrappedValue: languages.firstIndex(of: self.application.corresLanguage ?? "--select--") ?? 0)
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
            
            self._lengthAtAddressYears = State(wrappedValue: String(lengthAtAddress[lengthAtAddress.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]]))
            self._lengthAtAddressMonths = State(wrappedValue: String(lengthAtAddress[lengthAtAddress.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]]))
        }
    }
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("RESIDENCY")) {
                FormYesNo(iD: "sACitizen", pageNum: 2,
                          question: formQuestions[2][0] ?? "MISSING",
                          selected: $sACitizen)
                
                if sACitizen == "No" {
                    FormPicker(iD: "nationality", pageNum: 2,
                               question: formQuestions[2][0.1] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $nationality)
                    
                    FormPicker(iD: "countryPassport", pageNum: 2,
                               question: formQuestions[2][0.2] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $countryPassport)
                }
                
                FormPicker(iD: "countryBirth", pageNum: 2,
                           question: formQuestions[2][1] ?? "MISSING",
                           selectionOptions: countries,
                           selection: $countryBirth)
                
                FormTextField(iD: "cityOfBirth", pageNum: 2,
                              question: formQuestions[2][2] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][2] ?? "MISSING",
                              text: $cityOfBirth)
                
                FormYesNo(iD: "permanentResident", pageNum: 2,
                          question: formQuestions[2][3] ?? "MISSING",
                          selected: $permanentResident)
                
                if permanentResident == "No" {
                    FormPicker(iD: "countryOfPermanentResidence", pageNum: 2,
                               question: formQuestions[2][3.1] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $countryOfPermanentResidence)
                }
                
                Group() {
                    FormPicker(iD: "permitType", pageNum: 2,
                               question: formQuestions[2][4] ?? "MISSING",
                               selectionOptions: permitTypes,
                               selection: $permitType)
                    
                    FormPicker(iD: "countryOfPermit", pageNum: 2,
                               question: formQuestions[2][5] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $countryOfPermit)
                    
                    FormDatePicker(iD: "permitIssueDate", pageNum: 2,
                                   question: formQuestions[2][6] ?? "MISSING",
                                   dateRangeOption: 0,
                                   dateSelection: $permitIssueDate)
                    
                    FormDatePicker(iD: "permitExpiryDate", pageNum: 2,
                                   question: formQuestions[2][7] ?? "MISSING",
                                   dateRangeOption: 1,
                                   dateSelection: $permitExpiryDate)
                    
                    FormDatePicker(iD: "contractIssueDate", pageNum: 2,
                                   question: formQuestions[2][8] ?? "MISSING",
                                   dateRangeOption: 0,
                                   dateSelection: $contractIssueDate)
                    
                    FormDatePicker(iD: "contractExpiryDate", pageNum: 2,
                                   question: formQuestions[2][9] ?? "MISSING",
                                   dateRangeOption: 1,
                                   dateSelection: $contractExpiryDate)
                    
                    FormTextField(iD: "workPermitNumber", pageNum: 2,
                                  question: formQuestions[2][10] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][10] ?? "MISSING",
                                  text: $workPermitNumber)
                    
                }
                
            }
            
            Section(header: Text("CONTACT")) {
                FormPicker(iD: "homeLanguage", pageNum: 2,
                           question: formQuestions[2][11] ?? "MISSING",
                           selectionOptions: languages,
                           selection: $homeLanguage)
                
                FormPicker(iD: "corresLanguage", pageNum: 2,
                           question: formQuestions[2][12] ?? "MISSING",
                           selectionOptions: languages,
                           selection: $corresLanguage)
                
                FormTextField(iD: "cellNumber", pageNum: 2,
                              question: formQuestions[2][13] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][13] ?? "MISSING",
                              text: $cellNumber)
                    .keyboardType(.phonePad)
                
                FormTextField(iD: "emailAddress", pageNum: 2,
                              question: formQuestions[2][14] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][14] ?? "MISSING",
                              text: $emailAddress)
                    .keyboardType(.emailAddress)
                
            }
            
            Section(header: Text("RESIDENTIAL ADDRESS")) {
                FormPicker(iD: "resCountry", pageNum: 2,
                           question: formQuestions[2][15] ?? "MISSING",
                           selectionOptions: countries,
                           selection: $resCountry)
                
                FormTextField(iD: "resLine1", pageNum: 2,
                              question: formQuestions[2][15.1] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.1] ?? "MISSING",
                              text: $resLine1)
                
                FormTextField(iD: "resLine2", pageNum: 2,
                              question: formQuestions[2][15.2] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.2] ?? "MISSING",
                              text: $resLine2)
                
                FormTextField(iD: "resSuburb", pageNum: 2,
                              question: formQuestions[2][15.3] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.3] ?? "MISSING",
                              text: $resSuburb)
                
                FormTextField(iD: "resCity", pageNum: 2,
                              question: formQuestions[2][15.4] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.4] ?? "MISSING",
                              text: $resCity)
                
                FormTextField(iD: "resProvince", pageNum: 2,
                              question: formQuestions[2][15.5] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.5] ?? "MISSING",
                              text: $resProvince)
                
                FormTextField(iD: "resStreetCode", pageNum: 2,
                              question: formQuestions[2][15.6] ?? "MISSING",
                              placeholder: formTextFieldPlaceholders[2][15.6] ?? "MISSING",
                              text: $resStreetCode)
                
                FormLenAt(iD: "lengthAtAddress", pageNum: 2,
                          question: formQuestions[2][15.7] ?? "MISSING",
                          yearsText: $lengthAtAddressYears,
                          monthsText: $lengthAtAddressMonths)
                
            }
            
            Section(header: Text("POSTAL ADDRESS")) {
                FormYesNo(iD: "resIsPostal", pageNum: 2,
                          question: formQuestions[2][16] ?? "MISSING",
                          selected: $resIsPostal)
                
                if resIsPostal == "No" {
                    FormPicker(iD: "postalCountry", pageNum: 2,
                               question: formQuestions[2][15] ?? "MISSING",
                               selectionOptions: countries,
                               selection: $postalCountry)
                    
                    FormTextField(iD: "postalLine1", pageNum: 2,
                                  question: formQuestions[2][15.1] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.1] ?? "MISSING",
                                  text: $postalLine1)
                    
                    FormTextField(iD: "postalLine2", pageNum: 2,
                                  question: formQuestions[2][15.2] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.2] ?? "MISSING",
                                  text: $postalLine2)
                    
                    FormTextField(iD: "postalSuburb", pageNum: 2,
                                  question: formQuestions[2][15.3] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.3] ?? "MISSING",
                                  text: $postalSuburb)
                    
                    FormTextField(iD: "postalCity", pageNum: 2,
                                  question: formQuestions[2][15.4] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.4] ?? "MISSING",
                                  text: $postalCity)
                    
                    FormTextField(iD: "postalProvince", pageNum: 2,
                                  question: formQuestions[2][15.5] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.5] ?? "MISSING",
                                  text: $postalProvince)
                    
                    FormTextField(iD: "postalStreetCode", pageNum: 2,
                                  question: formQuestions[2][15.6] ?? "MISSING",
                                  placeholder: formTextFieldPlaceholders[2][15.6] ?? "MISSING",
                                  text: $postalStreetCode)
                }
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
        .navigationBarTitle("Residency & Contact")
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
                applicationCreation.application.setValue(value, forKey: key)
            } else {
                application.setValue(value, forKey: key)
            }
        }
        
        do {
            try viewContext.save()
            print("Application Entity Updated")
            handleChangedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

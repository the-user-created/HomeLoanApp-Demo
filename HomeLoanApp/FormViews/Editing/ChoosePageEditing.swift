//
//  ChoosePage.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/14.
//

import SwiftUI
import CoreData
import MessageUI

struct ChoosePageEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.openURL) var openURL
    @EnvironmentObject var changedValues: ChangedValues
    @ObservedObject var application: Application
    
    // MARK: - State Variables
    @State var assetsLiabilitiesDone: Bool = false
    @State var residencyContactDone: Bool = false
    @State var incomeDeductionsDone: Bool = false
    @State var personalDetailsDone: Bool = false
    @State var generalDetailsDone: Bool = false
    @State var subsidyCreditDone: Bool = false
    @State var documentScansDone: Bool = false
    @State var notificationDone: Bool = false
    @State var employmentDone: Bool = false
    @State var expensesDone: Bool = false
    
    @State var selection: Int?
    
    @State var notificationCheck: String = ""
    @State var signatureDone: Bool = false
    @State var identityDone: Bool?
    @State var salesConsultant: String = ""
    @State var scanGroup: [String] = []
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var canSendMail: Bool = MFMailComposeViewController.canSendMail()
    
    init(application: Application) {
        self.application = application
        self._generalDetailsDone = State(wrappedValue: self.application.generalDetailsDone)
        self._personalDetailsDone = State(wrappedValue: self.application.personalDetailsDone)
        self._residencyContactDone = State(wrappedValue: self.application.residencyContactDone)
        self._subsidyCreditDone = State(wrappedValue: self.application.subsidyCreditDone)
        self._employmentDone = State(wrappedValue: self.application.employmentDone)
        self._incomeDeductionsDone = State(wrappedValue: self.application.incomeDeductionsDone)
        self._expensesDone = State(wrappedValue: self.application.expensesDone)
        self._assetsLiabilitiesDone = State(wrappedValue: self.application.assetsLiabilitiesDone)
        self._documentScansDone = State(wrappedValue: self.application.documentScansDone)
        
        self._identityDone = State(wrappedValue: self.application.identityType != "--select--" && self.application.identityType != "" && self.application.identityType != nil)
        
        self._salesConsultant = State(wrappedValue: self.application.salesConsultant ?? "")
        self._scanGroup = State(wrappedValue: self.application.scanGroup ?? [])
    }
    
    // MARK: - body
    var body: some View {
        Form() {
            Group() {
                NavigationLink(destination: GeneralDetailsEditing(isDone: $generalDetailsDone, application: application, sender: .editor), tag: 0, selection: $selection) {
                    HStack() {
                        Text("General Details")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: generalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(generalDetailsDone ? .green: .red)
                    }
                }
                
                NavigationLink(destination: PersonalDetailsEditing(isDone: $personalDetailsDone, identityDoneBinding: $identityDone, application: application, sender: .editor), tag: 1, selection: $selection) {
                    HStack() {
                        Text("Personal Details")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: personalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(personalDetailsDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: ResidencyContactEditing(isDone: $residencyContactDone, application: application, sender: .editor), tag: 2, selection: $selection) {
                    HStack() {
                        Text("Residency & Contact")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: residencyContactDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(residencyContactDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: SubsidyCreditEditing(isDone: $subsidyCreditDone, application: application, sender: .editor), tag: 3, selection: $selection) {
                    HStack() {
                        Text("Subsidy & Credit")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: subsidyCreditDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(subsidyCreditDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: EmploymentEditing(isDone: $employmentDone, application: application, sender: .editor), tag: 4, selection: $selection) {
                    HStack() {
                        Text("Employment")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: employmentDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(employmentDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
            }
            
            Group() {
                NavigationLink(destination: IncomeDeductionsEditing(isDone: $incomeDeductionsDone, application: application, sender: .editor), tag: 5, selection: $selection) {
                    HStack() {
                        Text("Income & Deductions")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: incomeDeductionsDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(incomeDeductionsDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: ExpensesEditing(isDone: $expensesDone, application: application, sender: .editor), tag: 6, selection: $selection) {
                    HStack() {
                        Text("Expenses")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: expensesDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(expensesDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: AssetsLiabilitiesEditing(isDone: $assetsLiabilitiesDone, application: application, sender: .editor), tag: 7, selection: $selection) {
                    HStack() {
                        Text("Assets & Liabilities")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: assetsLiabilitiesDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(assetsLiabilitiesDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: DocumentScansEditing(application: application, isDone: $documentScansDone, scanGroup: $scanGroup, sender: .editor), tag: 8, selection: $selection) {
                    HStack() {
                        Text("Supporting Documents")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: documentScansDone ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(documentScansDone ? .green : .red)
                    }
                }
                .disabled(generalDetailsDone ? !identityDone! : true)
            }
            
            NavigationLink(destination: NotificationView(application: application, signatureDone: $signatureDone, notificationCheck: $notificationCheck, isDone: $notificationDone, sender: .editor), tag: 9, selection: $selection) {
                HStack() {
                    Text("Notification")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: notificationDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(notificationDone ? .green : .red)
                }
            }
            .disabled(!canSubmit())
            
            // Submit Application
            Section() {
                if !canSendMail { // Mail app is not installed
                    HStack() {
                        Text("Please download the Mail app to submit your application.")
                        
                        Spacer()
                        
                        Button(action: {
                            openURL(URL(string: "https://apps.apple.com/za/app/mail/id1108187098")!)
                        }) {
                            Text("Get Mail")
                                .font(.headline)
                        }
                    }
                } else if notificationDone && canSubmit() { // Mail installed, notification accepted, sections completed
                    Button(action: {
                        self.isShowingMailView.toggle()
                    }) {
                        Text("Submit Application")
                            .font(.title3)
                            .bold()
                    }
                } else if !notificationDone && canSubmit() { // Mail installed, notification not accepted, sections completed
                    Text("Please accept the notification above to submit your application.")
                } else if !canSubmit() { // Mail installed, sections incomplete
                    Text("Please complete the form sections above to submit your application")
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .navigationBarTitle("Editing", displayMode: .large)
        .onChange(of: selection) { value in
            changedValues.cleanChangedValues()
        }
        .sheet(isPresented: $isShowingMailView) {
            let clientName = "\(self.application.surname ?? "NIL"), \(self.application.firstNames ?? "NIL")"
            let recipients = [salesConsultantEmails[salesConsultant] ?? ""]
            MailView(clientName: clientName, emailBody: makeEmailBody(), recipients: recipients, attachments: [:], isShowing: self.$isShowingMailView, result: self.$result)
        }
    }
    
    // MARK: - canSubmit
    private func canSubmit() -> Bool {
        if generalDetailsDone && personalDetailsDone && residencyContactDone && subsidyCreditDone && employmentDone && incomeDeductionsDone && expensesDone && assetsLiabilitiesDone {
            return true
        }
        
        return false
    }
    
    // MARK: - makeEmailBody
    private func makeEmailBody() -> String {
        // GENERAL
        var generalDetails = "General Details:\n\n"
        
        for i in 0..<6 {
            let i = Double(i)
            let formID: String = formIDs[0][i] ?? ""
            let value = application.value(forKey: formID) ?? ""
            generalDetails += "\(formQuestions[0][i] ?? "")  =  \(uppercasingIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
        }
        
        let numberOfApplicants: Int = Int(application.numberOfApplicants ?? "1") ?? 1
        if numberOfApplicants > 1 {
            generalDetails += "Co-Applicant #1  =  \(application.coApplicantOneName ?? "")\n"
            generalDetails += numberOfApplicants >= 3 ? "Co-Applicant #2  =  \(application.coApplicantTwoName ?? "")\n" : ""
            generalDetails += numberOfApplicants == 4 ? "Co-Applicant #3  =  \(application.coApplicantThreeName ?? "")\n" : ""
        }
        
        // PERSONAL DETAILS
        var personalDetails = "\n\nPersonal Details:\n"
        
        var i: Double = 0
        while i < 27 {
            let formID = formIDs[1][i] ?? ""
            if i == 5 {
                let identityType: String = (application.value(forKey: formID) ?? "") as! String
                personalDetails += "\(formQuestions[1][5] ?? "")  =  \(identityType.uppercased())\n"
                personalDetails += "\(formQuestions[1][6] ?? "")  =  \(application.value(forKey: formIDs[1][6] ?? "") ?? "")\n"
                if identityType == "Passport" {
                    personalDetails += "\(formQuestions[1][10] ?? "")  =  \(dateFormatter.string(from: application.passExpiryDate ?? Date()))\n"
                }
                i += 6
            } else if i == 17 {
                let value = (application.value(forKey: formID) ?? "")  as! String
                personalDetails += "\(formQuestions[1][17] ?? "")  =  \(value.uppercased())\n"
                if value != "Divorced" && value != "Single" { // Checks if the applicant is married
                    var j: Double = 18
                    while j < 22 {
                        let jFormID = formIDs[1][j] ?? ""
                        let value = application.value(forKey: jFormID) ?? ""
                        personalDetails += "\(formQuestions[1][j] ?? "")  =  \(uppercasingIDs.contains(jFormID) ? (value as! String).uppercased() : value)\n"
                        j += 1
                    }
                }
                i += 5
            } else {
                let value = application.value(forKey: formID) ?? ""
                if formID == "dateOfBirth" {
                    personalDetails += "\(formQuestions[1][i] ?? "")  =  \(dateFormatter.string(from: application.dateOfBirth ?? Date()))\n"
                } else {
                    personalDetails += "\(formQuestions[1][i] ?? "")  =  \(uppercasingIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
                }
                i += 1
            }
        }
        
        // RESIDENCY & CONTACT
        var residencyContact = "\n\nResidency & Contact:\n"
        
        i = 0
        while i < 20 {
            let formID: String = formIDs[2][i] ?? ""
            let value = application.value(forKey: formID) ?? ""
            if i == 0 {
                residencyContact += "\(formQuestions[2][i] ?? "")  =  \((value as! String).uppercased())\n"
                if (value as! String) == "No" {
                    residencyContact += "\(formQuestions[2][1] ?? "")  =  \(((application.value(forKey: formIDs[2][1] ?? "") ?? "") as! String).uppercased())\n"
                    residencyContact += "\(formQuestions[2][2] ?? "")  =  \(((application.value(forKey: formIDs[2][2] ?? "") ?? "") as! String).uppercased())\n"
                }
                
                i += 3
            } else if i == 5 {
                if application.sACitizen == "No" {
                    residencyContact += "\(formQuestions[2][i] ?? "")  =  \((value as! String).uppercased())\n"
                    if (value as! String) == "No" {
                        let countryPermaRes = ((application.value(forKey: formIDs[2][6] ?? "") ?? "") as! String).uppercased()
                        residencyContact += "\(formQuestions[2][6] ?? "")  =  \(countryPermaRes)\n"
                    }
                }
                
                i += 2
            } else if i == 18 {
                let value = value as! String
                let openBracketIndices = findNth("[", text: value)
                let closeBracketIndices = findNth("]", text: value)
                
                var lengthAtAddressYears: String = ""
                var lengthAtAddressMonths: String = ""
                
                if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                    lengthAtAddressYears = String(value[value.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]])
                    lengthAtAddressMonths = String(value[value.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]])
                }
                
                residencyContact += "\(formQuestions[2][i] ?? "")  =  \(handleLenAtText(years: lengthAtAddressYears, months: lengthAtAddressMonths))\n"
                i += 1
            } else {
                residencyContact += "\(formQuestions[2][i] ?? "")  =  \(uppercasingIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
                i += 1
            }
        }
        
        if application.resIsPostal == "No" {
            residencyContact += "\(formQuestions[2][11] ?? "")  =  \(application.postalCountry ?? "")\n"
            residencyContact += "\(formQuestions[2][12] ?? "")  =  \(application.postalLine1 ?? "")\n"
            residencyContact += "\(formQuestions[2][13] ?? "")  =  \(application.postalLine2 ?? "")\n"
            residencyContact += "\(formQuestions[2][14] ?? "")  =  \(application.postalSuburb ?? "")\n"
            residencyContact += "\(formQuestions[2][15] ?? "")  =  \(application.postalCity ?? "")\n"
            residencyContact += "\(formQuestions[2][16] ?? "")  =  \(application.postalProvince ?? "")\n"
            residencyContact += "\(formQuestions[2][17] ?? "")  =  \(application.postalStreetCode ?? "")\n"
        }
        
        // SUBSIDY & CREDIT HISTORY
        var subsidyCredit = "\n\nSubsidy & Credit History:\n"
        
        for i in 0..<12 {
            let i = Double(i)
            let value = (application.value(forKey: formIDs[3][i] ?? "") ?? "") as! String
            subsidyCredit += "\(formQuestions[3][i] ?? "")  =  \(value.uppercased())\n"
        }
        
        // EMPLOYMENT
        var employment = "\n\nEmployment:\n"
        
        for i in 0..<(application.previouslyEmployed == "Yes" ? 25 : 22) {
            let i = Double(i)
            let formID = formIDs[4][i] ?? ""
            let value = application.value(forKey: formID) ?? ""
            if formID == "employmentPeriod" {
                let employValue = value as! String
                let openBracketIndices = findNth("[", text: employValue)
                let closeBracketIndices = findNth("]", text: employValue)
                
                var employmentPeriodYears: String = ""
                var employmentPeriodMonths: String = ""
                
                if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                    employmentPeriodYears = String(employValue[employValue.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]])
                    employmentPeriodMonths = String(employValue[employValue.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]])
                }
                
                employment += "\(formQuestions[4][i] ?? "")  =  \(handleLenAtText(years: employmentPeriodYears, months: employmentPeriodMonths))\n"
            } else if formID == "pEDuration" {
                let pEValue = value as! String
                let openBracketIndices = findNth("[", text: pEValue)
                let closeBracketIndices = findNth("]", text: pEValue)
                
                var pEDurationYears: String = ""
                var pEDurationMonths: String = ""
                
                if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                    pEDurationYears = String(pEValue[pEValue.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]])
                    pEDurationMonths = String(pEValue[pEValue.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]])
                }
                
                employment += "\(formQuestions[4][i] ?? "")  =  \(handleLenAtText(years: pEDurationYears, months: pEDurationMonths))\n"
            } else {
                employment += "\(formQuestions[4][i] ?? "")  =  \(uppercasingIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
            }
        }
        
        // INCOME & DEDUCTIONS
        var incomeDeductions = "\n\nIncome & Deductions:\n"
        var totalIncome: Float = 0.0
        var totalDeductions: Float = 0.0
        
        for i in 0..<20 {
            let i = Double(i)
            let formID: String = formIDs[5][i] ?? ""
            var value: String = (application.value(forKey: formID) as? String) ?? ""
            if (formID == "otherIncome" || formID == "otherDeductions") && !value.isEmpty {
                let open = findNth("[", text: value)
                let close = findNth("]", text: value)
                incomeDeductions += handleOtherRand(value: value, open: open, close: close, j: 5, i: i)
                value = String(value[value.index(open[1], offsetBy: 1)..<close[1]])
            } else if !value.isEmpty {
                incomeDeductions += "\(formQuestions[5][i] ?? "")  =  \(value)\n"
            }
            
            if i < 15 {
                totalIncome = totalIncome.advanced(by: Float(value.replacingOccurrences(of: "R", with: "")) ?? 0.0)
            } else {
                totalDeductions = totalDeductions.advanced(by: Float(value.replacingOccurrences(of: "R", with: "")) ?? 0.0)
            }
        }
        
        let netSalary: Float = totalIncome - totalDeductions
        incomeDeductions += "\nTotal Income = R\(String(format: "%.0f", totalIncome))\nTotal Deductions = R\(String(format: "%.0f", totalDeductions))\nNet Salary = R\(String(format: "%.0f", netSalary))\n"
        
        // EXPENSES
        var expenses = "\n\nExpenses:\n"
        var totalExpenses: Float = 0.0
        
        for i in 0..<25 {
            let i = Double(i)
            let formID: String = formIDs[6][i] ?? ""
            var value: String = (application.value(forKey: formIDs[6][i] ?? "") as? String) ?? ""
            if formID == "otherExpenses" && !value.isEmpty {
                let open = findNth("[", text: value)
                let close = findNth("]", text: value)
                expenses += handleOtherRand(value: value, open: open, close: close, j: 6, i: i)
                value = String(value[value.index(open[1], offsetBy: 1)..<close[1]])
            } else if !value.isEmpty {
                expenses += "\(formQuestions[6][i] ?? "")  =  \(value)\n"
            }
            
            totalExpenses = totalExpenses.advanced(by: Float(value.replacingOccurrences(of: "R", with: "")) ?? 0.0)
        }
        
        expenses += "\nTotal Expenses = R\(String(format: "%.0f", totalExpenses))\n"
        
        // ASSETS & LIABILITIES
        var assetsLiabilities = "\n\nAssets & Liabilities:\n"
        var totalAssets: Float = 0.0
        var totalLiabilities: Float = 0.0
        
        for i in 0..<15 {
            let i = Double(i)
            let formID = formIDs[7][i] ?? ""
            var value: String = (application.value(forKey: formID) as? String) ?? ""
            if (formID == "otherAsset" || formID == "otherAcc" || formID == "otherLiabilities") && !value.isEmpty {
                let open = findNth("[", text: value)
                let close = findNth("]", text: value)
                assetsLiabilities += handleOtherRand(value: value, open: open, close: close, j: 7, i: i)
                value = String(value[value.index(open[1], offsetBy: 1)..<close[1]])
            } else if !value.isEmpty {
                assetsLiabilities += "\(formQuestions[7][i] ?? "")  =  \(value)\n"
            }
            
            if i < 6 {
                totalAssets = totalAssets.advanced(by: Float(value.replacingOccurrences(of: "R", with: "")) ?? 0.0)
            } else {
                totalLiabilities = totalLiabilities.advanced(by: Float(value.replacingOccurrences(of: "R", with: "")) ?? 0.0)
            }
        }
        
        assetsLiabilities += "\nTotal Assets = R\(String(format: "%.0f", totalAssets))\nTotal Liabilities = R\(String(format: "%.0f", totalLiabilities))\n"
        
        // NOTIFICATION
        var notification: String = ""
        let clientName = "\(application.surname ?? "NIL"), \(application.firstNames ?? "NIL")"
        
        if application.notificationsCheck == "Yes" {
            notification = "\n\nThe client \(clientName) has accepted the notification.\n"
        } else {
            notification = "\n\nThe client \(clientName) has not accepted the notification.\n"
        }
        
        let emailBody = generalDetails + personalDetails + residencyContact + subsidyCredit + employment + incomeDeductions + expenses + assetsLiabilities + notification
        
        return emailBody
    }
    
    // MARK: - handleOtherRand
    private func handleOtherRand(value: String, open: [String.Index], close: [String.Index], j: Int, i: Double) -> String {
        var text: String = ""
        var randValue: String = ""
        
        if !open.isEmpty && !close.isEmpty {
            text = String(value[value.index(open[0], offsetBy: 1)..<close[0]])
            randValue = String(value[value.index(open[1], offsetBy: 1)..<close[1]])
        }
        
        return "\(formQuestions[j][i] ?? "")  =  \(randValue) for \(text)\n"
    }
    
    // MARK: - handleLenAtText
    private func handleLenAtText(years: String, months: String) -> String {
        var result: String = ""
        if !years.isEmpty && !months.isEmpty {
            result = "\(years) YEAR\((Int(years) ?? 0) > 1 ? "S" : ""), \(months) MONTH\((Int(months) ?? 0) > 1 ? "S" : "")"
        } else if !years.isEmpty {
            result = "\(years) YEAR\((Int(years) ?? 0) > 1 ? "S" : "")"
        } else if !months.isEmpty {
            result = "\(months) MONTH\((Int(months) ?? 0) > 1 ? "S" : "")"
        }
        
        return result
    }
    
    // MARK: - getAttachments
    private func getAttachments() -> [String: Data] {
        var attachments: [String: Data] = [:]
        let loanID: String = application.loanID?.uuidString ?? ""
        
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Signature Image
            let signatureURL = documentsDirectory.appendingPathComponent("signature_\(loanID)_image.png")
            
            if FileManager.default.fileExists(atPath: signatureURL.path) {
                do {
                    let signatureData = try Data(contentsOf: signatureURL)
                    attachments.updateValue(signatureData, forKey: "Client_Signature.png")
                    print("print - Loaded signature")
                } catch {
                    print("print - Error loading signature: \(error)")
                }
            }
            
            // Identity Scan(s)
            if scanGroup.contains("identity") { // Checking if client did scan a identity document
                let identityType: String = application.identityType ?? ""
                let identityURL = documentsDirectory.appendingPathComponent("identity_scan_\(loanID)_0.png")
                
                if FileManager.default.fileExists(atPath: identityURL.path) {
                    do {
                        let identityData = try Data(contentsOf: identityURL)
                        attachments.updateValue(identityData, forKey: "Identity_Scan\(identityType != "Smart ID Card" ? "" : "_1").png")
                        print("print - Loaded identity image #1")
                    } catch {
                        print("print - Error loading identity image #1: \(error)")
                    }
                }
                
                if identityType == "Smart ID Card" {
                    let identityURL = documentsDirectory.appendingPathComponent("identity_scan_\(loanID)_1.png")
                    
                    if FileManager.default.fileExists(atPath: identityURL.path) {
                        do {
                            let identityData = try Data(contentsOf: identityURL)
                            attachments.updateValue(identityData, forKey: "Identity_Scan_2.png")
                            print("print - Loaded identity image #2")
                        } catch {
                            print("print - Error loading identity image #2: \(error)")
                        }
                    }
                }
            }
            
            // Salary / Pay Scan(s)
            if scanGroup.contains("salaryPay") {
                let url = "salary_pay_scan_\(loanID)_"
                var i: Int = 0
                while true {
                    let newURL = url + "\(i).png"
                    let fileURL = documentsDirectory.appendingPathComponent(newURL)
                    
                    if FileManager.default.fileExists(atPath: fileURL.path) {
                        // File exists
                        do {
                            let imageData = try Data(contentsOf: fileURL)
                            print("print - Loaded image")
                            attachments.updateValue(imageData, forKey: "Salary_Pay_Scan_#\(i + 1).png")
                        } catch {
                            print("print - Error loading image: \(error)")
                        }
                        
                        i += 1
                    } else {
                        // File doesn't exist
                        break
                    }
                }
            }
            
            // Bank Statement Scan(s)
            if scanGroup.contains("bankStatements") {
                let url = "bank_statement_scan_\(loanID)_"
                var i: Int = 0
                while true {
                    let newURL = url + "\(i).png"
                    let fileURL = documentsDirectory.appendingPathComponent(newURL)
                    
                    if FileManager.default.fileExists(atPath: fileURL.path) {
                        // File exists
                        do {
                            let imageData = try Data(contentsOf: fileURL)
                            print("print - Loaded image")
                            attachments.updateValue(imageData, forKey: "Bank_Statement_Scan_#\(i + 1).png")
                        } catch {
                            print("print - Error loading image: \(error)")
                        }
                        
                        i += 1
                    } else {
                        // File doesn't exist
                        break
                    }
                }
            }
        }
        
        return attachments
    }
}

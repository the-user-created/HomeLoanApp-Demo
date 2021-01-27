//
//  ChoosePageCreating.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/13.
//

import SwiftUI
import CoreData
import MessageUI

struct ChoosePageCreating: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.openURL) var openURL
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
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
    
    @State var identityDone: Bool?
    @State var notificationCheck: String = ""
    @State var signatureDone: Bool = false
    @State var scanGroup: [String] = []
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var canSendMail: Bool = MFMailComposeViewController.canSendMail()
    
    // MARK: - body
    var body: some View {
        Form() {
            // General Details
            NavigationLink(destination: applicationCreation.generalDetailsSaved ? AnyView(GeneralDetailsEditing(isDone: $generalDetailsDone, application: applicationCreation.application, sender: .creator)) : AnyView(GeneralDetails(isDone: $generalDetailsDone))) {
                HStack() {
                    Text("General Details")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: generalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(generalDetailsDone ? .green: .red)
                }
            }
            
            // Personal Details
            NavigationLink(destination: applicationCreation.personalDetailsSaved ? AnyView(PersonalDetailsEditing(isDone: $personalDetailsDone, identityDoneBinding: $identityDone, application: applicationCreation.application, sender: .creator)) : AnyView(PersonalDetails(isDone: $personalDetailsDone, identityDoneBinding: $identityDone))) {
                HStack() {
                    Text("Personal Details")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: personalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(personalDetailsDone ? .green: .red)
                }
            }
            .disabled(!generalDetailsDone)
            
            // Residency & Contact
            NavigationLink(destination: applicationCreation.residencyContactSaved ? AnyView(ResidencyContactEditing(isDone: $residencyContactDone, application: applicationCreation.application, sender: .creator)) : AnyView(ResidencyContact(isDone: $residencyContactDone))) {
                HStack() {
                    Text("Residency & Contact")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: residencyContactDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(residencyContactDone ? .green: .red)
                }
            }
            .disabled(!generalDetailsDone)
            
            // Subsidy & Credit
            NavigationLink(destination: applicationCreation.subsidyCreditSaved ? AnyView(SubsidyCreditEditing(isDone: $subsidyCreditDone, application: applicationCreation.application, sender: .creator)) : AnyView(SubsidyCredit(isDone: $subsidyCreditDone))) {
                HStack() {
                    Text("Subsidy & Credit")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: subsidyCreditDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(subsidyCreditDone ? .green: .red)
                }
            }
            .disabled(!generalDetailsDone)
            
            // Employment
            NavigationLink(destination: applicationCreation.employmentSaved ? AnyView(EmploymentEditing(isDone: $employmentDone, application: applicationCreation.application, sender: .creator)) : AnyView(Employment(isDone: $employmentDone))) {
                HStack() {
                    Text("Employment")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: employmentDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(employmentDone ? .green: .red)
                }
            }
            .disabled(!generalDetailsDone)
            
            // Income & Deductions
            NavigationLink(destination: applicationCreation.incomeSaved ? AnyView(IncomeDeductionsEditing(isDone: $incomeDeductionsDone, application: applicationCreation.application, sender: .creator)) : AnyView(IncomeDeductions(isDone: $incomeDeductionsDone))) {
                HStack() {
                    Text("Income & Deductions")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: incomeDeductionsDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(incomeDeductionsDone ? .green: .red)
                }
            }
            .disabled(!generalDetailsDone)
            
            // Expenses
            NavigationLink(destination: applicationCreation.expensesSaved ? AnyView(ExpensesEditing(isDone: $expensesDone, application: applicationCreation.application, sender: .creator)) : AnyView(Expenses(isDone: $expensesDone))) {
                HStack() {
                    Text("Expenses")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: expensesDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(expensesDone ? .green: .red)
                }
            }
            .disabled(!generalDetailsDone)
            
            // Assets & Liabilities
            NavigationLink(destination: applicationCreation.assetsLiabilitiesSaved ? AnyView(AssetsLiabilitiesEditing(isDone: $assetsLiabilitiesDone, application: applicationCreation.application, sender: .creator)) : AnyView(AssetsLiabilities(isDone: $assetsLiabilitiesDone))) {
                HStack() {
                    Text("Assets & Liabilities")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: assetsLiabilitiesDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(assetsLiabilitiesDone ? .green: .red)
                }
            }
            .disabled(!generalDetailsDone)
            
            // Document Scans, Notification & Warranty
            Group() {
                // Document Scans
                NavigationLink(destination: applicationCreation.documentScansSaved ? AnyView(DocumentScansEditing(application: applicationCreation.application, isDone: $documentScansDone, scanGroup: $scanGroup, sender: .creator)) : AnyView(DocumentScans(isDone: $documentScansDone, scanGroup: $scanGroup))) {
                    HStack() {
                        Text("Supporting Documents")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: documentScansDone ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(documentScansDone ? .green : .red)
                    }
                }
                .disabled(generalDetailsDone ? !(identityDone ?? false) : true)
                
                // Notification & Warranty
                NavigationLink(destination: NotificationView(application: applicationCreation.application, signatureDone: $signatureDone, notificationCheck: $notificationCheck, isDone: $notificationDone, sender: .creator), tag: 18, selection: $selection) {
                    HStack() {
                        Text("Notification")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: notificationDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(notificationDone ? .green: .red)
                    }
                }
                .disabled(!canSubmit())
            }
            
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
                } else if canSendMail && notificationDone && canSubmit() { // Mail installed, notification accepted, sections completed
                    Button(action: {
                        self.isShowingMailView.toggle()
                    }) {
                        Text("Submit Application")
                            .font(.title3)
                            .bold()
                    }
                } else if !notificationDone && canSendMail && canSubmit() { // Mail installed, notification not accepted, sections completed
                    Text("Please accept the notification above to submit your application.")
                } else if !canSubmit() && canSendMail { // Mail installed, sections incomplete
                    Text("Please complete the form sections above to submit your application")
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .navigationBarTitle("Creating", displayMode: .large)
        .onChange(of: selection) { _ in
            changedValues.cleanChangedValues()
        }
        .sheet(isPresented: $isShowingMailView) {
            let clientName: String = "\(applicationCreation.application.surname ?? "NIL"), \(applicationCreation.application.firstNames ?? "NIL")"
            let recipients = [salesConsultantEmails[applicationCreation.application.salesConsultant ?? ""] ?? ""]
            MailView(clientName: clientName, emailBody: makeEmailBody(), recipients: recipients, attachments: getAttachments(), isShowing: self.$isShowingMailView, result: self.$result)
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
        var generalDetails = "General Details:\n"
        
        for i in 0..<6 {
            let i = Double(i)
            generalDetails += "\(formQuestions[0][i] ?? "")  =  \(applicationCreation.application.value(forKey: formIDs[0][i] ?? "") ?? "")\n"
        }
        
        let numberOfApplicants: Int = Int(applicationCreation.application.numberOfApplicants ?? "1") ?? 1
        if numberOfApplicants > 1 {
            generalDetails += "Co-Applicant #1  =  \(applicationCreation.application.coApplicantOneName ?? "")\n"
            generalDetails += numberOfApplicants >= 2 ? "Co-Applicant #2  =  \(applicationCreation.application.coApplicantTwoName ?? "")\n" : ""
            generalDetails += numberOfApplicants == 3 ? "Co-Applicant #3  =  \(applicationCreation.application.coApplicantThreeName ?? "")\n" : ""
        }
        
        // PERSONAL DETAILS
        var personalDetails = "\nPersonal Details:\n"
        
        for i in 0..<26 {
            let i = Double(i)
            if i != 7 && i != 8 && i != 9 {
                personalDetails += "\(formQuestions[1][i] ?? "")  =  \(applicationCreation.application.value(forKey: formIDs[1][i] ?? "") ?? "")\n"
            }
        }
        
        // RESIDENCY & CONTACT
        var residencyContact = "\nResidency & Contact:\n"
        
        for i in 0..<19 {
            let i = Double(i)
            residencyContact += "\(formQuestions[2][i] ?? "")  =  \(applicationCreation.application.value(forKey: formIDs[2][i] ?? "") ?? "")\n"
        }
        
        if applicationCreation.application.resIsPostal == "No" {
            residencyContact += "\(formQuestions[2][11] ?? "")  =  \(applicationCreation.application.postalCountry ?? "")\n"
            residencyContact += "\(formQuestions[2][12] ?? "")  =  \(applicationCreation.application.postalLine1 ?? "")\n"
            residencyContact += "\(formQuestions[2][13] ?? "")  =  \(applicationCreation.application.postalLine2 ?? "")\n"
            residencyContact += "\(formQuestions[2][14] ?? "")  =  \(applicationCreation.application.postalSuburb ?? "")\n"
            residencyContact += "\(formQuestions[2][15] ?? "")  =  \(applicationCreation.application.postalCity ?? "")\n"
            residencyContact += "\(formQuestions[2][16] ?? "")  =  \(applicationCreation.application.postalProvince ?? "")\n"
            residencyContact += "\(formQuestions[2][17] ?? "")  =  \(applicationCreation.application.postalStreetCode ?? "")\n"
        }
        
        // SUBSIDY & CREDIT HISTORY
        var subsidyCredit = "\nSubsidy & Credit History:\n"
        
        for i in 0..<11 {
            let i = Double(i)
            subsidyCredit += "\(formQuestions[3][i] ?? "")  =  \(applicationCreation.application.value(forKey: formIDs[3][i] ?? "") ?? "")\n"
        }
        
        // EMPLOYMENT
        var employment = "\nEmployment:\n"
        
        for i in 0..<24 {
            let i = Double(i)
            employment += "\(formQuestions[4][i] ?? "")  =  \(applicationCreation.application.value(forKey: formIDs[4][i] ?? "") ?? "")\n"
        }
        
        // INCOME & DEDUCTIONS
        var incomeDeductions = "\nIncome & Deductions:\n"
        
        for i in 0..<19 {
            let i = Double(i)
            let value: String = (applicationCreation.application.value(forKey: formIDs[5][i] ?? "") as? String) ?? ""
            if !value.isEmpty {
                incomeDeductions += "\(formQuestions[5][i] ?? "")  =  \(value)\n"
            }
        }
        
        // EXPENSES
        var expenses = "\nExpenses:\n"
        
        for i in 0..<23 {
            let i = Double(i)
            let value: String = (applicationCreation.application.value(forKey: formIDs[6][i] ?? "") as? String) ?? ""
            if !value.isEmpty {
                expenses += "\(formQuestions[6][i] ?? "")  =  \(value)\n"
            }
        }
        
        // ASSETS & LIABILITIES
        var assetsLiabilities = "\nAssets & Liabilities:\n"
        
        for i in 0..<14 {
            let i = Double(i)
            let value: String = (applicationCreation.application.value(forKey: formIDs[7][i] ?? "") as? String) ?? ""
            if !value.isEmpty {
                assetsLiabilities += "\(formQuestions[7][i] ?? "")  =  \(value)\n"
            }
        }
        
        let emailBody = generalDetails + personalDetails + residencyContact + subsidyCredit + employment + incomeDeductions + expenses + assetsLiabilities
        
        return emailBody
    }
    
    // MARK: - getAttachments
    private func getAttachments() -> [String: Data] {
        var attachments: [String: Data] = [:]
        let loanID = applicationCreation.application.loanID?.uuidString ?? ""
        
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
                let identityType: String = applicationCreation.application.identityType ?? ""
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

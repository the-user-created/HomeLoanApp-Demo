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
    @State var submitted: Bool = false
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
        self._scanGroup = State(wrappedValue: self.application.scanGroup)
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
                if application.loanStatus == Status.submitted.rawValue {
                    Text("You have submitted this application.")
                } else if !canSendMail { // Mail app is not installed
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
                        self.isShowingMailView = true
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
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .onChange(of: selection) { _ in
            changedValues.cleanChangedValues()
        }
        .onChange(of: submitted) { _ in
            if submitted {
                application.loanStatus = Status.submitted.rawValue
                
                do {
                    try viewContext.save()
                    print("Application Entity Updated")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            let clientName = "\(self.application.surname ?? "NIL"), \(self.application.firstNames ?? "NIL")"
            let recipients = [salesConsultantEmails[salesConsultant] ?? ""]
            MailView(clientName: clientName, emailBody: makeEmailBody(application: application), recipients: recipients, attachments: [:], isShowing: self.$isShowingMailView, result: self.$result, submitted: $submitted)
        }
    }
    
    // MARK: - canSubmit
    private func canSubmit() -> Bool {
        if generalDetailsDone && personalDetailsDone && residencyContactDone && subsidyCreditDone && employmentDone && incomeDeductionsDone && expensesDone && assetsLiabilitiesDone {
            return true
        }
        
        return false
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

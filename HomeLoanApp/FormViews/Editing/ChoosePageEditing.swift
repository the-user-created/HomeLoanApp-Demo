//
//  ChoosePage.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/14.
//

import SwiftUI
import CoreData
import MessageUI
import PDFKit

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
    @State var idxDone: Bool = false
    @State var poADone: Bool = false
    
    @State var selection: Int?
    
    @State var notificationCheck: String = ""
    @State var identityDone: Bool?
    @State var salesConsultant: String = ""
    @State var scanGroup: [String] = []
    
    @State var sheetType: SubmissionSheets = .none
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var submitted: Bool = false
    @State var sheetShowing = false
    @State var canSendMail: Bool = MFMailComposeViewController.canSendMail()
    
    public var documentData: Data?
    
    // MARK: - init
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
        
        self._identityDone = State(wrappedValue: self.application.identityType != "--select--" && self.application.identityType != "" &&
                self.application.identityType != nil)
        
        self._salesConsultant = State(wrappedValue: self.application.salesConsultant ?? "")
        self._scanGroup = State(wrappedValue: self.application.scanGroup)
    }
    
    // MARK: - body
    var body: some View {
        Form {
            Group {
                NavigationLink(destination: GeneralDetailsEditing(isDone: $generalDetailsDone, application: application, sender: .editor), tag: 0,
                        selection: $selection) {
                    HStack {
                        Text("General Details")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: generalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(generalDetailsDone ? .green: .red)
                    }
                }
                
                NavigationLink(destination: PersonalDetailsEditing(isDone: $personalDetailsDone, identityDoneBinding: $identityDone, application: application,
                        sender: .editor), tag: 1, selection: $selection) {
                    HStack {
                        Text("Personal Details")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: personalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(personalDetailsDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: ResidencyContactEditing(isDone: $residencyContactDone, application: application, sender: .editor), tag: 2,
                        selection: $selection) {
                    HStack {
                        Text("Residency & Contact")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: residencyContactDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(residencyContactDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: SubsidyCreditEditing(isDone: $subsidyCreditDone, application: application, sender: .editor), tag: 3,
                        selection: $selection) {
                    HStack {
                        Text("Subsidy & Credit")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: subsidyCreditDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(subsidyCreditDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: EmploymentEditing(isDone: $employmentDone, application: application, sender: .editor), tag: 4,
                        selection: $selection) {
                    HStack {
                        Text("Employment")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: employmentDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(employmentDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
            }
            
            Group {
                NavigationLink(destination: IncomeDeductionsEditing(isDone: $incomeDeductionsDone, application: application, sender: .editor), tag: 5,
                        selection: $selection) {
                    HStack {
                        Text("Income & Deductions")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: incomeDeductionsDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(incomeDeductionsDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: ExpensesEditing(isDone: $expensesDone, application: application, sender: .editor), tag: 6, selection: $selection) {
                    HStack {
                        Text("Expenses")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: expensesDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(expensesDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: AssetsLiabilitiesEditing(isDone: $assetsLiabilitiesDone, application: application, sender: .editor), tag: 7,
                        selection: $selection) {
                    HStack {
                        Text("Assets & Liabilities")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: assetsLiabilitiesDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(assetsLiabilitiesDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: DocumentScansEditing(application: application, isDone: $documentScansDone, scanGroup: $scanGroup, sender: .editor),
                        tag: 8, selection: $selection) {
                    HStack {
                        Text("Supporting Documents")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: documentScansDone ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(documentScansDone ? .green : .red)
                    }
                }
                .disabled(generalDetailsDone ? !identityDone! : true)
            }
            
            // Legalities
            Group {
                NavigationLink(destination: NotificationView(application: application, notificationCheck: $notificationCheck,
                        isDone: $notificationDone, sender: .editor), tag: 9, selection: $selection) {
                    HStack {
                        Text("Notification")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: notificationDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(notificationDone ? .green : .red)
                    }
                }
                .disabled(!canSubmit())
                
                NavigationLink(destination: IDXConsentEditing(application: application, isDone: $idxDone, sender: .editor), tag: 10, selection: $selection) {
                    HStack {
                        Text("IDX Consent")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: idxDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(idxDone ? .green : .red)
                    }
                }
                
                NavigationLink(destination: EmptyView()) {
                    HStack {
                        Text("Power of Attorney")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: poADone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(poADone ? .green : .red)
                    }
                }
                .disabled(!canSubmit())
            }
            
            // Submit Application
            Section {
                Button(action: {
                    sheetType = .mailView
                    self.sheetShowing = true
                }) {
                    Text("Submit Application")
                        .font(.title3)
                        .bold()
                }
                /*if application.loanStatus == Status.submitted.rawValue {
                    Text("You have submitted this application.")
                } else *//*if !canSendMail { // Mail app is not installed
                    HStack {
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
                        sheetType = .mailView
                        self.sheetShowing = true
                    }) {
                        Text("Submit Application")
                            .font(.title3)
                            .bold()
                    }
                } else if !notificationDone && canSubmit() { // Mail installed, notification not accepted, sections completed
                    Text("Please accept the notification above to submit your application.")
                } else if !canSubmit() { // Mail installed, sections incomplete
                    Text("Please complete the form sections above to submit your application")
                }*/
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .navigationBarTitle("Editing", displayMode: .large)
        .onAppear(perform: {
            UIApplication.shared.addTapGestureRecognizer()
            UIScrollView.appearance().keyboardDismissMode = .onDrag
        })
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
        .sheet(isPresented: $sheetShowing) {
            if sheetType == .mailView {
                let clientName = "\(application.surname ?? "NIL"), \(application.firstNames ?? "NIL")"
                let recipients = [salesConsultantEmails[salesConsultant] ?? ""]
                MailView(clientName: clientName,
                         emailBody: makeEmailBody(application: application),
                         recipients: recipients,
                         attachments: getAttachments(application: application, scanGroup: scanGroup),
                         isShowing: self.$sheetShowing,
                         result: self.$result,
                         submitted: $submitted)
            }
        }
    }
    
    // MARK: - canSubmit
    private func canSubmit() -> Bool {
        if generalDetailsDone && personalDetailsDone && residencyContactDone && subsidyCreditDone && employmentDone && incomeDeductionsDone && expensesDone && assetsLiabilitiesDone {
            return true
        }
        
        return false
    }
}

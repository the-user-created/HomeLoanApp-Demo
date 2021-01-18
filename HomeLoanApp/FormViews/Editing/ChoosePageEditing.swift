//
//  ChoosePage.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/14.
//

import SwiftUI
import CoreData

struct ChoosePageEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var application: Application
    
    // MARK: - State Variables
    @State var assetsLiabilitiesDone: Bool = false
    @State var residencyContactDone: Bool = false
    @State var incomeDeductionsDone: Bool = false
    @State var personalDetailsDone: Bool = false
    @State var generalDetailsDone: Bool = false
    @State var subsidyCreditDone: Bool = false
    @State var notificationDone: Bool = false
    @State var employmentDone: Bool = false
    @State var expensesDone: Bool = false
    @State var scansDone: Bool = false
    
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
        self._scansDone = State(wrappedValue: self.application.scansDone)
    }
    
    // MARK: - body
    var body: some View {
        Form() {
            Group() {
                NavigationLink(destination: GeneralDetailsEditing(isDone: $generalDetailsDone, application: application, sender: .editor)) {
                    HStack() {
                        Text("General Details")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: generalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(generalDetailsDone ? .green: .red)
                    }
                }
                
                NavigationLink(destination: PersonalDetailsEditing(isDone: $personalDetailsDone, application: application, sender: .editor)) {
                    HStack() {
                        Text("Personal Details")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: personalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(personalDetailsDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: ResidencyContactEditing(isDone: $residencyContactDone, application: application, sender: .editor)) {
                    HStack() {
                        Text("Residency & Contact")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: residencyContactDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(residencyContactDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: SubsidyCreditEditing(isDone: $subsidyCreditDone, application: application, sender: .editor)) {
                    HStack() {
                        Text("Subsidy & Credit")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: subsidyCreditDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(subsidyCreditDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: EmploymentEditing(isDone: $employmentDone, application: application, sender: .editor)) {
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
                NavigationLink(destination: IncomeDeductionsEditing(isDone: $incomeDeductionsDone, application: application, sender: .editor)) {
                    HStack() {
                        Text("Income & Deductions")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: incomeDeductionsDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(incomeDeductionsDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: ExpensesEditing(isDone: $expensesDone, application: application, sender: .editor)) {
                    HStack() {
                        Text("Expenses")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: expensesDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(expensesDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: AssetsLiabilitiesEditing(isDone: $assetsLiabilitiesDone, application: application, sender: .editor)) {
                    HStack() {
                        Text("Assets & Liabilities")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: assetsLiabilitiesDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(assetsLiabilitiesDone ? .green: .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: DocumentScans(application: application, sender: .editor, isDone: $scansDone)) {
                    HStack() {
                        Text("Supporting Documents")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: scansDone ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(scansDone ? .green : .red)
                    }
                }
                .disabled(!generalDetailsDone)
            }
            
            NavigationLink(destination: NotificationView(application: application, isDone: $notificationDone)) {
                HStack() {
                    Text("Notification")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: notificationDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(notificationDone ? .green : .red)
                }
            }
            .disabled(!canSignOff())
                
            NavigationLink(destination: EmptyView()) {
                Text("Submit Application")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.blue)
            }
            .disabled(!canSignOff() && !notificationDone)
        }
        .navigationBarTitle("Editing", displayMode: .large)
    }
    
    // MARK: - canSignOff
    private func canSignOff() -> Bool {
        if generalDetailsDone && personalDetailsDone && residencyContactDone && subsidyCreditDone && employmentDone && incomeDeductionsDone && expensesDone && assetsLiabilitiesDone {
            return true
        }
        
        return false
    }
}

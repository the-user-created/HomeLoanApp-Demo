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
    @State var personalDetailsDone: Bool = false
    @State var generalDetailsDone: Bool = false
    @State var subsidyCreditDone: Bool = false
    @State var notificationDone: Bool = false
    @State var employmentDone: Bool = false
    @State var expensesDone: Bool = false
    @State var incomeDone: Bool = false
    
    init(application: Application) {
        self.application = application
        self._generalDetailsDone = State(wrappedValue: self.application.generalDetailsDone)
        self._personalDetailsDone = State(wrappedValue: self.application.personalDetailsDone)
    }
    
    // MARK: - body
    var body: some View {
        Form() {
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
            
            NavigationLink(destination: IncomeDeductionsEditing(isDone: $incomeDone, application: application, sender: .editor)) {
                HStack() {
                    Text("Income & Deductions")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: incomeDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(incomeDone ? .green: .red)
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
            
            NavigationLink(destination: NotificationView(application: application, isDone: $notificationDone)) {
                HStack() {
                    Text("Notification")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: notificationDone ? "checkmark.circle.fill": "checkmark.circle")
                        .foregroundColor(notificationDone ? .green: .red)
                }
            }
            .disabled(!canSignOff())
            
            Section() {
                NavigationLink(destination: EmptyView()) {
                    Text("Submit Application")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.blue)
                }
                .disabled(!canSignOff() && !notificationDone)
            }
        }
        .navigationBarTitle("Editing", displayMode: .large)
    }
    
    // MARK: - canSignOff
    private func canSignOff() -> Bool {
        if generalDetailsDone && personalDetailsDone && residencyContactDone && subsidyCreditDone && employmentDone && incomeDone && expensesDone && assetsLiabilitiesDone {
            return true
        }
        
        return false
    }
}

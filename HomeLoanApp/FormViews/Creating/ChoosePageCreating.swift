//
//  ChoosePageCreating.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/13.
//

import SwiftUI
import CoreData

struct ChoosePageCreating: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var applicationCreation: ApplicationCreation
    
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
    @State var scansDone: Bool = false
    
    @State var selection: Int?
    
    // MARK: - body
    var body: some View {
        Form() {
            // General Details
            Group() {
                if !applicationCreation.generalDetailsSaved {
                    NavigationLink(destination: GeneralDetails(isDone: $generalDetailsDone), tag: 0, selection: $selection) {
                        HStack() {
                            Text("General Details")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: generalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(generalDetailsDone ? .green: .red)
                        }
                    }
                } else {
                    NavigationLink(destination: GeneralDetailsEditing(isDone: $generalDetailsDone, application: applicationCreation.application, sender: .creator), tag: 1, selection: $selection) {
                        HStack() {
                            Text("General Details")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: generalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(generalDetailsDone ? .green: .red)
                        }
                    }
                }
            }
            
            // Personal Details
            Group() {
                if !applicationCreation.personalDetailsSaved {
                    NavigationLink(destination: PersonalDetails(isDone: $personalDetailsDone), tag: 2, selection: $selection) {
                        HStack() {
                            Text("Personal Details")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: personalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(personalDetailsDone ? .green: .red)
                        }
                    }
                    .disabled(!generalDetailsDone)
                } else {
                    NavigationLink(destination: PersonalDetailsEditing(isDone: $personalDetailsDone, application: applicationCreation.application, sender: .creator), tag: 3, selection: $selection) {
                        HStack() {
                            Text("Personal Details")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: personalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(personalDetailsDone ? .green: .red)
                        }
                    }
                }
            }
            
            // Residency & Contact
            Group() {
                if !applicationCreation.residencyContactSaved {
                    NavigationLink(destination: ResidencyContact(isDone: $residencyContactDone), tag: 4, selection: $selection) {
                        HStack() {
                            Text("Residency & Contact")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: residencyContactDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(residencyContactDone ? .green: .red)
                        }
                    }
                    .disabled(!generalDetailsDone)
                } else {
                    NavigationLink(destination: ResidencyContactEditing(isDone: $residencyContactDone, application: applicationCreation.application, sender: .creator), tag: 5, selection: $selection) {
                        HStack() {
                            Text("Residency & Contact")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: residencyContactDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(residencyContactDone ? .green: .red)
                        }
                    }
                }
            }
            
            // Subsidy & Credit
            Group() {
                if !applicationCreation.subsidyCreditSaved {
                    NavigationLink(destination: SubsidyCredit(isDone: $subsidyCreditDone), tag: 6, selection: $selection) {
                        HStack() {
                            Text("Subsidy & Credit")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: subsidyCreditDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(subsidyCreditDone ? .green: .red)
                        }
                    }
                    .disabled(!generalDetailsDone)
                } else {
                    NavigationLink(destination: SubsidyCreditEditing(isDone: $subsidyCreditDone, application: applicationCreation.application, sender: .creator), tag: 7, selection: $selection) {
                        HStack() {
                            Text("Subsidy & Credit")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: subsidyCreditDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(subsidyCreditDone ? .green: .red)
                        }
                    }
                }
            }
            
            // Employment
            Group() {
                if !applicationCreation.employmentSaved {
                    NavigationLink(destination: Employment(isDone: $employmentDone), tag: 8, selection: $selection) {
                        HStack() {
                            Text("Employment")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: employmentDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(employmentDone ? .green: .red)
                        }
                    }
                    .disabled(!generalDetailsDone)
                } else {
                    NavigationLink(destination: EmploymentEditing(isDone: $employmentDone, application: applicationCreation.application, sender: .creator), tag: 9, selection: $selection) {
                        HStack() {
                            Text("Employment")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: employmentDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(employmentDone ? .green: .red)
                        }
                    }
                }
            }
            
            // Income & Deductions
            Group() {
                if !applicationCreation.incomeSaved {
                    NavigationLink(destination: IncomeDeductions(isDone: $incomeDone), tag: 10, selection: $selection) {
                        HStack() {
                            Text("Income & Deductions")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: incomeDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(incomeDone ? .green: .red)
                        }
                    }
                    .disabled(!generalDetailsDone)
                } else {
                    NavigationLink(destination: IncomeDeductionsEditing(isDone: $incomeDone, application: applicationCreation.application, sender: .creator), tag: 11, selection: $selection) {
                        HStack() {
                            Text("Income & Deductions")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: incomeDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(incomeDone ? .green: .red)
                        }
                    }
                }
            }
            
            // Expenses
            Group() {
                if !applicationCreation.expensesSaved {
                    NavigationLink(destination: Expenses(isDone: $expensesDone), tag: 12, selection: $selection) {
                        HStack() {
                            Text("Expenses")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: expensesDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(expensesDone ? .green: .red)
                        }
                    }
                    .disabled(!generalDetailsDone)
                } else {
                    NavigationLink(destination: ExpensesEditing(isDone: $expensesDone, application: applicationCreation.application, sender: .creator), tag: 13, selection: $selection) {
                        HStack() {
                            Text("Expenses")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: expensesDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(expensesDone ? .green: .red)
                        }
                    }
                }
            }
            
            // Assets & Liabilities
            Group() {
                if !applicationCreation.assetsLiabilitiesSaved {
                    NavigationLink(destination: AssetsLiabilities(isDone: $assetsLiabilitiesDone), tag: 14, selection: $selection) {
                        HStack() {
                            Text("Assets & Liabilities")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: assetsLiabilitiesDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(assetsLiabilitiesDone ? .green: .red)
                        }
                    }
                    .disabled(!generalDetailsDone)
                } else {
                    NavigationLink(destination: AssetsLiabilitiesEditing(isDone: $assetsLiabilitiesDone, application: applicationCreation.application, sender: .creator), tag: 15, selection: $selection) {
                        HStack() {
                            Text("Assets & Liabilities")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: assetsLiabilitiesDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(assetsLiabilitiesDone ? .green: .red)
                        }
                    }
                }
            }
            
            // Notification & Warranty, Document Scans
            Group() {
                NavigationLink(destination: DocumentScans(application: applicationCreation.application, sender: .creator, isDone: $scansDone), tag: 16, selection: $selection) {
                    HStack() {
                        Text("Supporting Documents")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: scansDone ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(scansDone ? .green : .red)
                    }
                }
                .disabled(!generalDetailsDone)
                
                NavigationLink(destination: NotificationView(application: applicationCreation.application, isDone: $notificationDone), tag: 17, selection: $selection) {
                    HStack() {
                        Text("Notification")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: notificationDone ? "checkmark.circle.fill": "checkmark.circle")
                            .foregroundColor(notificationDone ? .green: .red)
                    }
                }
                .disabled(!canSignOff())
            }
            
            // Submit Application
            NavigationLink(destination: EmptyView(), tag: 18, selection: $selection) {
                Text("Submit Application")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.blue)
            }
            .disabled(!canSignOff() && !notificationDone)
        }
        .navigationBarTitle("Creating", displayMode: .large)
    }
    
    // MARK: - canSignOff
    private func canSignOff() -> Bool {
        if generalDetailsDone && personalDetailsDone && residencyContactDone && subsidyCreditDone && employmentDone && incomeDone && expensesDone && assetsLiabilitiesDone {
            return true
        }
        
        return false
    }
}

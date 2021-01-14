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
    @State var employmentDone: Bool = false
    @State var expensesDone: Bool = false
    @State var incomeDone: Bool = false
    
    // MARK: - body
    var body: some View {
        Form() {
            // General Details
            Group() {
                if !applicationCreation.generalDetailsSaved {
                    NavigationLink(destination: GeneralDetails(isDone: $generalDetailsDone)) {
                        HStack() {
                            Text("General Details")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: generalDetailsDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(generalDetailsDone ? .green: .red)
                        }
                    }
                } else {
                    NavigationLink(destination: GeneralDetailsEditing(isDone: $generalDetailsDone,
                                                                      application: applicationCreation.application,
                                                                      sender: .creator)) {
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
                    NavigationLink(destination: PersonalDetails(isDone: $personalDetailsDone)) {
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
                    NavigationLink(destination: PersonalDetailsEditing(isDone: $personalDetailsDone,
                                                                       application: applicationCreation.application,
                                                                       sender: .creator)) {
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
                    NavigationLink(destination: ResidencyContact(isDone: $residencyContactDone)) {
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
                    NavigationLink(destination: ResidencyContactEditing(isDone: $residencyContactDone,
                                                                        application: applicationCreation.application,
                                                                        sender: .creator)) {
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
                    NavigationLink(destination: SubsidyCredit(isDone: $subsidyCreditDone)) {
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
                    NavigationLink(destination: SubsidyCreditEditing(isDone: $subsidyCreditDone,
                                                                     application: applicationCreation.application,
                                                                     sender: .creator)) {
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
                    NavigationLink(destination: Employment(isDone: $employmentDone)) {
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
                    NavigationLink(destination: EmploymentEditing(isDone: $employmentDone, application: applicationCreation.application, sender: .creator)) {
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
            
            // Income
            Group() {
                if !applicationCreation.incomeSaved {
                    NavigationLink(destination: Income(isDone: $incomeDone)) {
                        HStack() {
                            Text("Income")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: incomeDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(incomeDone ? .green: .red)
                        }
                    }
                    .disabled(!generalDetailsDone)
                } else {
                    NavigationLink(destination: IncomeEditing(isDone: $incomeDone, application: applicationCreation.application, sender: .creator)) {
                        HStack() {
                            Text("Income")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: incomeDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(incomeDone ? .green: .red)
                        }
                    }
                }
            }
            
            // Income
            Group() {
                if !applicationCreation.expensesSaved {
                    NavigationLink(destination: Expenses(isDone: $expensesDone)) {
                        HStack() {
                            Text("Income")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: expensesDone ? "checkmark.circle.fill": "checkmark.circle")
                                .foregroundColor(expensesDone ? .green: .red)
                        }
                    }
                    .disabled(!generalDetailsDone)
                } else {
                    NavigationLink(destination: ExpensesEditing(isDone: $expensesDone, application: applicationCreation.application, sender: .creator)) {
                        HStack() {
                            Text("Income")
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
                    NavigationLink(destination: AssetsLiabilities(isDone: $assetsLiabilitiesDone)) {
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
                    NavigationLink(destination: AssetsLiabilitiesEditing(isDone: $assetsLiabilitiesDone, application: applicationCreation.application, sender: .creator)) {
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
            
            // Notification & Warranty
            
            Section() {
                NavigationLink(destination: EmptyView()) {
                    Text("Submit Application")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.blue)
                }
                .disabled(true)
            }
        }
        .navigationBarTitle("Creating", displayMode: .large)
    }
}

//
//  LoanView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/23.
//

import SwiftUI
import CoreData
import MessageUI

struct LoanView: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.openURL) var openURL
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    @FetchRequest(entity: Application.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Application.loanCreatedDate, ascending: false)]
    ) var applications: FetchedResults<Application>
    
    // MARK: - State Variables
    @State private var makingApplication: Bool = false
    @State private var editingApplication: Int?
    @State private var showingAlert: Bool = false
    @State private var alertText: String = ""
    @State private var alertURL: String = ""
    
    // MARK: - Properties
    var date: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_ZA")
        return formatter
    }
    
    // MARK: - body
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ChoosePageCreating(), isActive: self.$makingApplication) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                        
                        Text("New Application")
                            .foregroundColor(.blue)
                    }
                }
                
                ForEach(applications) { application in
                    NavigationLink(destination: ChoosePageEditing(application: application)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Application created on \(date.string(from: application.loanCreatedDate ?? Date()))")
                                    .font(.headline)
                                
                                Text("Status: \(application.loanStatus ?? "")")
                                    .font(.subheadline)
                                
                            }
                            
                            Spacer()
                            
                            Text("Edit")
                                .foregroundColor(.blue)
                            
                        }
                        .frame(height: 50)
                    }
                }
                .onDelete(perform: deleteApplication)
            }
            .onChange(of: makingApplication) { _ in
                if !makingApplication {
                    print("print - cleaned changedValues and removed application from memory")
                    applicationCreation.removeApplicationFromMemory()
                    changedValues.cleanChangedValues()
                } else if makingApplication {
                    if !MFMailComposeViewController.canSendMail() {
                        alertText = "To submit a loan application you must get the Mail app. Please download Mail from the app store."
                        alertURL = "https://apps.apple.com/za/app/mail/id1108187098"
                        showingAlert = true
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Loan Applications")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("WARNING"), message: Text(alertText), primaryButton: .default(Text("Get Mail"), action: { openURL(URL(string: alertURL)!) }), secondaryButton: .cancel())
        }
    }
    
    // MARK: - deleteApplication
    private func deleteApplication(at offsets: IndexSet) {
      // 1.
      offsets.forEach { index in
        // 2.
        let application = applications[index]

        // 3.
        viewContext.delete(application)
      }

      // 4.
      saveContext()
    }
    
    // MARK: - saveContext()
    private func saveContext() {
      do {
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
}

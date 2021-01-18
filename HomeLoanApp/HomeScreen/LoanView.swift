//
//  LoanView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/23.
//

import SwiftUI
import CoreData
import Combine

struct LoanView: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    @FetchRequest(entity: Application.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Application.loanCreatedDate, ascending: false)]
    ) var applications: FetchedResults<Application>
    
    // MARK: - State Variables
    @State private var makingApplication: Bool = false
    @State private var editingApplication: Int?
    
    // MARK: - body
    var body: some View {
        NavigationView() {
            List() {
                NavigationLink(destination: ChoosePageCreating(),
                               isActive: self.$makingApplication) {
                    HStack() {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                        
                        Text("New Application")
                            .foregroundColor(.blue)
                    }
                }
                
                ForEach(applications) { application in
                    NavigationLink(destination: ChoosePageEditing(application: application),
                                   tag: applications.firstIndex(of: application) ?? 0,
                                   selection: self.$editingApplication) {
                        HStack() {
                            VStack(alignment: .leading) {
                                Text("Application created on \(application.loanCreatedDate ?? Date(), formatter: dateFormatter)")
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
                }
            }
            .onChange(of: editingApplication) { _ in
                if editingApplication == nil {
                    print("print - cleaned changedValues")
                    changedValues.cleanChangedValues()
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Loan Applications")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - deleteApplication
    private func deleteApplication(at offsets: IndexSet) {
      // 1.
      offsets.forEach { index in
        // 2.
        let application = self.applications[index]

        // 3.
        self.viewContext.delete(application)
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

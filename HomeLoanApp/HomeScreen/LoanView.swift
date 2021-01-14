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
    
    @FetchRequest(entity: Application.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Application.loanCreatedDate, ascending: false)]
    ) var applications: FetchedResults<Application>
    
    // MARK: - State Variables
    @State private var makingApplication: Bool = false
    
    // MARK: - body
    var body: some View {
        NavigationView() {
            List() {
                NavigationLink(destination: ChoosePageCreating(), //GeneralDetails(),
                               isActive: self.$makingApplication) {
                    HStack() {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                        
                        Text("New Application")
                            .foregroundColor(.blue)
                    }
                }
                .onChange(of: makingApplication) { _ in
                    if !makingApplication {
                        applicationCreation.removeApplicationFromMemory()
                    }
                }
                
                ForEach(applications, id: \.self) { application in
                    NavigationLink(destination: ChoosePageEditing(application: application)) {
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
                    }
                    .frame(height: 50)
                }
                .onDelete(perform: deleteApplication)
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

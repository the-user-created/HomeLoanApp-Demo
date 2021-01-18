//
//  NotificationWarranty.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/01.
//

import SwiftUI

struct NotificationView: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @ObservedObject var application: Application
    @EnvironmentObject var changedValues: ChangedValues
    
    // MARK: - State Variables
    @State var notificationsCheck = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    
    // MARK: - body
    var body: some View {
        List() {
            Section(header: Text("Notification")) {
                Text("Applicant/s are aware that:")
                    .font(.subheadline)
                
                RichText("a) *evo* is a home loan originator and will be making home loan application on the applicant's behalf. The applicant as requested *evo* to proceed with such application;")
                    .font(.subheadline)
                
                RichText("b) Personal, financial and other information is furnished to *evo* for the purposes of the making of such application, and applicants are aware that they are required to furnish all such information truthfully and fully;")
                    .font(.subheadline)
                
                RichText("c) Communications (including the quotation) from the bank(s) pertaining to such application will be received by *evo* on the applicants behalf. Applicants are further aware that, where appropriate, the estate agent concerned may be issued by *evo* with a copy of the final outcome.")
                    .font(.subheadline)
                
                RichText("d) *evo* and third parties, including banks, may make enquiries to third parties to confirm any information submitted as part of the application, and may obtain information from credit bureaux when assessing this home loan application for finance.")
                    .font(.subheadline)
                
                RichText("e) I/we hold no other citizenships and residencies for local and international tax purposes, other than those disclosed in this application form and will inform the lender in writing of any change of this status within 30 days of the change of status.")
                    .font(.subheadline)
                
                FormYesNo(iD: "notificationsCheck",
                          question: "Do you agree to all notifications",
                          selected: $notificationsCheck)
                    .padding([.top], 10)
            }
            
            Section(header: Text("Signature")) {
                SignatureView()
                    .frame(height: 300)
                    .buttonStyle(BorderlessButtonStyle())
            }
            
            Divider()
            
            Section() {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
                .disabled(notificationsCheck.lowercased() == "yes" ? false : true)
            }
        }
        .navigationBarTitle("Notification")
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        if notificationsCheck.lowercased() == "yes" {
            return true
        }
        
        return false
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if !changedValues.changedValues.isEmpty {
            isDone = determineComplete()
            saveApplication()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - saveApplication
    private func saveApplication() {
        applicationCreation.application.notificationsCheck = notificationsCheck
        
        do {
            try viewContext.save()
            print("print - Application Entity Updated")
            applicationCreation.notificationSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

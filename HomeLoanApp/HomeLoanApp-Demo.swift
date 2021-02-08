//
//  HomeLoanAppApp.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/22.
//

import Foundation
import Combine
import SwiftUI
import CoreData
////import Firebase
////import FirebaseAuth

// MARK: - Main
@main
struct HomeLoanApp: App {
    let persistenceController = PersistenceController.shared
    //var userDetails = UserDetails()
    //var settings = UserSettings()
    var applicationCreation = ApplicationCreation()
    var changedValues = ChangedValues()
    
    /*init() {
        FirebaseApp.configure()
    }*/
    
    var body: some Scene {
        WindowGroup {
            Main()//userDetails: userDetails)
                //.environmentObject(settings)
                .environmentObject(applicationCreation)
                .environmentObject(changedValues)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct Main: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var applicationCreation: ApplicationCreation
    //@EnvironmentObject var settings: UserSettings
    //@ObservedObject var userDetails: UserDetails
    
    var body: some View {
        TabSelectionView()//userDetails: userDetails)
        
        /*if self.settings.loggedIn {
            let user = Auth.auth().currentUser
                
            self.userDetails.email = user?.email ?? "nil"
            
            if let displayName = user?.displayName {
                let openBracketIndices = findNth("[", text: displayName)
                let closeBracketIndices = findNth("]", text: displayName)
                
                if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                    self.userDetails.firstNames = String(displayName[displayName.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]])
                    self.userDetails.surname = String(displayName[displayName.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]])
                }
            }
            
            return AnyView(HomeTabView(userDetails: userDetails))
        } else {
            return AnyView(LoginView())
        }*/
    }
}

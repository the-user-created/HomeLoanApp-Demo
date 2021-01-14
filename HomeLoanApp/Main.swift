//
//  Main.swift
//  HomeLoanApp
//
//  Created by David Young on 2021/01/12.
//

import SwiftUI
import CoreData
import Firebase

struct Main: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var userDetails: UserDetails
    
    var body: some View {
        if self.settings.loggedIn {
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
        }
    }
    
    private func increment(_ value: Int) -> Int {
        let value = value + 1
        return value
    }
}


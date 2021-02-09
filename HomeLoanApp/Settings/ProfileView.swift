//
//  ProfileScene.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/22.
//

import SwiftUI
import CoreData
//import Firebase

struct ProfileView: View {
    // MARK: - Wrapped Objects
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var userDetails: UserDetails
    
    // MARK: - State Variables
    @State var uid: String = ""
    @State var email: String = ""
    @State var displayName: String? = ""
    @State private var firstNames: String = ""
    @State private var surname: String = ""
    @State private var nameString: String = ""
    
    @State var isEditingAccount: Bool = false
    
    // MARK: - init
    init(userDetails: UserDetails) {
        self.userDetails = userDetails
        self._email = State(wrappedValue: userDetails.email)
        self._firstNames = State(wrappedValue: userDetails.firstNames)
        self._surname = State(wrappedValue: userDetails.surname)
        self._nameString = State(wrappedValue: "\(firstNames) \(surname)")
    }
    
    // MARK: - body
    var body: some View {
        List {
            if !userDetails.firstNames.isEmpty || !userDetails.surname.isEmpty {
                Text("\(userDetails.firstNames) \(userDetails.surname)")
                    .font(.title2)
            } else {
                Text("No name registered")
            }
            
            if let email = email {
                Text(email)
            } else {
                Text("No email registered")
            }
            
            NavigationLink(destination: EditAccount(userDetails: userDetails, firstNames: $firstNames, surname: $surname, email: $email),
                           isActive: $isEditingAccount) {
                Text("Edit account details")
                    .foregroundColor(.blue)
            }
            
            /*Button(action: {
                let user = Auth.auth().currentUser
                
                user?.delete { error in
                    if let error = error {
                        print("print - Error occurred while deleting account \(error)")
                        return
                    }
                    
                    print("print - Deleted account")
                    self.settings.loggedIn = false
                    UserDefaults.standard.setValue(false, forKey: "loggedIn")
                }
            }) {
                Text("Delete my Account")
                    .foregroundColor(.red)
            }*/
        }
        .navigationBarTitle("Profile")
    }
}

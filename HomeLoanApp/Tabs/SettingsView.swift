//
//  SettingsView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/23.
//

import SwiftUI
//import Firebase

struct Setting: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
}

struct SettingRow: View {
    var setting: Setting
    
    var body: some View {
        HStack {
            Image(systemName: setting.imageName)
            Text(setting.name)
        }
    }
}

struct SettingsView: View {
    // MARK: - Wrapped Objects
    //@EnvironmentObject var settings: UserSettings
    //@ObservedObject var userDetails: UserDetails
    
    // MARK: - State Variables
    @State var profileViewShowing: Bool = false
    @State var notifViewShowing: Bool = false
    @State var tellAFriendViewShowing: Bool = false
    @State var helpViewShowing: Bool = false
    @State var aboutViewShowing: Bool = false
    @State var privacyViewShowing: Bool = false
    
    // MARK: - Properties
    var settingsItems: [Setting] = [
        Setting(name: "Profile", imageName: "person.fill"),
        Setting(name: "Notifications", imageName: "exclamationmark.square.fill"),
        Setting(name: "Tell a Friend", imageName: "heart.fill"),
        Setting(name: "Help", imageName: "questionmark.square.fill"),
        Setting(name: "About", imageName: "info.circle"),
        Setting(name: "Privacy Policy", imageName: "info.circle")
    ]
    
    // MARK: - body
    var body: some View {
        NavigationView() {
            List() {
                /*NavigationLink(destination: ProfileView(userDetails: userDetails), isActive: $profileViewShowing) {
                    SettingRow(setting: settingsItems[0])
                }
                
                NavigationLink(destination: NotificationsScene(), isActive: $notifViewShowing) {
                    SettingRow(setting: settingsItems[1])
                }
                
                NavigationLink(destination: TellAFriendScene(), isActive: $tellAFriendViewShowing) {
                    SettingRow(setting: settingsItems[2])
                }
                
                NavigationLink(destination: HelpScene(), isActive: $helpViewShowing) {
                    SettingRow(setting: settingsItems[3])
                }*/
                
                NavigationLink(destination: AboutScene(), isActive: $aboutViewShowing) {
                    SettingRow(setting: settingsItems[4])
                }
                
                NavigationLink(destination: PrivacyPolicyView(), isActive: $privacyViewShowing) {
                    SettingRow(setting: settingsItems[5])
                }
                
                /*HStack() {
                    Spacer()
                    
                    Button(action: {
                        let firebaseAuth = Auth.auth()
                        
                        do {
                            try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                            print("Error signing out: \(signOutError)")
                        }
                        
                        self.settings.loggedIn = false
                        UserDefaults.standard.setValue(false, forKey: "loggedIn")
                        print("print - Logged Out")
                    }) {
                        BackgroundForButton(btnText: "LOG OUT", btnColor: .blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()
                }
                .padding()*/
            }
            .navigationBarTitle("Details")
        }
    }
    
    /*private func handleUser() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let name = user?.displayName {
                self.displayName = name
            }
            
            if let email = user?.email {
                self.email = email
            }
            
            if let uid = user?.uid {
                self.userUID = uid
            }
            
            if let newUser = user {
                for info in newUser.multiFactor.enrolledFactors {
                    multiFactorString += info.description + " "
                }
            }
        }
    }*/
}

//
//  EditAccount.swift
//  HomeLoanApp
//
//  Created by David Young on 2021/01/09.
//

import SwiftUI
//import Firebase

// MARK: - EmailTextField
struct EmailTextField: View {
    // MARK: - State Variables
    @Binding var text: String
    
    // MARK: - Properties
    var placeholder: String
    var textColor: Color = .primary
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    // MARK: - body
    var body: some View {
        let binding = Binding<String>(get: {
            self.text
        }, set: {
            self.text = $0.lowercased()
        })
        
        TextField(placeholder, text: binding, onEditingChanged: editingChanged, onCommit: commit)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}

// MARK: - NameTextField
struct NameTextField: View {
    // MARK: - State Variables
    @Binding var text: String
    
    // MARK: - Properties
    var placeholder: String
    var textColor: Color = .primary
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    // MARK: - body
    var body: some View {
        TextField(placeholder, text: $text, onEditingChanged: editingChanged, onCommit: commit)
            .autocapitalization(.words)
            .disableAutocorrection(true)
    }
}

// MARK: - EditAccount
struct EditAccount: View {
    // MARK: - Wrapped Objects
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userDetails: UserDetails
    
    // MARK: - State Variables
    @Binding var firstNames: String
    @Binding var surname: String
    @Binding var email: String
    @State var password: String = ""
    @State var emailChangeSuccess: Bool? = nil
    @State var nameChangeSuccess: Bool? = nil
    @State var reauthenticationSuccess: Bool? = nil
    
    @State private var alertIsShowing: Bool = false
    @State private var userAuthSignIn: Bool = false
    
    @State private var firstNamesChanged: Bool = false
    @State private var surnameChanged: Bool = false
    @State private var emailChanged: Bool = false
    
    // MARK: - init
    /*init(userDetails: UserDetails, firstNames: Binding<String>, surname: Binding<String>, email: Binding<String>) {
        print("print - EditAccount: \(userDetails.firstNames), \(userDetails.surname), \(userDetails.email)")
        self.userDetails = userDetails
        self._firstNames = firstNames
        self._surname = surname
        self._email = email
    }*/
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("Full Name")) {
                NameTextField(text: $firstNames, placeholder: "First names...")
                    .onChange(of: firstNames) { _ in
                        firstNamesChanged = true
                    }
                
                NameTextField(text: $surname, placeholder: "Surname...")
                    .onChange(of: surname) { _ in
                        surnameChanged = true
                    }
            }
            
            Section(header: Text("Email")) {
                EmailTextField(text: $email, placeholder: "Email...")
                    .onChange(of: email) { _ in
                        emailChanged = true
                    }
            }
            
            Section() {
                HStack() {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            changeDetails()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Save Changes")
                            .font(.title2)
                    }
                    
                    Spacer()
                }
            }
        }
        /*.onAppear() {
            print("print - EditAccount appear: \(userDetails.firstNames), \(userDetails.surname), \(userDetails.email)")
        }
        .onDisappear() {
            print("print - EditAccount disappear: \(userDetails.firstNames), \(userDetails.surname), \(userDetails.email)")
        }*/
        .buttonStyle(BorderlessButtonStyle())
        .alert(isPresented: $alertIsShowing, content: {
            Alert(title: Text(""), message: Text("There was a problem updating your account details. Please try again later."), dismissButton: .default(Text("OK")))
        })
        .textFieldAlert(isShowing: $userAuthSignIn,
                        text: $password,
                        title: "Please enter your password to change your email...",
                        isPasswordAlert: true)
    }
    
    // MARK: - changeDetails
    private func changeDetails() {
        /*if emailChanged {
            changeEmail()
        }
        
        if firstNamesChanged || surnameChanged {
            print("print - Changing display name")
            changeDisplayName()
        }*/
        
        if !(nameChangeSuccess ?? true) || !(emailChangeSuccess ?? true) {
            alertIsShowing = true
            print("print - Failed to save account changes")
        } else if emailChanged && firstNamesChanged && surnameChanged {
            print("print - No account detail changes")
        } else {
            print("print - Saved account changes")
        }
        
        //presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: - changeDisplayName
    /*private func changeDisplayName() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "[\(self.firstNames)][\(self.surname)]"
        changeRequest?.commitChanges { (error) in
            if error != nil {
                print("print - \(String(describing: error?.localizedDescription))")
                nameChangeSuccess = false
            } else {
                print("print - displayName changed successfully")
                userDetails.firstNames = firstNames
                userDetails.surname = surname
                nameChangeSuccess = true
            }
        }
    }
    
    // MARK: - changeEmail
    private func changeEmail() {
        userAuthSignIn = true
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user?.reauthenticate(with: credential) { error, val  in
            if let error = error {
                // Authentication failed
                print(error)
                print("print - Error during re-authentication")
                reauthenticationSuccess = false
                emailChangeSuccess = false
            } else {
                // User re-authenticated
                user?.updateEmail(to: email) { error in
                    if error == nil {
                        print(String(describing: error?.localizedDescription))
                        emailChangeSuccess = false
                    } else {
                        print("print - Email changed successfully")
                        userDetails.email = email
                        emailChangeSuccess = true
                    }
                }
            }
        }
    }*/
}

/*struct EditAccount_Previews: PreviewProvider {
    static var previews: some View {
        EditAccount(displayName: "", email: "")
            .previewDevice("iPhone 12 Pro")
            .preferredColorScheme(.dark)
    }
}*/

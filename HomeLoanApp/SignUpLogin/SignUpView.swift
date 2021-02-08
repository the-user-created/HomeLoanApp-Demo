//
//  SignUpView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/25.
//

import SwiftUI
//import Firebase
//import FirebaseFirestore

struct SignUpView: View {
    // MARK: - Wrapped Objects
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: UserSettings
    
    // MARK: - State Variables
    @State private var firstNames: String = ""
    @State private var surname: String = ""
    @State private var emailConfirmation = ""
    @State private var showPassword = false
    @State private var invalidFirstNamesAttempts = 0
    @State private var invalidSurnameAttempts = 0
    @State private var invalidEmailAttempts = 0
    @State private var invalidEmailConfirmAttempts = 0
    @State private var invalidPasswordAttempts = 0
    @State private var isSigningUp: Bool = false
    @State private var signUpUnsuccessful: Bool = false
    @State private var alertMessage: String = ""
    
    @Binding var email: String
    @Binding var password: String
    
    // MARK: - body
    var body: some View {
        LoadingView(isShowing: $isSigningUp) {
            VStack(spacing: 15) {
                // Clients name
                HStack() {
                    HStack {
                        CustomTextField(placeholder: "First Names...",
                                        textColor: .black,
                                        text: $firstNames)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Capsule().fill(Color.white))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(invalidFirstNamesAttempts == 0 ? Color.clear : Color.red,
                                    style: StrokeStyle(lineWidth: 3))
                            .cornerRadius(22.0))
                    .padding(.leading)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .modifier(ShakeEffect(animatableData: CGFloat(invalidFirstNamesAttempts)))
                    
                    HStack {
                        CustomTextField(
                            placeholder: "Surname...",
                            textColor: .black,
                            text: $surname)
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                    }
                    .padding()
                    .background(Capsule().fill(Color.white))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(invalidSurnameAttempts == 0 ? Color.clear : Color.red,
                                    style: StrokeStyle(lineWidth: 3))
                            .cornerRadius(22.0))
                    .padding(.trailing)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .modifier(ShakeEffect(animatableData: CGFloat(invalidSurnameAttempts)))
                }
                
                // Email
                HStack() {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    CustomTextField(
                        placeholder: "Email...",
                        textColor: .black,
                        text: $email)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Capsule().fill(Color.white))
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(invalidEmailAttempts == 0 ? Color.clear : Color.red,
                                style: StrokeStyle(lineWidth: 3))
                        .cornerRadius(22.0))
                .padding([.leading, .trailing])
                .cornerRadius(20.0)
                .shadow(radius: 10.0, x: 20, y: 10)
                .modifier(ShakeEffect(animatableData: CGFloat(invalidEmailAttempts)))
                
                // Email confirmation
                HStack() {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    CustomTextField(
                        placeholder: "Confirm Email...",
                        textColor: .black,
                        text: $emailConfirmation)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Capsule().fill(Color.white))
                .overlay(Capsule(style: .continuous)
                            .stroke(invalidEmailConfirmAttempts == 0 ? Color.clear : Color.red,
                                    style: StrokeStyle(lineWidth: 3))
                            .cornerRadius(22.0))
                .padding([.leading, .trailing])
                .cornerRadius(20.0)
                .shadow(radius: 10.0, x: 20, y: 10)
                .modifier(ShakeEffect(animatableData: CGFloat(invalidEmailConfirmAttempts)))
                
                // Password
                PasswordTextField(showPassword: $showPassword, password: $password)
                .padding()
                .background(Capsule().fill(Color.white))
                .overlay(Capsule(style: .continuous)
                            .stroke(invalidPasswordAttempts == 0 ? Color.clear : Color.red,
                                    style: StrokeStyle(lineWidth: 3))
                            .cornerRadius(22.0))
                .padding([.leading, .trailing])
                .cornerRadius(20.0)
                .shadow(radius: 10.0, x: 20, y: 10)
                .modifier(ShakeEffect(animatableData: CGFloat(invalidPasswordAttempts)))
                
                Text("Between 8 and 32 characters")
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                
                Button(action: {
                    isSigningUp = true
                    //signUp()
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.init(hex: "cc0944"))
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }
                .padding([.top, .bottom], 30)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("LSImage")
                    .resizable()
                    .ignoresSafeArea(.all))
            .edgesIgnoringSafeArea(.all)
        }
        .alert(isPresented: $signUpUnsuccessful, content: {
            Alert(title: Text("Sign Up Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        })
    }
    
    // MARK: - signUp
    /*private func signUp() {
        withAnimation(.default) {
            let namePassChecked = checkNameAndPass()
            let emailChecked = checkEmails()
            
            if emailChecked && namePassChecked {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    guard let user = authResult?.user, error == nil else {
                        signUpUnsuccessful = true
                        isSigningUp = false
                        alertMessage = error!.localizedDescription
                        print("\(error!)")
                        return
                    }
                    
                    // Check if this is a first time sign in for the user
                    let isNewUser: Bool? = authResult?.additionalUserInfo?.isNewUser
                    if isNewUser ?? false {
                        // Change the displayName of the user from `null` to `[firstNames][surname]`
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = "[\(firstNames)][\(surname)]"
                        changeRequest.commitChanges { changeRequestErr in
                            if let changeRequestErr = changeRequestErr {
                                signUpUnsuccessful = true
                                isSigningUp = false
                                print("print - \(String(describing: error))")
                                alertMessage = changeRequestErr.localizedDescription
                                return
                            }
                            
                            // Profile change request successful
                            // Add the user document to firestore
                            let database = Firestore.firestore()
                            // Create the document and collection
                            database.collection("users").document(user.uid).setData([
                                "lastUpdated": FieldValue.serverTimestamp(),
                                "uid": user.uid,
                                "email": user.email as Any,
                                "displayName": "[\(firstNames)][\(surname)]",
                                "firstNames": firstNames,
                                "surname": surname,
                                "accountCreated": Date(),
                                "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as Any,
                                "iOSVersion": UIDevice.current.systemVersion,
                                "iPhoneModel": UIDevice.modelName
                            ]) { error in
                                if let error = error {
                                    signUpUnsuccessful = true
                                    isSigningUp = false
                                    alertMessage = error.localizedDescription
                                    print("print - Error adding user: \(error)")
                                    return
                                }
                                // Added user document successfully
                            }
                            
                            // Log the user into the App
                            print("print - Logged \(user.email ?? "nil") in")
                            self.settings.loggedIn = true // Needed to switch from SignUpView to HomeView
                            UserDefaults.standard.setValue(true, forKey: "loggedIn") // Setting the default for when the app starts again
                        }
                    }
                }
            } else {
                isSigningUp = false
            }
        }
    }*/
    
    // MARK: - checkNameAndPass
    private func checkNameAndPass() -> Bool {
        if firstNames == "" {
            invalidFirstNamesAttempts += 1
        } else {
            invalidFirstNamesAttempts = 0
        }
        
        if surname == "" {
            invalidSurnameAttempts += 1
        } else {
            invalidSurnameAttempts = 0
        }
        
        if password == "" || password.count < 8 || password.count > 32 {
            invalidPasswordAttempts += 1
        } else {
            invalidPasswordAttempts = 0
        }
        
        // Checks if the name, surname and password fit base criteria
        if [invalidFirstNamesAttempts, invalidSurnameAttempts, invalidPasswordAttempts].elementsEqual([0, 0, 0]) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - checkEmails
    private func checkEmails() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCorrect: Bool = NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
        let emailConfirmCorrect: Bool = NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: emailConfirmation)
        
        if emailCorrect {
            invalidEmailAttempts = 0
        }
        
        if emailConfirmCorrect && email == emailConfirmation {
            invalidEmailConfirmAttempts = 0
            return true
        }
        
        if email == "" {
            invalidEmailAttempts += 1
            if emailConfirmation == "" {
                invalidEmailConfirmAttempts += 1
            }
            
        } else if emailConfirmation == "" {
            invalidEmailConfirmAttempts += 1
            
        } else if !emailCorrect && !emailConfirmCorrect {
            invalidEmailAttempts += 1
            invalidEmailConfirmAttempts += 1
            
        } else if !emailCorrect {
            invalidEmailAttempts += 1
            
        } else if !emailConfirmCorrect {
            invalidEmailConfirmAttempts += 1
            
        } else if email != emailConfirmation {
            // Change to zero because we assume that the initial email is correct
            invalidEmailAttempts = 0
            invalidEmailConfirmAttempts += 1
            
        } else {
            invalidEmailAttempts = 0
            invalidEmailConfirmAttempts = 0
            
            return true
        }
        
        return false
    }
}

// MARK: - Previews
/*struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}*/

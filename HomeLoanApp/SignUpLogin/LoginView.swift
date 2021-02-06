//
//  LoginView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/24.
//

import SwiftUI
//import Firebase

struct LoginView: View {
    // MARK: - Wrapped Objects
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.displayScale) var displayScale
    @EnvironmentObject var settings: UserSettings
    
    // MARK: - State Variables
    @State var firstNames: String = ""
    @State var surname: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var alertMessage: String = ""
    @State var showForgotPassword: Bool = false
    @State var showSignUp: Bool = false
    @State var showPassword: Bool = false
    
    @State private var isLoggingIn: Bool = false
    @State private var signInUnsuccessful: Bool = false
    @State private var hasForgotPassword: Bool = false
    
    // MARK: - body
    var body: some View {
        LoadingView(isShowing: $isLoggingIn) {
            ZStack {
                Image("LSImage")
                    .resizable()
                    .ignoresSafeArea(.all)
                
                VStack() {
                    Image("LSLogo")
                        .resizable()
                        .frame(width: 350, height: 190)
                        .shadow(radius: 10.0, x: 20, y: 10)
                    
                    Text("Login or Sign Up")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .opacity(0.8)
                        .padding([.top, .bottom], 20)
                        .shadow(radius: 10.0, x: 20, y: 10)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // Email
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                            
                            CustomTextField(placeholder: "Email...",
                                            textColor: .black,
                                            text: self.$email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(UITextAutocapitalizationType.none)
                        }
                        .padding()
                        .background(Capsule().fill(Color.white))
                        .cornerRadius(20.0)
                        .padding([.leading, .trailing])
                        .shadow(radius: 10.0, x: 20, y: 10)
                        
                        // Password
                        PasswordTextField(showPassword: $showPassword,
                                          password: $password)
                            .padding()
                            .background(Capsule().fill(Color.white))
                            .cornerRadius(20.0)
                            .padding([.leading, .trailing])
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                self.hasForgotPassword = true
                            }) {
                                Text("Forgot Password?")
                                    .foregroundColor(.black)
                                    .bold()
                            }
                            .sheet(isPresented: self.$showForgotPassword) {
                                EmptyView()
                            }
                        }
                        .padding(.trailing)
                    }
                    
                    Button(action: {
                        isLoggingIn = true
                        //logIn()
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.init(hex: "cc0944"))
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                    .padding(.bottom, 30)
                    .padding(.top, 20)
                    
                    HStack(spacing: 0) {
                        Text("Don't have an account? ")
                            .foregroundColor(.black)
                        Button(action: {
                            self.showSignUp.toggle()
                        }) {
                            Text("Sign Up")
                                .bold()
                                .foregroundColor(.black)
                        }
                    }
                    
                    /*HStack(spacing: 0) {
                        Text("Not a client? ")
                            .foregroundColor(.black)
                        
                        Button(action: {
                            print("print - Signing in as a Consultant")
                        }) {
                            Text("Sign in as a Consultant")
                                .foregroundColor(.black)
                                .bold()
                        }
                    }
                    .padding(.top, 1)
                    .padding(.bottom, 1)*/
                    
                }
                .aspectRatio(contentMode: .fit)
            }
        }
        .onTapGesture(count: 2) {
            UIApplication.shared.endEditing()
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView(email: $email, password: $password)
        }
        .sheet(isPresented: $hasForgotPassword) {
            ForgotPassword(email: $email)
        }
        .alert(isPresented: $signInUnsuccessful, content: {
            Alert(title: Text("Login Unsuccesful"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        })
    }
    
    // MARK: - logIn
    /*private func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                isLoggingIn = false
                signInUnsuccessful = true
                alertMessage = error!.localizedDescription
                print("print - \(error!)")
                return
            }
            // Login successful
            
            print("print - Logged \(user.email ?? "nil") in")
            self.settings.loggedIn = true
            UserDefaults.standard.setValue(true, forKey: "loggedIn")
        }
    }*/
    
    // MARK: - textFieldTextBG
    // Returns the same color as the system setting for the text in the textfield
    func textFieldTextBG() -> Color {
        if colorScheme == .dark {
            return Color(.black)
        } else {
            return Color(.white)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice("iPhone 12 Pro")
            //.previewDevice("iPhone 6s")
            .preferredColorScheme(.dark)
    }
}

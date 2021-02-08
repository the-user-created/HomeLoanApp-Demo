//
//  ForgotPassword.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/13.
//

import SwiftUI
////import Firebase

struct ForgotPassword: View {
    
    // MARK: - State Variables
    @State private var isLoading: Bool = false
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    @Binding var email: String
    
    // MARK: - body
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            VStack(alignment: .center, spacing: 15) {
                Spacer()
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
                
                Button(action: {
                    isLoading = true
                    //forgotPassword()
                }) {
                    Text("Forgot Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.init(hex: "cc0944"))
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }
                .padding([.top, .bottom], 30)
                
                Spacer()
            }
            .background(
                Image("LSImage")
                    .resizable()
                    .ignoresSafeArea(.all))
            .edgesIgnoringSafeArea(.all)
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Forgot Password Unsuccesful"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        })
    }
    
    /*private func forgotPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("print - Error trying to send password reset email: \(error)")
                alertMessage = error.localizedDescription
                isLoading = false
                showAlert = true
                return
            }
            // Sent successfully
            alertMessage = "Please check your email to reset your password."
            isLoading = false
            showAlert = true
        }
    }*/
}

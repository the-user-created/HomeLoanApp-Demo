//
//  TextFieldStructs.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/15.
//

import SwiftUI


// MARK: - CustomTextField
struct CustomTextField: View {
    var placeholder: String
    var textColor: Color = .black
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
            }
            
            TextField(placeholder,
                      text: $text,
                      onEditingChanged: editingChanged,
                      onCommit: commit)
                .foregroundColor(textColor)
        }
    }
}


// MARK: - PasswordTextField
struct PasswordTextField: View {
    // Always has the same text color unless set during struct call
    @Binding var showPassword: Bool
    @Binding var password : String
    var textColor: Color = .black
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        HStack() {
            Image(systemName: "lock")
                .foregroundColor(.gray)
                .padding(.leading, 3)
            
            ZStack(alignment: .leading) {
                if password.isEmpty {
                    Text("Password...")
                        .foregroundColor(.gray)
                }
                
                if showPassword {
                    TextField("Password...",
                              text: $password)
                        .foregroundColor(textColor)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                } else {
                    SecureField("Password...",
                                text: $password)
                        .foregroundColor(textColor)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
            }
            
            Button(action: {
                showPassword.toggle()
            }) {
                if showPassword {
                    Image(systemName: "eye.slash")
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "eye")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

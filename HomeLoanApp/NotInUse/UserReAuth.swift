//
//  UserReAuth.swift
//  HomeLoanApp
//
//  Created by David Young on 2021/01/10.
//

/*import SwiftUI

struct UserReAuth: View {
    // MARK: - Wrapped Objects
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - State Variables
    @State private var showPassword: Bool = false
    
    @Binding var password: String
    //@State private var password = ""
    
    // MARK: - body
    var body: some View {
        Form() {
            Text("Please enter your password to change your email...")
                .font(.title2)
            
            PasswordTFType1(showPassword: $showPassword,
                                   password: $password)
                .padding()
                .background(Capsule().fill(colorScheme == .dark ? Color.white : Color.black))
            
            Spacer()
                .padding()
            
            HStack() {
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    backgroundForButton(btnText: "OK", btnColor: .blue)
                }
                
                Spacer()
            }
            .padding()
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}*/

/*struct UserReAuth_Previews: PreviewProvider {
    static var previews: some View {
        UserReAuth()
            .previewDevice("iPhone 12 Pro")
            //.preferredColorScheme(.dark)
    }
}*/

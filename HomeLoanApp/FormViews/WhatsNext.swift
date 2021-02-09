//
//  WhatsNext.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/09.
//

import SwiftUI

struct WhatsNext: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Your application has been sent to your Sales Consultant who will review the details of your application.")
                    
                    Text("You will be contacted at a later point to improve the strength application in order to get the best deal.")
                }
                
                Section {
                    Text("Thank you for using the HomeLoanApp for submitting your application.")
                        .font(.headline)
                }
            }
            .multilineTextAlignment(.center)
            .navigationBarTitle(Text("What's Next?"))
            .navigationBarItems(trailing: Button("Done", action: {
                presentationMode.wrappedValue.dismiss()
            })
            .font(.headline))
        }
    }
}

struct WhatsNext_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNext()
            .previewDevice("iPhone 12 Pro")
            .preferredColorScheme(.dark)
    }
}

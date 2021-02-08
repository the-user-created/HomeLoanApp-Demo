//
//  PrivacyPolicyView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/22.
//

import SwiftUI

// What must be contained in the policy?
/// Identity: who is collecting the information as well as the company’s contact details
/// Types of Data: what categories of personal data the app will collect and process
/// Reason: why data processing is necessary and for what precise purpose the collection is being performed
/// Disclosures: whether the data in question will be disclosed to third parties
/// User Rights: what rights users have including the right to the withdrawal of consent and the deletion of data.

struct PrivacyPolicyView: View {
    var dateTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_ZA")
        return formatter
    }
    
    var body: some View {
        NavigationView() {
            List() {
                //Text("Last Updated \(dateTime.string(from: Date()))")
                
                Text("Last Updated 08 February 2021 at 09:48")
                
                Text("Oobalink (“we” or “us” or “our”) respects the privacy of our users (“user” or “you”). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application (the “HomeLoanApp”). Please read this Privacy Policy carefully. IF YOU DO NOT AGREE WITH THE TERMS OF THIS PRIVACY POLICY, PLEASE DO NOT USE THE APPLICATION.")
                
                Text("We reserve the right to make changes to this Privacy Policy at any time and for any reason. We will alert you about any changes by updating the “Last updated” date of this Privacy Policy. You are encouraged to periodically review this Privacy Policy to stay informed of updates. You will be deemed to have been made aware of, will be subject to, and will be deemed to have accepted the changes in any revised Privacy Policy by your continued use of the Application after the date such revised Privacy Policy is posted.")
                
                Section(header: Text("COLLECTION OF YOUR INFORMATION")) {
                    Text("We do not collect any information pertaining to the user until the point of loam application form submission. At submission all data the user has entered will be shared with Ooba and the respective Sales Consultant selected by the user.")
                    
                    Text("Until the point of submission all data is stored locally on the users device. The data will be sent using Mail (Apple's Email app) to the respective Sales Consultant.")
                }
                
                Section(header: Text("CONTACT US")) {
                    VStack(alignment: .leading) {
                        Text("If you have questions or comments about this Privacy Policy, please contact us at:\n")
                        
                        Text("[Company Name]\n")
                            .foregroundColor(.blue)
                        
                        Text("[Street Address]\n")
                            .foregroundColor(.blue)
                        
                        Text("[City, Street Code]\n")
                            .foregroundColor(.blue)
                        
                        Text("[Phone Number]\n")
                            .foregroundColor(.blue)
                        
                        Text("[Fax Number]\n")
                            .foregroundColor(.blue)
                        
                        Text("[Email]\n")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationBarTitle("Privacy Policy")
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
            //.preferredColorScheme(.dark)
            .previewDevice("iPhone 12 Pro")
    }
}

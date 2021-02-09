//
//  TestingLayouts.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/21.
//

import SwiftUI

struct TestingLayouts: View {
    var body: some View {
        VStack {
            Image(systemName: "chevron.compact.down")
                .resizable()
                .frame(width: 60, height: 13)
                .scaledToFit()
            
            Divider()
            
            List {
                // Title
                HStack {
                    Spacer()
                    
                    Text("How to take a good scan")
                        .bold()
                        .font(.title2)
                        .padding()
                    
                    Spacer()
                }
                
                // Step header
                Text("Steps")
                    .bold()
                    .font(.title3)
                
                // Steps
                Group {
                    Text("1. Place your document in a well-lit area.")
                    
                    Text("2. Tap \"Scan your (something)\".")
                    
                    Text("3. Position the document in within the cameras view.")
                    
                    Text("4. A transparent-blue overlay will appear around the document's edges.")
                    
                    Text("5. You can either tap the white, circular button (a) to capture a scan of the document, or you can wait for a grid to flash across the document (b).")
                    
                    Text("a1. You will be taken to a page to adjust the scan area. Here you can adjust the corners of the scan area to suit your documents needs.\n\na2. If you are satisfied with the scan area, tap \"Keep Scan\" to proceed to the next view.")
                        .padding([.leading, .trailing], 15)
                    
                    Text("b1. You will be taken back to the scan capturing view.")
                        .padding([.leading, .trailing], 15)
                        .padding(.bottom, 5)
                    
                    Text("6. You can either proceed to take scans of more documents, edit/delete previous scans, or you can tap \"Save\" to save the scans (it may take a few moments to save).")
                    
                    Text("7. To edit/delete a scan just tap on the icon of the scan in the lower left of the screen.")
                }
            }
            .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
    }
}

struct TestingLayouts_Previews: PreviewProvider {
    static var previews: some View {
        TestingLayouts()
            .previewDevice("iPhone 12 Pro")
            .preferredColorScheme(.dark)
    }
}

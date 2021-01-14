//
//  DocumentScan.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/11.
//

import SwiftUI
import Vision
import VisionKit

/*struct DocumentScan: View {
    private let buttonInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    @State private var isShowingScannerSheet = false
    
    var body: some View {
        NavigationView() {
            Form() {
                Section(header: Text("Some category")) {
                    VStack() {
                        Button("Open Scanner") {
                            self.isShowingScannerSheet = true
                        }
                        .padding(buttonInsets)
                        .background(Color.blue)
                        .foregroundColor(.black)
                        .cornerRadius(3.0)
                    }
                    .sheet(isPresented: self.$isShowingScannerSheet) {
                        ScannerView(completion: {
                                        _ in self.isShowingScannerSheet = false
                        }, scanName: "passport_id")
                    }
                }
                
                Section() {
                    NavigationLink(destination: PersonalDetails()) {
                        Text("Next Page")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationTitle(Text("Documents"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func loadImageFromDisk(named: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(named)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        } else {
            return nil
        }
    }
}

#if DEBUG
struct DocumentScan_Previews: PreviewProvider {
    static var previews: some View {
        DocumentScan()
    }
}
#endif
*/

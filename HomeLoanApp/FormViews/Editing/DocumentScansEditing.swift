//
//  DocumentScansEditing.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/19.
//

import SwiftUI

struct DocumentScansEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @ObservedObject var application: Application
    
    // MARK: - State Variables
    @State var identityType: String = ""
    @State var isShowingSheet: Bool = false
    @State var scanSuccess: Bool = false
    @State var sheetID: Sheets = .none
    @Binding var isDone: Bool
    
    // MARK: - Properties
    
    // MARK: - init
    init(application: Application, isDone: Binding<Bool>) {
        self.application = application
        self._isDone = isDone
        self._identityType = State(wrappedValue: self.application.iDType ?? "")
        self._scanSuccess = State(wrappedValue: hasScanned())
    }
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("Passport OR ID")) {
                HStack() {
                    Button(action: {
                        sheetID = .scannerIDPass
                        isShowingSheet = true
                    }) {
                        BackgroundForButton(btnText: scanString())
                    }
                    
                    Spacer()
                    
                    Image(systemName: scanSuccess ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundColor(scanSuccess ? .green : .red)
                    
                    Spacer()
                    
                    Button(action: {
                        sheetID = .scannerTips
                        isShowingSheet = true
                    }) {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 22.0, height: 22.0)
                    }
                    
                }
                .foregroundColor(.blue)
                .buttonStyle(BorderlessButtonStyle())
            }
            
            Section() {
                Text("\(application.loanID?.uuidString ?? "nil")")
                
                Button(action: {
                    print("print - \(String(describing: FileManager.default.urls(for: .documentDirectory)))")
                }) {
                    Text("print all files")
                }
            }
        }
        .navigationBarTitle("Documents")
        .sheet(isPresented: $isShowingSheet) {
            if sheetID == .scannerIDPass {
                ScannerView(scanName: "passport_id", applicationID: application.loanID!) { _ in
                    // May have problems later if needing to do more things than just dismiss on completion
                    sheetID = .none
                    scanSuccess = hasScanned()
                    isShowingSheet = false
                }
            } else if sheetID == .scannerTips {
                Text("Steps on taking a good scan")
            }
        }
    }
    
    // MARK: - hasScanned
    private func hasScanned() -> Bool {
        var result: Bool = false
        if identityType == "Passport" || identityType == "ID Book" { // When the clients ID type is a Passport (or ID Book) they must scan just one side
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileName = "passport_id_image_\(application.loanID?.uuidString ?? "nil")_0.png"
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                result = FileManager.default.fileExists(atPath: fileURL.path)
            }
            // Failed to get directory, therefore result is false
        } else if identityType == "SmartCard ID" { // When the clients ID type is a SmartCard ID they must scan both sides of the card
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                var sideOneScanned: Bool = false
                var sideTwoScanned: Bool = false
                
                for scanNumber in 0..<2 {
                    let fileName = "passport_id_image_\(application.loanID?.uuidString ?? "nil")_\(scanNumber).png"
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
                    if scanNumber == 0 {
                        sideOneScanned = FileManager.default.fileExists(atPath: fileURL.path)
                    } else {
                        sideTwoScanned = FileManager.default.fileExists(atPath: fileURL.path)
                    }
                }
                
                if sideOneScanned && sideTwoScanned {
                    result = true
                }
                // Missing one of the scans, therefore result is false
            }
            // Failed to get directory, therefore result is false
        }
        
        return result
    }
    
    // MARK: - scanString
    private func scanString() -> String {
        var outString: String = "Scan your "
        if !identityType.isEmpty {
            outString += identityType != "--select--" ? (identityType.contains("ID") ? "ID" : "Passport") : "passport/ID"
        } else {
            outString += "passport/ID"
        }
        
        return outString
    }
}


//
//  DocumentScans.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/18.
//

import SwiftUI

struct DocumentScans: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) private var viewContext
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    
    // MARK: - State Variables
    @State var incomeStructure: String = ""
    @State var idPassScanned: Bool = false
    @State var salaryPaySlipsScanned: Bool = false
    @State var bankStatementsScanned: Bool = false
    
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var isActive: Bool = false
    
    @State var isShowingSheet: Bool = false
    @State var sheetID: ScannerSheets = .none
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("Passport OR ID")) {
                HStack() {
                    Button(action: {
                        sheetID = .scannerIDPass
                        isShowingSheet = true
                    }) {
                        BackgroundForButton(btnText: "Scan your \(applicationCreation.application.iDType ?? "")")
                    }
                    
                    Spacer()
                    
                    Image(systemName: idPassScanned ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundColor(idPassScanned ? .green : .red)
                    
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
                
                if idPassScanned {
                    HStack() {
                        Button(action: {
                            sheetID = .idPassScan
                            isShowingSheet = true
                        }) {
                            Text("View scan")
                        }
                    }
                }
            }
            
            Section(header: Text("Income")) {
                FormYesNo(iD: "incomeStructure", question: "What is your income structure?", selected: $incomeStructure)//, buttonOneText: "Salaried", buttonTwoText: "Variable Pay")
                
                if !incomeStructure.isEmpty {
                    HStack() {
                        Button(action: {
                            //sheetID = .scannerIDPass
                            //isShowingSheet = true
                        }) {
                            BackgroundForButton(btnText: "Scan your \(incomeStructure == "Salaried" ? "latest 3 months payslips.": "latest 6 months consecutive salary slips.")")
                        }
                        
                        Spacer()
                        
                        Image(systemName: salaryPaySlipsScanned ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(salaryPaySlipsScanned ? .green : .red)
                        
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
                    
                    HStack() {
                        Button(action: {
                            //sheetID = .scannerIDPass
                            //isShowingSheet = true
                        }) {
                            BackgroundForButton(btnText: "Scan your \(incomeStructure == "Salaried" ? "latest 3 months bank statements.": "latest 6 months bank statements which reflect your salary deposits.")")
                        }
                        
                        Spacer()
                        
                        Image(systemName: bankStatementsScanned ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(bankStatementsScanned ? .green : .red)
                        
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
            }
            
            Section() {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Documents")
        .onReceive(resignPub) { _ in
            if isActive {
                handleSaving()
            }
        }
        .onDisappear() {
            isActive = false
        }
        .onAppear() {
            isActive = true
        }
        .sheet(isPresented: $isShowingSheet) {
            if sheetID == .scannerIDPass {
                ScannerView(scanName: "passport_id", applicationID: applicationCreation.application.loanID!) { _ in
                    // May have problems later if needing to do more things than just dismiss on completion
                    sheetID = .none
                    idPassScanned = hasScanned()
                    changedValues.updateKeyValue("idPassScanned", value: idPassScanned)
                    isShowingSheet = false
                }
            } else if sheetID == .scannerTips {
                Text("Steps on taking a good scan")
            } else if sheetID == .idPassScan {
                let identityType = applicationCreation.application.iDType
                let loanID = applicationCreation.application.loanID?.uuidString
                if identityType == "Passport" || applicationCreation.application.iDType == "ID Book" {
                    ImageWithURL(url: "passport_id_image_\(loanID ?? "nil")_0.png", identityType: identityType ?? "")
                } else if identityType == "Smart ID Card" {
                    ImageWithURL(url: "passport_id_image_\(loanID ?? "nil")_", identityType: identityType ?? "")
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        
        if idPassScanned {
            isComplete = true
        }
        
        changedValues.changedValues.updateValue(isComplete, forKey: "documentScansDone")
        return isComplete
    }
    
    // MARK: - handleSaving
    private func handleSaving() {
        if !changedValues.changedValues.isEmpty {
            isDone = determineComplete()
            saveApplication()
            presentationMode.wrappedValue.dismiss()
        } else {
            alertMessage = "Please scan your supporting documents before attempting to save."
            showingAlert = true
        }
    }
    
    // MARK: - hasScanned
    private func hasScanned() -> Bool {
        let identityType: String = applicationCreation.application.iDType ?? ""
        let loanID: String = applicationCreation.application.loanID?.uuidString ?? ""
        
        var result: Bool = false
        if identityType == "Passport" || identityType == "ID Book" { // When the clients ID type is a Passport (or ID Book) they must scan just one side
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileName = "passport_id_image_\(loanID)_0.png"
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                result = FileManager.default.fileExists(atPath: fileURL.path)
            }
            // Failed to get directory, therefore result is false
        } else if identityType == "Smart ID Card" { // When the clients ID type is a Smart ID Card they must scan both sides of the card
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                var sideOneScanned: Bool = false
                var sideTwoScanned: Bool = false
                
                for scanNumber in 0..<2 {
                    let fileName = "passport_id_image_\(loanID)_\(scanNumber).png"
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
    
    // MARK: - saveApplication
    private func saveApplication() {
        for (key, value) in changedValues.changedValues {
            applicationCreation.application.setValue(value, forKey: key)
        }
        
        do {
            try viewContext.save()
            print("print - Application Entity Updated")
            applicationCreation.documentScansSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    @ObservedObject var application: Application
    
    // MARK: - State Variables
    @State var identityType: String = ""
    @State var incomeStructure: String = ""
    @State var idPassScanned: Bool = false
    @State var salaryPaySlipsScanned: Bool = false
    @State var bankStatementsScanned: Bool = false
    
    @State var isShowingSheet: Bool = false
    @State var sheetID: ScannerSheets = .none
    @State var sender: Sender
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @Binding var isDone: Bool
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
    
    // MARK: - init
    init(application: Application, isDone: Binding<Bool>, sender: Sender) {
        self.application = application
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self._identityType = State(wrappedValue: self.application.iDType ?? "")
        self._idPassScanned = State(wrappedValue: self.application.idPassScanned)
    }
    
    // MARK: - body
    var body: some View {
        Form() {
            Section(header: Text("\(identityType) Scan")) {
                HStack() {
                    // Open Scanner
                    Button(action: {
                        sheetID = .scannerIDPass
                        isShowingSheet = true
                    }) {
                        BackgroundForButton(btnText: "Scan your \(identityType)")
                    }
                    
                    Spacer()
                    
                    Image(systemName: idPassScanned ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundColor(idPassScanned ? .green : .red)
                    
                    Spacer()
                    
                    // Open how to scan sheet
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
                .padding([.bottom, .leading, .trailing], 15)
                .padding(.top, 10)
                
                // View Scan
                if idPassScanned {
                    HStack() {
                        Button(action: {
                            sheetID = .idPassScan
                            isShowingSheet = true
                        }) {
                            Text("View scan\(identityType == "Smart ID Card" ? "s" : "")")
                                .foregroundColor(.blue)
                                .font(.headline)
                        }
                    }
                    .padding(.leading, 15)
                    .padding([.top, .bottom], 5)
                }
            }
            
            Section(header: Text("Income Documents")) {
                FormYesNo(iD: "incomeStructure", question: "What is your income structure?", selected: $incomeStructure, buttonOneText: "Salaried", buttonTwoText: "Variable Pay")
                
                if !incomeStructure.isEmpty {
                    Group() {
                        // Section header
                        HStack() {
                            Spacer()
                            
                            Text("Salary/Pay Scans")
                                .font(.title2)
                            
                            Spacer()
                        }
                        
                        // Salary / Pay scan
                        VStack() {
                            HStack() {
                                Text(incomeStructure == "Salaried" ? "Latest 3 months payslips.": "Latest 6 months consecutive salary slips.")
                                    .padding([.top, .bottom], 5)
                                    .padding(.leading, 15)
                                
                                Spacer()
                            }
                            
                            HStack() {
                                // Open scanner
                                Button(action: {
                                    sheetID = .scannerSalaryPay
                                    isShowingSheet = true
                                }) {
                                    BackgroundForButton(btnText: "Scan your \(incomeStructure == "Salaried" ? "payslips" : "salary")")
                                }
                                
                                Spacer()
                                
                                Image(systemName: salaryPaySlipsScanned ? "checkmark.circle.fill" : "checkmark.circle")
                                    .foregroundColor(salaryPaySlipsScanned ? .green : .red)
                                
                                Spacer()
                                
                                // Open how to scan sheet
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
                            .padding([.bottom, .leading, .trailing], 15)
                        }
                        
                        // View Scan
                        if bankStatementsScanned {
                            HStack() {
                                Button(action: {
                                    sheetID = .salaryPayScan
                                    isShowingSheet = true
                                }) {
                                    Text("View scans")
                                        .foregroundColor(.blue)
                                        .font(.headline)
                                }
                            }
                            .padding(.leading, 15)
                            .padding([.top, .bottom], 5)
                        }
                    }
                    
                    Group() {
                        // Section header
                        HStack() {
                            Spacer()
                            
                            Text("Bank Statement Scans")
                                .font(.title2)
                            
                            Spacer()
                        }
                        
                        // Bank statements scan
                        VStack() {
                            HStack() {
                                Text(incomeStructure == "Salaried" ? "The latest 3 months bank statements.": "Latest 6 months bank statements which reflect your salary deposits.")
                                    .padding([.top, .bottom], 5)
                                    .padding(.leading, 15)
                                
                                Spacer()
                            }
                            
                            HStack() {
                                // Open scanner
                                Button(action: {
                                    sheetID = .scannerBankStatements
                                    isShowingSheet = true
                                }) {
                                    BackgroundForButton(btnText: "Scan your bank statements")
                                }
                                
                                Spacer()
                                
                                Image(systemName: bankStatementsScanned ? "checkmark.circle.fill" : "checkmark.circle")
                                    .foregroundColor(bankStatementsScanned ? .green : .red)
                                
                                Spacer()
                                
                                // Open how to scan sheet
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
                            .padding([.bottom, .leading, .trailing], 15)
                        }
                        
                        // View Scan
                        if bankStatementsScanned {
                            HStack() {
                                Button(action: {
                                    sheetID = .bankStatementsScan
                                    isShowingSheet = true
                                }) {
                                    Text("View scans")
                                        .foregroundColor(.blue)
                                        .font(.headline)
                                }
                            }
                            .padding(.leading, 15)
                            .padding([.top, .bottom], 5)
                        }
                    }
                }
            }
            
            Section() {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save changes")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Documents")
        .sheet(isPresented: $isShowingSheet) {
            if sheetID == .scannerTips {
                Text("Steps on taking a good scan")
            } else if sheetID == .scannerIDPass {
                ScannerView(scanName: "passport_id", applicationID: application.loanID!) { _ in
                    // May have problems later if needing to do more things than just dismiss on completion
                    sheetID = .none
                    idPassScanned = hasScanned()
                    changedValues.updateKeyValue("idPassScanned", value: idPassScanned)
                    isShowingSheet = false
                }
            } else if sheetID == .idPassScan {
                let loanID = application.loanID?.uuidString
                if identityType == "Passport" || identityType == "ID Book" {
                    ImageWithURL(url: "passport_id_image_\(loanID ?? "nil")_0.png", identityType: identityType)
                } else if identityType == "Smart ID Card" {
                    ImageWithURL(url: "passport_id_image_\(loanID ?? "nil")_", identityType: identityType)
                }
            } else if sheetID == .scannerSalaryPay {
                
            }
        }
        .onReceive(resignPub) { _ in
            handleSaving()
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
        isDone = determineComplete()
        addToApplication()
        presentationMode.wrappedValue.dismiss()
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
        } else if identityType == "Smart ID Card" { // When the clients ID type is a Smart ID Card they must scan both sides of the card
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
    
    // MARK: - addToApplication()
    private func addToApplication() {
        UIApplication.shared.endEditing()
        
        for (key, value) in changedValues.changedValues {
            if sender == .creator {
                applicationCreation.application.setValue(value, forKey: key)
            } else {
                application.setValue(value, forKey: key)
            }
        }
        
        do {
            try viewContext.save()
            print("Application Entity Updated")
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}


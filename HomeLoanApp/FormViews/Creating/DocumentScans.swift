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
    @State var identityScanned: Bool = false
    @State var salaryPaySlipsScanned: Bool = false
    @State var bankStatementsScanned: Bool = false
    
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @State var isActive: Bool = false
    
    @State var isShowingSheet: Bool = false
    @State var sheetID: ScannerSheets = .none
    @State var infoSheetType: String = ""
    @State var identityType: String = ""
    @State var salesConsultant: String = ""
    @Binding var isDone: Bool
    @Binding var scanGroup: [String]
    
    // MARK: - Properties
    let resignPub = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)

    // MARK: - body
    var body: some View {
        Form {
            Section(header: Text("INFO")) {
                RichText("Here you have the option to scan your identity document/card and/or scan your payslips and/or bank statements.")
                
                RichText("If you would prefer not to scan these documents in-app you can take a photo of the corresponding documents and email them to *\(salesConsultantEmails[applicationCreation.application.salesConsultant ?? ""] ?? "your sales consultant")*")
            }

            Section(header: Text("IDENTITY DOCUMENT")) {
                HStack {
                    // Open Scanner
                    Button(action: {
                        sheetID = .identityScan
                        isShowingSheet = true
                    }) {
                        BackgroundForButton(btnText: "Scan your \(identityText())")
                    }

                    Spacer()

                    Image(systemName: identityScanned ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(identityScanned ? .green : .red)

                    Spacer()

                    // Open how to scan sheet
                    Button(action: {
                        sheetID = .scanTips
                        infoSheetType = "identity"
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
                if identityScanned {
                    HStack {
                        Button(action: {
                            sheetID = .identityScanView
                            isShowingSheet = true
                        }) {
                            Text("View scan\(applicationCreation.application.identityType == "Smart ID Card" ? "s" : "")")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                        }
                    }
                            .padding(.leading, 15)
                            .padding([.top, .bottom], 5)
                }
            }

            Section(header: Text("INCOME DOCUMENTS")) {
                FormYesNo(iD: "incomeStructure", question: "What is your income structure?", selected: $incomeStructure, buttonOneText: "Salaried", buttonTwoText: "Variable Pay")

                if !incomeStructure.isEmpty {
                    // Salary/Pay
                    Group {
                        // Section header
                        HStack {
                            Spacer()

                            Text("Salary/Pay Scans")
                                    .font(.title2)

                            Spacer()
                        }

                        // Salary / Pay scan
                        VStack {
                            HStack {
                                Text(incomeStructure == "Salaried" ? "Latest 3 months payslips.": "Latest 6 months consecutive salary slips.")
                                        .padding([.top, .bottom], 5)
                                        .padding(.leading, 15)

                                Spacer()
                            }

                            HStack {
                                // Open scanner
                                Button(action: {
                                    sheetID = .salaryPayScan
                                    isShowingSheet = true
                                }) {
                                    BackgroundForButton(btnText: "Scan your \(incomeStructure == "Salaried" ? "payslips" : "salary")")
                                }

                                Spacer()

                                Image(systemName: salaryPaySlipsScanned ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundColor(salaryPaySlipsScanned ? .green : .red)

                                Spacer()

                                // Open scan tips sheet
                                Button(action: {
                                    sheetID = .scanTips
                                    infoSheetType = "salaryPay"
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
                        if salaryPaySlipsScanned {
                            HStack {
                                Button(action: {
                                    sheetID = .salaryPayScanView
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

                    // Bank Statements
                    Group {
                        // Section header
                        HStack {
                            Spacer()

                            Text("Bank Statement Scans")
                                    .font(.title2)

                            Spacer()
                        }

                        // Bank statements scan
                        VStack {
                            HStack {
                                Text(incomeStructure == "Salaried" ? "The latest 3 months bank statements.": "Latest 6 months bank statements which reflect your salary deposits.")
                                        .padding([.top, .bottom], 5)
                                        .padding(.leading, 15)

                                Spacer()
                            }

                            HStack {
                                // Open scanner
                                Button(action: {
                                    sheetID = .bankStatementsScan
                                    isShowingSheet = true
                                }) {
                                    BackgroundForButton(btnText: "Scan your bank statements")
                                }

                                Spacer()

                                Image(systemName: bankStatementsScanned ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundColor(bankStatementsScanned ? .green : .red)

                                Spacer()

                                // Open scan tips sheet
                                Button(action: {
                                    sheetID = .scanTips
                                    infoSheetType = "bankStatements"
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
                            HStack {
                                Button(action: {
                                    sheetID = .bankStatementsScanView
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
            
            Section {
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
        .onDisappear {
            isActive = false
        }
        .onAppear {
            isActive = true
        }
        .onChange(of: isShowingSheet) { _ in
            isActive = !isShowingSheet
        }
        .sheet(isPresented: $isShowingSheet) {
            let loanID = applicationCreation.application.loanID
            if sheetID == .scanTips {
                let infoType: String? = infoSheetType == "identity" ? applicationCreation.application.identityType : (infoSheetType == "salaryPay" ? "salary/pay slips" : "bank statement documents")
                ScanTipsView(infoType: infoType) { _ in
                    infoSheetType = ""
                }
            } else if sheetID == .identityScan {
                ScannerView(scanName: "identity", applicationID: loanID!, alertMessage: $alertMessage, alertShowing: $showingAlert) { _ in
                    sheetID = .none
                    alertMessage = ""
                    identityScanned = hasScanned()
                    changedValues.updateKeyValue("identityScanned", value: identityScanned)
                    isShowingSheet = false
                }
            } else if sheetID == .identityScanView {
                let identityType = applicationCreation.application.identityType
                if let identityType = identityType {
                    if identityType == "Passport" || identityType == "ID Book" || identityType.contains("REFUGEE") {
                        ScannedView(url: "identity_scan_\(loanID?.uuidString ?? "nil")_0.png", scanType: identityType)
                    } else if identityType == "Smart ID Card" {
                        ScannedView(url: "identity_scan_\(loanID?.uuidString ?? "nil")_", scanType: identityType)
                    }
                }
            } else if sheetID == .salaryPayScan {
                ScannerView(scanName: "salary_pay", applicationID: loanID!, alertMessage: $alertMessage, alertShowing: $showingAlert) { _ in
                    sheetID = .none
                    alertMessage = ""
                    salaryPaySlipsScanned = hasScanned(scanType: "salaryPay")
                    changedValues.updateKeyValue("salaryPaySlipsScanned", value: salaryPaySlipsScanned)
                    isShowingSheet = false
                }
                
            } else if sheetID == .salaryPayScanView {
                ScannedIncomeView(url: "salary_pay_scan_\(loanID?.uuidString ?? "nil")_", scanType: "salaryPay")
            } else if sheetID == .bankStatementsScan {
                ScannerView(scanName: "bank_statement", applicationID: loanID!, alertMessage: $alertMessage, alertShowing: $showingAlert) { _ in
                    sheetID = .none
                    alertMessage = ""
                    bankStatementsScanned = hasScanned(scanType: "bankStatement")
                    changedValues.updateKeyValue("bankStatementsScanned", value: bankStatementsScanned)
                    isShowingSheet = false
                }
                
            } else if sheetID == .bankStatementsScanView {
                ScannedIncomeView(url: "bank_statement_scan_\(loanID?.uuidString ?? "nil")_", scanType: "bankStatement")
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        
        scanGroup = []
        
        if identityScanned {
            isComplete = true
            scanGroup.append("identity")
        }
        
        if salaryPaySlipsScanned {
            isComplete = true
            scanGroup.append("salaryPay")
        }
        
        if bankStatementsScanned {
            isComplete = true
            scanGroup.append("bankStatements")
        }
        
        changedValues.changedValues.updateValue(isComplete, forKey: "documentScansDone")
        changedValues.changedValues.updateValue(scanGroup, forKey: "scanGroup")
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
    private func hasScanned(scanType: String = "identity") -> Bool {
        var result: Bool = false
        let loanID = applicationCreation.application.loanID
        if scanType == "identity", let identityType = applicationCreation.application.identityType {
            if identityType == "Passport" || identityType == "ID Book" || identityType.contains("REFUGEE") { // When the clients ID type is a Passport (or ID Book) they must scan just one side
                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileName = "identity_scan_\(loanID?.uuidString ?? "nil")_0.png"
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
                    result = FileManager.default.fileExists(atPath: fileURL.path)
                }
                // Failed to get directory, therefore result is false
            } else if identityType == "Smart ID Card" { // When the clients ID type is a SMART ID CARD they must scan both sides of the card
                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    var sideOneScanned: Bool = false
                    var sideTwoScanned: Bool = false
                    
                    for scanNumber in 0..<2 {
                        let fileName = "identity_scan_\(loanID?.uuidString ?? "nil")_\(scanNumber).png"
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
        } else if scanType == "salaryPay" {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileName = "salary_pay_scan_\(loanID?.uuidString ?? "nil")_0.png"
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                result = FileManager.default.fileExists(atPath: fileURL.path)
            }
        } else if scanType == "bankStatement" {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileName = "bank_statement_scan_\(loanID?.uuidString ?? "nil")_0.png"
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                result = FileManager.default.fileExists(atPath: fileURL.path)
            }
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
    
    // MARK: - identityText
    private func identityText() -> String {
        var outString: String = "Identity"
        let identityType: String = applicationCreation.application.identityType ?? ""
        
        if identityType == "Passport" {
            outString = "Passport"
        } else if identityType != "Passport" {
            outString = (identityType == "ID Book") ? "ID Book" : ((identityType.contains("REFUGEE")) ? "Refugee ID" : "Smart ID Card")
        }
        
        return outString
    }
}

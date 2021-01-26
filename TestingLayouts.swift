//
//  TestingLayouts.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/21.
//

import SwiftUI

struct TestingLayouts: View {
    
    @State var identityType: String = ""
    @State var incomeStructure: String = ""
    @State var identityScanned: Bool = false
    @State var salaryPaySlipsScanned: Bool = false
    @State var bankStatementsScanned: Bool = false
    
    @State var isShowingSheet: Bool = false
    @State var sheetID: ScannerSheets = .none
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    
    init() {
        self._identityType = State(wrappedValue: "Smart ID Card")
    }
    
    var body: some View {
        Form() {
            Section(header: Text("\(identityType) Scan")) {
                HStack() {
                    // Open Scanner
                    Button(action: {
                        sheetID = .identityScanView
                        isShowingSheet = true
                    }) {
                        BackgroundForButton(btnText: "Scan your \(identityType)")
                    }
                    
                    Spacer()
                    
                    Image(systemName: identityScanned ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundColor(identityScanned ? .green : .red)
                    
                    Spacer()
                    
                    // Open how to scan sheet
                    Button(action: {
                        sheetID = .scanTips
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
                    HStack() {
                        Button(action: {
                            sheetID = .identityScan
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
                    HStack() {
                        Spacer()
                        
                        Text("Salary/Pay Scans")
                            .font(.title2)
                        
                        Spacer()
                    }
                    
                    
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
                                //sheetID = .identityScanView
                                //isShowingSheet = true
                            }) {
                                BackgroundForButton(btnText: "Scan your \(incomeStructure == "Salaried" ? "payslips" : "salary")")
                            }
                            
                            Spacer()
                            
                            Image(systemName: salaryPaySlipsScanned ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(salaryPaySlipsScanned ? .green : .red)
                            
                            Spacer()
                            
                            // Open how to scan sheet
                            Button(action: {
                                sheetID = .scanTips
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
                    if true {
                        HStack() {
                            Button(action: {
                                //sheetID = .identityScanView
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
                    
                    HStack() {
                        Spacer()
                        
                        Text("Bank Statement Scans")
                            .font(.title2)
                        
                        Spacer()
                    }
                    
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
                                //sheetID = .identityScanView
                                //isShowingSheet = true
                            }) {
                                BackgroundForButton(btnText: "Scan your bank statements")
                            }
                            
                            Spacer()
                            
                            Image(systemName: bankStatementsScanned ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(bankStatementsScanned ? .green : .red)
                            
                            Spacer()
                            
                            // Open how to scan sheet
                            Button(action: {
                                sheetID = .scanTips
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
                    if true {
                        HStack() {
                            Button(action: {
                                //sheetID = .identityScanView
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
            
            Section() {
                Button(action: {
                    //handleSaving()
                }) {
                    Text("Save changes")
                        .foregroundColor(.blue)
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Documents")
    }
}

struct TestingLayouts_Previews: PreviewProvider {
    static var previews: some View {
        TestingLayouts()
            .previewDevice("iPhone 12 Pro")
            .preferredColorScheme(.dark)
    }
}

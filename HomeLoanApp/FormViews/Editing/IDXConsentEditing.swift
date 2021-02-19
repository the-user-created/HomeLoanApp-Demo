//
//  IDXConsentEditing.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/18.
//

import SwiftUI

struct IDXConsentEditing: View {
    // MARK: - Wrapped Objects
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var applicationCreation: ApplicationCreation
    @EnvironmentObject var changedValues: ChangedValues
    @ObservedObject var application: Application
    
    @State var idxName: String = ""
    @State var idxIdentityNumber: String = ""
    @State var accOneName: String = ""
    @State var accOneType: String = ""
    @State var accOneBranchName: String = ""
    @State var accOneBranchNum: String = ""
    @State var accOneNum: String = ""
    @State var accTwoName: String = ""
    @State var accTwoType: String = ""
    @State var accTwoBranchName: String = ""
    @State var accTwoBranchNum: String = ""
    @State var accTwoNum: String = ""
    
    @State var initValues: Dictionary<String, AnyHashable> = [:]
    @State var savingValues: Dictionary<String, AnyHashable> = [:]
    @State var signatureDone: Bool = false
    @State var alertMessage: String = ""
    @State var showingAlert: Bool = false
    @Binding var isDone: Bool
    @State var sender: Sender
    
    let idxComposer = IDXComposer()
    
    // MARK: - init
    init(application: Application, isDone: Binding<Bool>, sender: Sender) {
        self.application = application
        self._isDone = isDone
        self._sender = State(wrappedValue: sender)
        self._idxName = State(wrappedValue: application.idxName ?? "")
        self._idxIdentityNumber = State(wrappedValue: application.idxIdentityNumber ?? "")
        self._accOneName = State(wrappedValue: application.accOneName ?? "")
        self._accOneType = State(wrappedValue: application.accOneType ?? "")
        self._accOneBranchName = State(wrappedValue: application.accOneBranchName ?? "")
        self._accOneBranchNum = State(wrappedValue: application.accOneBranchNum ?? "")
        self._accOneNum = State(wrappedValue: application.accOneNum ?? "")
        self._accTwoName = State(wrappedValue: application.accTwoName ?? "")
        self._accTwoType = State(wrappedValue: application.accTwoType ?? "")
        self._accTwoBranchName = State(wrappedValue: application.accTwoBranchName ?? "")
        self._accTwoBranchNum = State(wrappedValue: application.accTwoBranchNum ?? "")
        self._accTwoNum = State(wrappedValue: application.accTwoNum ?? "")
        
        //self._initValues = State(wrappedValue: ["idxName": idxName, "idxIdentityNumber": idxIdentityNumber, "accOneName": accOneName, "accOneType": accOneType, "accOneBranchName": accOneBranchName, "accOneBranchNum": accOneBranchNum, "accOneNum": accOneNum, "accTwoName": accTwoName, "accTwoType": accTwoType, "accTwoBranchName": accTwoBranchName, "accTwoBranchNum": accTwoBranchNum, "accTwoNum": accTwoNum])
    }
    
    // MARK: - body
    var body: some View {
        Form {
            Section {
                Text("IDX Consent to electronically obtain account statements from financial institutions")
                    .font(.title3)
                    .underline()
                    .bold()
                
                FormTextField(iD: "idxName",
                              question: "Name of account holder (you)*",
                              placeholder: "",
                              text: $idxName)
                
                Text("*One account holder per consent form")
                    .italic()
                    .font(.footnote)
                
                FormTextField(iD: "idxIdentityNumber",
                              question: "Identity/Passport/Registration Number",
                              placeholder: "",
                              text: $idxIdentityNumber)
            }
            
            Section {
                Text("Absa Bank Ltd, First National Bank, a division of FirstRand Bank Ltd, Nedbank Ltd and Standard Bank Ltd (the banks) work with each other and other financial institutions to fight, amongst other crimes, home loan application fraud. In these dealings, the banks ensure that all personal and financial information about clients are protected and kept strictly confidential.")
                
                Text("For the purpose of assessing the home loan application that evo will submit on your behalf to any or all of the banks in the name of \(idxName.isEmpty ? "________________" : idxName), the banks need your consent to obtain your bank statement(s) directly from other financial institutions (as specified below). The financial institutions involved will exchange no further information than the bank statements you have authorized and these will be safeguarded and not used for any other purposes. Bank account statements obtained will also be limited to the period necessary to assess the home loan application.")
                
                Text("Your signature below confirms that the banks have your consent to obtain bank statement(s) on the following account(s) (that show your account required bank statements and if there is a problem with the electronic retrieval of some or all of the for any reason, the banks will contact you to provide physical copies:")
            }
            
            Section(header: Text("ACCOUNT 1")) {
                FormTextField(iD: "accOneName",
                              question: "Name of bank/institution:",
                              placeholder: "",
                              text: $accOneName)
                
                FormTextField(iD: "accOneType",
                              question: "Account type/description:",
                              placeholder: "", text: $accOneType)
                
                FormTextField(iD: "accOneBranchName",
                              question: "Branch name:",
                              placeholder: "",
                              text: $accOneBranchName)
                
                FormTextField(iD: "accOneBranchNum",
                              question: " Branch number:",
                              placeholder: "",
                              text: $accOneBranchNum)
                
                FormTextField(iD: "accOneNum",
                              question: "Account number:",
                              placeholder: "",
                              text: $accOneNum)
            }
            
            Section(header: Text("ACCOUNT 2")) {
                FormTextField(iD: "accTwoName",
                              question: "Name of bank/institution:",
                              placeholder: "",
                              text: $accTwoName)
                
                FormTextField(iD: "accTwoType",
                              question: "Account type/description:",
                              placeholder: "",
                              text: $accTwoType)
                
                FormTextField(iD: "accTwoBranchName",
                              question: "Branch name:",
                              placeholder: "",
                              text: $accTwoBranchName)
                
                FormTextField(iD: "accTwoBranchNum",
                              question: " Branch number:",
                              placeholder: "",
                              text: $accTwoBranchNum)
                
                FormTextField(iD: "accTwoNum",
                              question: "Account number:",
                              placeholder: "",
                              text: $accTwoNum)
            }
            
            Section(header: Text("Signature")) {
                SignatureView(loanID: sender == .creator ? applicationCreation.application.loanID?.uuidString : application.loanID?.uuidString,
                              signatureType: "idx_consent", signatureDone: $signatureDone, alertMessage: $alertMessage, showingAlert: $showingAlert)
                    .frame(height: 300)
            }
            
            Section {
                Button(action: {
                    handleSaving()
                }) {
                    Text("Save changes")
                }
            }
        }
        .navigationBarTitle("IDX Consent")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - determineComplete
    private func determineComplete() -> Bool {
        var isComplete: Bool = false
        
        if signatureDone && !idxName.isEmpty && !idxIdentityNumber.isEmpty && !accOneName.isEmpty && !accOneType.isEmpty && !accOneBranchName.isEmpty && !accOneBranchNum.isEmpty && !accOneNum.isEmpty {
            isComplete = true
        }
        
        return isComplete
    }
    
    /*// MARK: - hasChanged
    private func hasChanged() -> Bool {
        self.savingValues = ["idxName": idxName, "idxIdentityNumber": idxIdentityNumber, "accOneName": accOneName, "accOneType": accOneType, "accOneBranchName": accOneBranchName, "accOneBranchNum": accOneBranchNum, "accOneNum": accOneNum, "accTwoName": accTwoName, "accTwoType": accTwoType, "accTwoBranchName": accTwoBranchName, "accTwoBranchNum": accTwoBranchNum, "accTwoNum": accTwoNum]
        
        if savingValues != initValues {
            return true
        }
        
        alertMessage = "No answers were changed."
        showingAlert = true
        return false
    }*/
    
    // MARK: - handleSaving
    private func handleSaving() {
        let loanID = sender == .creator ? applicationCreation.application.loanID : application.loanID
        let details: [String: String] = ["NAME": idxName, "IDENTITY_NUMBER": idxIdentityNumber, "ACC_ONE_NAME": accOneName, "ACC_ONE_TYPE": accOneType, "ACC_ONE_BRANCH_NAME": accOneBranchName, "ACC_ONE_BRANCH_NUMBER": accOneBranchNum, "ACC_ONE_ACCOUNT_NUMBER": accOneName, "ACC_TWO_NAME": accTwoName, "ACC_TWO_TYPE": accTwoType, "ACC_TWO_BRANCH_NAME": accTwoBranchName, "ACC_TWO_BRANCH_NUMBER": accTwoBranchNum, "ACC_TWO_ACCOUNT_NUMBER": accTwoNum, "loanID": loanID?.uuidString ?? ""]
        //let result = idxComposer.exportHTMLContentToPDF(fileName: "idx_consent_\(loanID?.uuidString ?? "").pdf", details: details)
        
        let result = IDXCreator().exportToPDF(fileName: "idx_consent_\(loanID?.uuidString ?? "").pdf", details: details)
        
        if result.0 {
            presentationMode.wrappedValue.dismiss()
        } else {
            alertMessage = result.1 ?? "Unknown error while saving PDF."
            showingAlert = true
        }
        
        /*isDone = determineComplete()
        
        if isDone {
            updateApplication()
            let loanID = sender == .creator ? applicationCreation.application.loanID : application.loanID
            let details: [String: String] = ["NAME": idxName, "IDENTITY_NUMBER": idxIdentityNumber, "ACC_ONE_NAME": accOneName, "ACC_ONE_TYPE": accOneType, "ACC_ONE_BRANCH_NAME": accOneBranchName, "ACC_ONE_BRANCH_NUMBER": accOneBranchNum, "ACC_ONE_ACCOUNT_NUMBER": accOneName, "ACC_TWO_NAME": accTwoName, "ACC_TWO_TYPE": accTwoType, "ACC_TWO_BRANCH_NAME": accTwoBranchName, "ACC_TWO_BRANCH_NUMBER": accTwoBranchNum, "ACC_TWO_ACCOUNT_NUMBER": accTwoNum, "loanID": loanID?.uuidString ?? ""]
            //let result = idxComposer.exportHTMLContentToPDF(fileName: "idx_consent_\(loanID?.uuidString ?? "").pdf", details: details)
            
            let result = IDXCreator().exportToPDF(fileName: "idx_consent_\(loanID?.uuidString ?? "").pdf", details: details)
            
            if result.0 {
                presentationMode.wrappedValue.dismiss()
            } else {
                alertMessage = result.1 ?? "Unknown error while saving PDF."
                showingAlert = true
            }
        } else if !signatureDone {
            alertMessage = "Please add your signature to continue."
            showingAlert = true
        } else if idxName.isEmpty {
            alertMessage = "Please add your full name to continue."
            showingAlert = true
        } else if idxIdentityNumber.isEmpty {
            alertMessage = "Please add your identity/passport/registration number to continue."
            showingAlert = true
        } else if idxIdentityNumber.isEmpty || accOneName.isEmpty || accOneType.isEmpty || accOneBranchName.isEmpty || accOneBranchNum.isEmpty || accOneNum.isEmpty {
            alertMessage = "Please add your bank details to continue."
            showingAlert = true
        } else {
            alertMessage = "Please complete the form before attempting to save."
            showingAlert = true
        }*/
    }
    
    // MARK: - saveApplication
    private func updateApplication() {
        for (key, value) in changedValues.changedValues {
            if sender == .creator {
                applicationCreation.application.setValue(value, forKey: key)
            } else {
                application.setValue(value, forKey: key)
            }
        }
        
        do {
            try viewContext.save()
            print("print - Application Entity Updated")
            applicationCreation.idxSaved = true
            changedValues.cleanChangedValues()
        } catch {
            print(error.localizedDescription)
        }
    }
}

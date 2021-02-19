//
//  IDXComposer.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/16.
//

import UIKit

class IDXComposer: NSObject {
    
    let pathToIDXHTMLTemplate = Bundle.main.path(forResource: "idx", ofType: "html")
    
    var pdfFileName: String?
    
    override init() {
        super.init()
    }
    
    //func renderIDX(name: String, identityNumber: String, accOneName: String, accOneType: String, accOneBranchName: String, accOneBranchNum: String, accOneNum: String, accTwoName: String, accTwoType: String, accTwoBranchName: String, accTwoBranchNum: String, accTwoNum: String) -> String! {
    func renderIDX(details: [String: String]) -> String! {
        var identityNumberBracketed: String = " "
        if let identityNumber = details["IDENTITY_NUMBER"] {
            for i in 0..<identityNumber.count {
                if i != identityNumber.count - 1 {
                    identityNumberBracketed.append("\(identityNumber[identityNumber.index(identityNumber.startIndex, offsetBy: i)]) | ")
                } else {
                    identityNumberBracketed.append("\(identityNumber[identityNumber.index(identityNumber.startIndex, offsetBy: i)]) ")
                }
            }
        }
        // Store the invoice number for future use.
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent: String = try String(contentsOfFile: pathToIDXHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#NAME#", with: " \(details["NAME"] ?? "") ")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#IDENTITY_NUMBER#", with: identityNumberBracketed)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_ONE_NAME#", with: details["ACC_ONE_NAME"] ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_ONE_TYPE#", with: details["ACC_ONE_TYPE"] ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_ONE_BRANCH_NAME#", with: details["ACC_ONE_BRANCH_NAME"] ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_ONE_BRANCH_NUMBER#", with: details["ACC_ONE_BRANCH_NUMBER"] ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_ONE_ACCOUNT_NUMBER#", with: details["ACC_ONE_ACCOUNT_NUMBER"] ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_TWO_NAME#", with: details["ACC_TWO_NAME"] ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_TWO_TYPE#", with: details["ACC_TWO_TYPE"] ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_TWO_BRANCH_NAME#", with: details["ACC_TWO_BRANCH_NAME"] ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_TWO_BRANCH_NUMBER#", with: details["ACC_TWO_BRANCH_NUMBER"] ?? "")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACC_TWO_ACCOUNT_NUMBER#", with: details["ACC_TWO_ACCOUNT_NUMBER"] ?? "")
            
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
            
            let fileURL = documentsDirectory.appendingPathComponent("idx_consent_signature_\(details["loanID"] ?? "")_image.png")
            
            // Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                //let idxImage = try Data(contentsOf: fileURL)
                //let base64String = idxImage.base64EncodedString()
                //HTMLContent = HTMLContent.replacingOccurrences(of: "#URL#", with: "\(fileURL)")
            }
            
            var dateTime: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.timeStyle = .none
                formatter.locale = Locale(identifier: "en_ZA")
                return formatter
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DATE#", with: "\(dateTime.string(from: Date()))")
            
            //print("print - \(HTMLContent)")
            
            // The HTML code is ready.
            return HTMLContent
        }
        
        catch {
            print("print - Unable to open and use HTML template files.")
        }
        
        return nil
    }
        
        
    func exportHTMLContentToPDF(fileName: String, details: [String: String]) -> (Bool, String?) {
        guard let HTMLContent = renderIDX(details: details) else {
            return (false, "Unable to render IDX Consent PDF")
        }
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return (false, "Unable to access document directory")
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // Image exists, attempt to delete
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("print - Removed old pdf")
            } catch let removeError {
                print("print - Couldn't remove file at path", removeError)
                return (false, removeError.localizedDescription)
            }
        }
        
        do {
            try pdfData?.write(to: fileURL)
            print("print - Added pdf to directory: \(fileURL)")
            return (true, nil)
        } catch let error {
            print("print - Error saving pdf with error", error)
            return (false, error.localizedDescription)
        }
    }
        
        
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return data
    }
}

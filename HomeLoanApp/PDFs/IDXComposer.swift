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
    
    func renderIDX(surname: String?, firstNames: String?, identityNumber: String?) -> String! {
        var identityNumberBracketed: String = ""
        if let identityNumber = identityNumber {
            for i in 0..<identityNumber.count {
                if i != identityNumber.count - 1 {
                    identityNumberBracketed.append("\(identityNumber[identityNumber.index(identityNumber.startIndex, offsetBy: i)]) | ")
                } else {
                    identityNumberBracketed.append("\(identityNumber[identityNumber.index(identityNumber.startIndex, offsetBy: i)])")
                }
            }
        }
        
        // Store the invoice number for future use.
        do {
            // Load the invoice HTML template code into a String variable.
            var HTMLContent = try String(contentsOfFile: pathToIDXHTMLTemplate!)
            
            // Replace all the placeholders with real values except for the items.
            HTMLContent = HTMLContent.replacingOccurrences(of: "#SURNAME#", with: surname ?? "NONE")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#FIRSTNAMES#", with: firstNames ?? "NONE")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#IDENTITY_NUMBER#", with: identityNumberBracketed)
            
            // The HTML code is ready.
            return HTMLContent
        }
        
        catch {
            print("print - Unable to open and use HTML template files.")
        }
        
        return nil
    }
        
        
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        pdfFileName = "test.pdf"
        //pdfData?.write(toFile: pdfFileName ?? "failed.pdf", atomically: true)
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent(pdfFileName ?? "failed.pdf")
        
        do {
            try pdfData?.write(to: fileURL)
            print("print - Added pdf to directory: \(fileURL)")
        } catch let error {
            print("print - Error saving pdf with error", error)
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

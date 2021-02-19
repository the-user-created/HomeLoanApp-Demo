//
//  IDXCreator.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/18.
//

import Foundation
import PDFKit

class IDXCreator: NSObject {
    
    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    let leftBuffer: CGFloat = 70
    let NSStringWidth: CGFloat = 455.2
    
    var pdfFileName: String?
    
    override init() {
        super.init()
    }
    
    func exportToPDF(fileName: String, details: [String: String]) -> (Bool, String?) {
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [
            kCGPDFContextTitle: "Hello, World!",
            kCGPDFContextAuthor: "John Doe"
        ]
        
        format.documentInfo = metaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: A4PageWidth, height: A4PageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            // Perform drawing here
            context.beginPage()
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            // Title
            let titleAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11),
                                    NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let title = "IDX Consent to electronically obtain account statements from financial institutions"
            let titleRect = CGRect(x: leftBuffer, y: 100, width: NSStringWidth, height: 14)
            title.draw(in: titleRect, withAttributes: titleAttributes)
            
            // Name of account holder
            let nameAccHolderAttr = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                      NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let nameAccHolder = "Name of account holder (you)*    | \(details["NAME"] ?? "") |"
            let nameAccHolderRect = CGRect(x: leftBuffer, y: 122, width: NSStringWidth, height: 15)
            nameAccHolder.draw(in: nameAccHolderRect, withAttributes: nameAccHolderAttr)
            
            // * notice
            let noticeAttr = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 8),
                              NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let notice = "*One account holder per consent form"
            let noticeRect = CGRect(x: leftBuffer, y: 140, width: NSStringWidth, height: 12)
            notice.draw(in: noticeRect, withAttributes: noticeAttr)
            
            // Identity Number
            var identityNumberBracketed: String = " "
            if let identityNumber = details["IDENTITY_NUMBER"] {
                for i in 0..<identityNumber.count {
                    if i != identityNumber.count - 1 {
                        identityNumberBracketed.append("\(identityNumber[identityNumber.index(identityNumber.startIndex, offsetBy: i)]) | ")
                    } else {
                        identityNumberBracketed.append("\(identityNumber[identityNumber.index(identityNumber.startIndex, offsetBy: i)])")
                    }
                }
            }
            let idAttr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                              NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let id = "Identity/Passport/Registration Number:    | \(identityNumberBracketed) |"
            let idRect = CGRect(x: leftBuffer, y: 156, width: NSStringWidth, height: 15)
            id.draw(in: idRect, withAttributes: idAttr)
            
            // Legal speak #1
            let legalParaStyle = NSMutableParagraphStyle()
            legalParaStyle.alignment = .left
            legalParaStyle.lineSpacing = 2
            let legalsAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9),
                              NSAttributedString.Key.paragraphStyle: legalParaStyle]
            let legalsOne = "Absa Bank Ltd, First National Bank, a division of FirstRand Bank Ltd, Nedbank Ltd and Standard Bank Ltd (the banks) work with each other and other financial institutions to fight, amongst other crimes, home loan application fraud. In these dealings, the banks ensure that all personal and financial information about clients are protected and kept strictly confidential."
            let legalsOneRect = CGRect(x: leftBuffer, y: 185, width: NSStringWidth, height: 60)
            legalsOne.draw(in: legalsOneRect, withAttributes: legalsAttr)
            
            // Legal speak #2
            let legalsTwo = "For the purpose of assessing the home loan application that evo will submit on your behalf to any or all of the banks in the name of \(details["NAME"] ?? ""), the banks need your consent to obtain your bank statement(s) directly from other financial institutions (as specified below). The financial institutions involved will exchange no further information than the bank statements you have authorized and these will be safegaurded and not used for any other purposes. Bank account statements ontained will also be limited to the period necessary to assess the home loan application."
            let legalsTwoRect = CGRect(x: leftBuffer, y: 250, width: NSStringWidth, height: 80)
            legalsTwo.draw(in: legalsTwoRect, withAttributes: legalsAttr)
            
            // Legal speak #3
            let legalsThree = "Your signature below confirms that the baks have your consent to obtain bank statement(s) on the following account(s) (that show your account transaction history) and if there is a problem with the electronic retrieval of some or all of the required bank statements for any reason, the banks will contact you to provide physical copies:"
            let legalsThreeRect = CGRect(x: leftBuffer, y: 350, width: NSStringWidth, height: 60)
            legalsThree.draw(in: legalsThreeRect, withAttributes: legalsAttr)
            
            // Account 1
            let accHeaderAttr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                 NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let accOne = "Account 1:"
            let accOneRect = CGRect(x: leftBuffer, y: 410, width: NSStringWidth, height: 12)
            accOne.draw(in: accOneRect, withAttributes: accHeaderAttr)
            
            let accDetailsAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
                                     NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let accOneQuestions: [Int: String] = [0: "Name of bank/institution:\t| \(details["ACC_ONE_NAME"] ?? "") |",
                                                  1: "Account type/description:\t| \(details["ACC_ONE_TYPE"] ?? "") |",
                                                  2: "Branch name:\t\t\t| \(details["ACC_ONE_BRANCH_NAME"] ?? "") |    Branch number:    | \(details["ACC_ONE_BRANCH_NUMBER"] ?? "") |",
                                                  3: "Account number:\t\t\t| \(details["ACC_ONE_ACCOUNT_NUMBER"] ?? "") |"]
            for i in 0..<4 {
                let accOne = accOneQuestions[i] ?? ""
                let accOneDetailsRect = CGRect(x: leftBuffer, y: CGFloat(430 + 15*i), width: NSStringWidth, height: 14)
                accOne.draw(in: accOneDetailsRect, withAttributes: accDetailsAttr)
            }
            
            // Account 2
            let accTwo = "Account 2:"
            let accTwoRect = CGRect(x: leftBuffer, y: 500, width: NSStringWidth, height: 12)
            accTwo.draw(in: accTwoRect, withAttributes: accHeaderAttr)
            
            let accTwoQuestions: [Int: String] = [0: "Name of bank/institution:\t| \(details["ACC_TWO_NAME"] ?? "") |",
                                                  1: "Account type/description:\t| \(details["ACC_TWO_TYPE"] ?? "") |",
                                                  2: "Branch name:\t\t\t| \(details["ACC_TWO_BRANCH_NAME"] ?? "") |    Branch number:    | \(details["ACC_TWO_BRANCH_NUMBER"] ?? "") |",
                                                  3: "Account number:\t\t\t| \(details["ACC_TWO_ACCOUNT_NUMBER"] ?? "") |"]
            for i in 0..<4 {
                let accTwo = accTwoQuestions[i] ?? ""
                let accTwoDetailsRect = CGRect(x: leftBuffer, y: CGFloat(520 + 15*i), width: NSStringWidth, height: 14)
                accTwo.draw(in: accTwoDetailsRect, withAttributes: accDetailsAttr)
            }
            
            // Signature and Date
            var dateFormat: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.timeStyle = .none
                formatter.locale = Locale(identifier: "en_ZA")
                return formatter
            }
            let signDateMutable = NSMutableAttributedString(string: "Signature:    ")
            let signatureAttach = NSTextAttachment()
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // IDX consent signature image
                let signatureURL = documentsDirectory.appendingPathComponent("idx_consent_signature_\(details["loanID"] ?? "")_image.png")
                
                if FileManager.default.fileExists(atPath: signatureURL.path) {
                    do {
                        let signatureData = try Data(contentsOf: signatureURL)
                        let signatureImg = UIImage(data: signatureData)
                        let signatureFrame = CGSize(width: 100, height: 70)
                        let widthScaleRatio = signatureFrame.width / (signatureImg?.size.width ?? 1)
                        let heightScaleRatio = signatureFrame.height / (signatureImg?.size.height ?? 1)
                        let scaleFactor = min(widthScaleRatio, heightScaleRatio)

                        // Multiply the original image’s dimensions by the scale factor
                        // to determine the scaled image size that preserves aspect ratio
                        let scaledImageSize = CGSize(
                            width: (signatureImg?.size.width ?? 1) * scaleFactor,
                            height: (signatureImg?.size.height ?? 1) * scaleFactor
                        )
                        
                        if let scaledImg = signatureImg?.scalePreservingAspectRatio(targetSize: scaledImageSize) {
                            signatureAttach.image = scaledImg
                        }
                        print("print - Loaded signature")
                    } catch {
                        print("print - Error loading signature: \(error)")
                    }
                }
            }
            
            let signatureImgString = NSAttributedString(attachment: signatureAttach)
            signDateMutable.append(signatureImgString)
            signDateMutable.append(NSAttributedString(string: "    Date: \(dateFormat.string(from: Date()))"))
            let signDateRect = CGRect(x: leftBuffer, y: 620, width: NSStringWidth, height: 100)
            signDateMutable.draw(in: signDateRect)
        }
        
        let pdfDocument = PDFDocument(data: data)
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return (false, "Unable to access document directory")
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("idx_consent_\(details["loanID"] ?? "").pdf")
        
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
        
        pdfDocument?.write(to: fileURL)
        print("print - Added pdf to directory: \(fileURL)")
        return (true, nil)
    }
}

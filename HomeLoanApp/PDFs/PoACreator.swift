//
//  PoACreator.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/19.
//

import Foundation
import PDFKit

class PoACreator: NSObject {
    
    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    let leftBuffer: CGFloat = 50
    let NSStringWidth: CGFloat = 495.2
    
    var pdfFileName: String?
    var poASignatureSize: CGSize = .zero
    
    override init() {
        super.init()
    }
    
    func exportToPDF(fileName: String, details: [String: String]) -> (Bool, String?) {
        let format = UIGraphicsPDFRendererFormat()
        let metaData = [
            kCGPDFContextTitle: "Power of Attorney",
            kCGPDFContextAuthor: "HomeLoanApp"
        ]
        
        format.documentInfo = metaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: A4PageWidth, height: A4PageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            // Perform drawing here
            context.beginPage()
            
            // Logo
            let logoMutable = NSMutableAttributedString(string: "")
            let logoAttach = NSTextAttachment()
            let logoImg = UIImage(named: "FormLogo")
            let logoFrame = CGSize(width: 200, height: 70)
            let widthScaleRatio = logoFrame.width / (logoImg?.size.width ?? 1)
            let heightScaleRatio = logoFrame.height / (logoImg?.size.height ?? 1)
            let scaleFactor = min(widthScaleRatio, heightScaleRatio)

            let scaledImageSize = CGSize(
                width: (logoImg?.size.width ?? 1) * scaleFactor,
                height: (logoImg?.size.height ?? 1) * scaleFactor
            )
            
            if let scaledImg = logoImg?.scalePreservingAspectRatio(targetSize: scaledImageSize) {
                logoAttach.image = scaledImg
            }
            
            let logoImgString = NSAttributedString(attachment: logoAttach)
            logoMutable.append(logoImgString)
            logoMutable.draw(in: CGRect(x: 330, y: 20, width: 200, height: 70))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            // Title
            let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11),
                                   NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let title = "POWER OF ATTORNEY FOR REQUESTING AND OBTAINING PERSONAL CREDIT RECORDS"
            let titleRect = CGRect(x: leftBuffer, y: 100, width: NSStringWidth, height: 14)
            title.draw(in: titleRect, withAttributes: titleAttributes)
            
            // We, the undersigned
            let nameAccHolderAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
                                     NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let nameAccHolder = "We, the undersigned"
            let nameAccHolderRect = CGRect(x: leftBuffer, y: 125, width: NSStringWidth, height: 12)
            nameAccHolder.draw(in: nameAccHolderRect, withAttributes: nameAccHolderAttr)
            
            // Name
            let nameAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
                            NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let name = "\(details["NAME"] ?? "")\n________________________________________\n[Insert consumer's full name and surname]"
            let nameRect = CGRect(x: leftBuffer, y: 148, width: NSStringWidth, height: 36)
            name.draw(in: nameRect, withAttributes: nameAttr)
            
            // ID Number
            let idAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
                            NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let id = "\(details["IDENTITY_NUMBER"] ?? "")\n________________________________________\n[Insert ID Number]"
            let idRect = CGRect(x: leftBuffer, y: 200, width: NSStringWidth, height: 36)
            id.draw(in: idRect, withAttributes: idAttr)
            
            // Legal speak #1
            let legalParaStyle = NSMutableParagraphStyle()
            legalParaStyle.alignment = .left
            legalParaStyle.lineSpacing = 2
            let legalsAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9),
                              NSAttributedString.Key.paragraphStyle: legalParaStyle]
            let legalsOne = "1. Do hereby appoint \(details["SALES_CONSULTANT"] ?? "") (“our Representative at evo”) to be our lawful representative and agent in our name, place and stead, to obtain a copy of our personal credit reports (“PCR”) from Experian South Africa (Pty) Ltd (“Experian”), to be used solely for the purpose of providing us with advice or assistance with managing our credit, by having reference to the content of our PCR’s."
            let legalsOneRect = CGRect(x: leftBuffer, y: 260, width: NSStringWidth, height: 70)
            legalsOne.draw(in: legalsOneRect, withAttributes: legalsAttr)
            
            // Legal speak #2
            let legalsTwo = "2. We consent to Experian releasing a copy of our PCR to our Representative and to our Representative having sight of the content of our PCR’s for the above purpose."
            let legalsTwoRect = CGRect(x: leftBuffer, y: 330, width: NSStringWidth, height: 20)
            legalsTwo.draw(in: legalsTwoRect, withAttributes: legalsAttr)
            
            // Legal speak #3
            let legalsThree = "3. Attached to this Power of Attorney is a copy of our ID documents."
            let legalsThreeRect = CGRect(x: leftBuffer, y: 370, width: NSStringWidth, height: 12)
            legalsThree.draw(in: legalsThreeRect, withAttributes: legalsAttr)
            
            // Signed at
            let months: [Int: String] = [1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"]
            let days: [Int: String] = [1: "1st", 2: "2nd", 3: "3rd", 21: "21st", 22: "22nd", 23: "23rd", 31: "31st"]
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            let signedAt = "Signed at \(details["LOCATION"] ?? "") on this \((days.keys.contains(day) ? days[day] : "\(day)th") ?? "") day of \(months[month] ?? "") \(year)"
            let signedAtRect = CGRect(x: leftBuffer, y: 400, width: NSStringWidth, height: 12)
            signedAt.draw(in: signedAtRect, withAttributes: legalsAttr)
            
            // Signature
            let signMutable = NSMutableAttributedString(string: "")
            let signatureAttach = NSTextAttachment()
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // PoA signature image
                let signatureURL = documentsDirectory.appendingPathComponent("poa_signature_\(details["loanID"] ?? "")_image.png")
                
                if FileManager.default.fileExists(atPath: signatureURL.path) {
                    do {
                        let signatureData = try Data(contentsOf: signatureURL)
                        let signatureImg = UIImage(data: signatureData)
                        let signatureFrame = CGSize(width: 125, height: 87.5)
                        let widthScaleRatio = signatureFrame.width / (signatureImg?.size.width ?? 1)
                        let heightScaleRatio = signatureFrame.height / (signatureImg?.size.height ?? 1)
                        let scaleFactor = min(widthScaleRatio, heightScaleRatio)

                        // Multiply the original image’s dimensions by the scale factor
                        // to determine the scaled image size that preserves aspect ratio
                        let scaledImageSize = CGSize(
                            width: (signatureImg?.size.width ?? 1) * scaleFactor,
                            height: (signatureImg?.size.height ?? 1) * scaleFactor
                        )
                        poASignatureSize = scaledImageSize
                        
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
            signMutable.append(signatureImgString)
            let signDateRect = CGRect(x: leftBuffer, y: poASignatureSize.height < 50 ? 490 : 450, width: NSStringWidth, height: poASignatureSize.height < 50 ? 60 : 100)
            signMutable.draw(in: signDateRect)
            
            let consumerAttr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let consumer = "________________________________________\nConsumer"
            let consumerRect = CGRect(x: leftBuffer, y: 560, width: NSStringWidth, height: 24)
            consumer.draw(in: consumerRect, withAttributes: consumerAttr)
            
            // Contact details
            let contactHeaderAttr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                     NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let contactHeader = "Consumer Contact Details:"
            let contactHeaderRect = CGRect(x: leftBuffer, y: 610, width: NSStringWidth, height: 12)
            contactHeader.draw(in: contactHeaderRect, withAttributes: contactHeaderAttr)
            
            let contactHeaderTwoAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9),
                                        NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let contactHeaderTwo = "Cell number / other contact number:"
            let contactHeaderTwoRect = CGRect(x: leftBuffer, y: 625, width: NSStringWidth, height: 12)
            contactHeaderTwo.draw(in: contactHeaderTwoRect, withAttributes: contactHeaderTwoAttr)
            
            let contactAttr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                               NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let contact = "\(details["CONTACT"] ?? "")\n________________________________________\n\nConsumer Contact Details"
            let contactRect = CGRect(x: leftBuffer, y: 655, width: NSStringWidth, height: 48)
            contact.draw(in: contactRect, withAttributes: contactAttr)
            
            // Footer
            let footerAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9, weight: .ultraLight),
                              NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let footer = "evo Group (pty) Ltd \u{00b7} reg no. 2007/023685/07\n8th Floor \u{00b7} ooba House \u{00b7} 33 Bree Street \u{00b7} Cape Town \u{00b7} 8001\nP.O Box 1535  \u{00b7}  Cape Town  \u{00b7}  8000  \u{00b7}  T: +27 21 481 7300  \u{00b7}  +27 21 481 7387 Directors: RS Dyer, H Jawitz, AR Rubin\n\nwww.evogroup.co.za \u{00b7} A member of the ooba group"
            /*let footer = NSMutableAttributedString(string: "evo Group (pty) Ltd \u{00b7} reg no. 2007/023685/07\n8th Floor \u{00b7} ooba House \u{00b7} 33 Bree Street \u{00b7} Cape Town \u{00b7} 8001\nP.O Box 1535  \u{00b7}  Cape Town  \u{00b7}  8000  \u{00b7}  T: +27 21 481 7300  \u{00b7}  +27 21 481 7387 Directors: RS Dyer, H Jawitz, AR Rubin\n\nwww.evogroup.co.za \u{00b7} A member of the ooba group")
            footer.addAttribute(.link, value: "www.evogroup.co.za", range: NSRange(location: 209, length: 18))
            footer.setFontFace(font: UIFont.systemFont(ofSize: 9, weight: .ultraLight))*/
            let footerRect = CGRect(x: leftBuffer, y: 740, width: NSStringWidth, height: 56)
            footer.draw(in: footerRect, withAttributes: footerAttr)
        }
        
        let pdfDocument = PDFDocument(data: data)
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return (false, "Unable to access document directory")
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("poa_\(details["loanID"] ?? "").pdf")
        
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

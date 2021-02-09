//
//  MailStructs.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/09.
//

import MessageUI
import SwiftUI

// MARK: - MailView
struct MailView: UIViewControllerRepresentable {
    
    @State var clientName: String
    @State var emailBody: String
    @State var recipients: [String] = [""]
    @State var attachments: [String: Data]
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var submitted: Bool

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        @Binding var submiited: Bool

        init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>, submitted: Binding<Bool>) {
            self._isShowing = isShowing
            self._result = result
            self._submiited = submitted
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            
            self.result = .success(result)
            if result == .sent {
                self.submiited = true
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, result: $result, submitted: $submitted)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject("Loan Application for \(clientName)")
        vc.setMessageBody(emailBody, isHTML: false)
        vc.setToRecipients(recipients)
        
        for (k, v) in attachments {
            vc.addAttachmentData(v, mimeType: "image/png", fileName: k)
        }
        
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {

    }
}

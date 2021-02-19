//
//  Functions.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/28.
//

import Foundation

// MARK: - Functions
func findNth(_ query: String, text: String) -> [String.Index] {
    var searchRange = text.startIndex..<text.endIndex
    var indices: [String.Index] = []
    
    while let range = text.range(of: query, options: .caseInsensitive, range: searchRange) {
        searchRange = range.upperBound..<searchRange.upperBound
        indices.append(range.lowerBound)
    }
    
    return indices
}


// MARK: - otherQuestionCheck
func otherQuestionCheck(other: String, otherText: String) -> OtherQuestionCheck {
    var result: OtherQuestionCheck = .neither
    if !other.dropFirst().isEmpty && !otherText.isEmpty { // Both text fields have a input
        result = .both
    } else if other.dropFirst().isEmpty != otherText.isEmpty { // One text field has a input
        result = .one
    }
    // If both text fields are empty the result is nil
    
    return result
}


// MARK: - makeEmailBody
func makeEmailBody(application: Application) -> String{
    // GENERAL
    var generalDetails = "General Details:\n\n"

    for i in 0..<6 {
        let formID: String = formIDs[0][i] ?? ""
        let value = application.value(forKey: formID) ?? ""
        generalDetails += "\(formQuestions[0][i] ?? "")  =  \(uppercaseIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
    }

    let numberOfApplicants: Int = Int(application.numberOfApplicants ?? "1") ?? 1
    if numberOfApplicants > 1 {
        generalDetails += "Co-Applicant #1  =  \(application.coApplicantOneName ?? "")\n"
        generalDetails += numberOfApplicants >= 3 ? "Co-Applicant #2  =  \(application.coApplicantTwoName ?? "")\n" : ""
        generalDetails += numberOfApplicants == 4 ? "Co-Applicant #3  =  \(application.coApplicantThreeName ?? "")\n" : ""
    }

    // PERSONAL DETAILS
    var personalDetails = "\n\nPersonal Details:\n"

    var i: Int = 0
    while i < 27 {
        let formID = formIDs[1][i] ?? ""
        if i == 5 {
            let identityType: String = (application.value(forKey: formID) ?? "") as! String
            personalDetails += "\(formQuestions[1][5] ?? "")  =  \(identityType.uppercased())\n"
            personalDetails += "\(formQuestions[1][6] ?? "")  =  \(application.value(forKey: formIDs[1][6] ?? "") ?? "")\n"
            if identityType == "Passport" {
                personalDetails += "\(formQuestions[1][10] ?? "")  =  \(dateFormatter.string(from: application.passExpiryDate ?? Date()))\n"
            }
            i += 6
        } else if i == 17 {
            let value = (application.value(forKey: formID) ?? "")  as! String
            personalDetails += "\(formQuestions[1][17] ?? "")  =  \(value.uppercased())\n"
            if value != "Divorced" && value != "Single" { // Checks if the applicant is married
                var j: Int = 18
                while j < 22 {
                    let jFormID = formIDs[1][j] ?? ""
                    let value = application.value(forKey: jFormID) ?? ""
                    personalDetails += "\(formQuestions[1][j] ?? "")  =  \(uppercaseIDs.contains(jFormID) ? (value as! String).uppercased() : value)\n"
                    j += 1
                }
            }
            i += 5
        } else {
            let value = application.value(forKey: formID) ?? ""
            if formID == "dateOfBirth" {
                personalDetails += "\(formQuestions[1][i] ?? "")  =  \(dateFormatter.string(from: application.dateOfBirth ?? Date()))\n"
            } else {
                personalDetails += "\(formQuestions[1][i] ?? "")  =  \(uppercaseIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
            }
            i += 1
        }
    }

    // RESIDENCY & CONTACT
    var residencyContact = "\n\nResidency & Contact:\n"

    i = 0
    while i < 20 {
        let formID: String = formIDs[2][i] ?? ""
        let value = application.value(forKey: formID) ?? ""
        if i == 0 {
            residencyContact += "\(formQuestions[2][i] ?? "")  =  \((value as! String).uppercased())\n"
            if (value as! String) == "No" {
                residencyContact += "\(formQuestions[2][1] ?? "")  =  \(((application.value(forKey: formIDs[2][1] ?? "") ?? "") as! String).uppercased())\n"
                residencyContact += "\(formQuestions[2][2] ?? "")  =  \(((application.value(forKey: formIDs[2][2] ?? "") ?? "") as! String).uppercased())\n"
            }
            
            i += 3
        } else if i == 5 {
            if application.sACitizen == "No" {
                residencyContact += "\(formQuestions[2][i] ?? "")  =  \((value as! String).uppercased())\n"
                if (value as! String) == "No" {
                    let countryPermanentRes = ((application.value(forKey: formIDs[2][6] ?? "") ?? "") as! String).uppercased()
                    residencyContact += "\(formQuestions[2][6] ?? "")  =  \(countryPermanentRes)\n"
                }
            }
            
            i += 2
        } else if i == 18 {
            let value = value as! String
            let openBracketIndices = findNth("[", text: value)
            let closeBracketIndices = findNth("]", text: value)
            
            var lengthAtAddressYears: String = ""
            var lengthAtAddressMonths: String = ""
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                lengthAtAddressYears = String(value[value.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]])
                lengthAtAddressMonths = String(value[value.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]])
            }
            
            residencyContact += "\(formQuestions[2][i] ?? "")  =  \(handleLenAtText(years: lengthAtAddressYears, months: lengthAtAddressMonths))\n"
            i += 1
        } else if i == 10 {
            residencyContact += "\(formQuestions[2][i] ?? "")  =  \(uppercaseIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
            residencyContact += "Residential Address:\n"
            i += 1
        } else {
            residencyContact += "\(formQuestions[2][i] ?? "")  =  \(uppercaseIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
            i += 1
        }
    }

    if application.resIsPostal == "No" {
        residencyContact += "Postal Address:\n"
        residencyContact += "\(formQuestions[2][11] ?? "")  =  \(application.postalCountry ?? "")\n"
        residencyContact += "\(formQuestions[2][12] ?? "")  =  \(application.postalLine1 ?? "")\n"
        residencyContact += "\(formQuestions[2][13] ?? "")  =  \(application.postalLine2 ?? "")\n"
        residencyContact += "\(formQuestions[2][14] ?? "")  =  \(application.postalSuburb ?? "")\n"
        residencyContact += "\(formQuestions[2][15] ?? "")  =  \(application.postalCity ?? "")\n"
        residencyContact += "\(formQuestions[2][16] ?? "")  =  \(application.postalProvince ?? "")\n"
        residencyContact += "\(formQuestions[2][17] ?? "")  =  \(application.postalStreetCode ?? "")\n"
    }

    // SUBSIDY & CREDIT HISTORY
    var subsidyCredit = "\n\nSubsidy & Credit History:\n"

    for i in 0..<12 {
        let value = (application.value(forKey: formIDs[3][i] ?? "") ?? "") as! String
        subsidyCredit += "\(formQuestions[3][i] ?? "")  =  \(value.uppercased())\n"
    }

    // EMPLOYMENT
    var employment = "\n\nEmployment:\n"

    for i in 0..<(application.previouslyEmployed == "Yes" ? 25 : 22) {
        let formID = formIDs[4][i] ?? ""
        let value = application.value(forKey: formID) ?? ""
        if formID == "employmentPeriod" {
            let employValue = value as! String
            let openBracketIndices = findNth("[", text: employValue)
            let closeBracketIndices = findNth("]", text: employValue)
            
            var employmentPeriodYears: String = ""
            var employmentPeriodMonths: String = ""
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                employmentPeriodYears = String(employValue[employValue.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]])
                employmentPeriodMonths = String(employValue[employValue.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]])
            }
            
            employment += "\(formQuestions[4][i] ?? "")  =  \(handleLenAtText(years: employmentPeriodYears, months: employmentPeriodMonths))\n"
        } else if formID == "pEDuration" {
            let pEValue = value as! String
            let openBracketIndices = findNth("[", text: pEValue)
            let closeBracketIndices = findNth("]", text: pEValue)
            
            var pEDurationYears: String = ""
            var pEDurationMonths: String = ""
            
            if !openBracketIndices.isEmpty && !closeBracketIndices.isEmpty {
                pEDurationYears = String(pEValue[pEValue.index(openBracketIndices[0], offsetBy: 1)..<closeBracketIndices[0]])
                pEDurationMonths = String(pEValue[pEValue.index(openBracketIndices[1], offsetBy: 1)..<closeBracketIndices[1]])
            }
            
            employment += "\(formQuestions[4][i] ?? "")  =  \(handleLenAtText(years: pEDurationYears, months: pEDurationMonths))\n"
        } else {
            employment += "\(formQuestions[4][i] ?? "")  =  \(uppercaseIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
        }
    }

    // INCOME & DEDUCTIONS
    var incomeDeductions = "\n\nIncome & Deductions:\n"
    var totalIncome: Int = 0
    var totalDeductions: Int = 0

    for i in 0..<20 {
        let formID: String = formIDs[5][i] ?? ""
        var value: String = (application.value(forKey: formID) as? String) ?? ""
        if (formID == "otherIncome" || formID == "otherDeductions") && !value.isEmpty {
            let open = findNth("[", text: value)
            let close = findNth("]", text: value)
            incomeDeductions += handleOtherRand(value: value, open: open, close: close, j: 5, i: i)
            value = String(value[value.index(open[1], offsetBy: 1)..<close[1]])
        } else if !value.isEmpty {
            let valueFormatted = Int(value.dropFirst())?.formattedWithSeparator
            incomeDeductions += "\(formQuestions[5][i] ?? "")  =  R\(valueFormatted ?? "")\n"
        }
        
        if i < 15 {
            totalIncome = totalIncome.advanced(by: Int(value.dropFirst()) ?? 0)
        } else {
            totalDeductions = totalDeductions.advanced(by: Int(value.dropFirst()) ?? 0)
        }
    }

    let netSalary: String = (totalIncome - totalDeductions).formattedWithSeparator
    incomeDeductions += "\nTotal Income = R\(totalIncome.formattedWithSeparator)\nTotal Deductions = R\(totalDeductions.formattedWithSeparator)\nNet Salary = R\(netSalary)\n"

    // EXPENSES
    var expenses = "\n\nExpenses:\n"
    var totalExpenses: Int = 0

    for i in 0..<25 {
        let formID: String = formIDs[6][i] ?? ""
        var value: String = (application.value(forKey: formIDs[6][i] ?? "") as? String) ?? ""
        if formID == "otherExpenses" && !value.isEmpty {
            let open = findNth("[", text: value)
            let close = findNth("]", text: value)
            expenses += handleOtherRand(value: value, open: open, close: close, j: 6, i: i)
            value = String(value[value.index(open[1], offsetBy: 1)..<close[1]])
        } else if !value.isEmpty {
            let valueFormatted = Int(value.dropFirst())?.formattedWithSeparator
            expenses += "\(formQuestions[6][i] ?? "")  =  R\(valueFormatted ?? "")\n"
        }
        
        totalExpenses = totalExpenses.advanced(by: Int(value.dropFirst()) ?? 0)
    }

    expenses += "\nTotal Expenses = R\(totalExpenses.formattedWithSeparator)\n"

    // ASSETS & LIABILITIES
    var assetsLiabilities = "\n\nAssets & Liabilities:\n"
    var totalAssets: Int = 0
    var totalLiabilities: Int = 0

    for i in 0..<15 {
        let formID = formIDs[7][i] ?? ""
        var value: String = (application.value(forKey: formID) as? String) ?? ""
        if (formID == "otherAsset" || formID == "otherAcc" || formID == "otherLiabilities") && !value.isEmpty {
            let open = findNth("[", text: value)
            let close = findNth("]", text: value)
            assetsLiabilities += handleOtherRand(value: value, open: open, close: close, j: 7, i: i)
            value = String(value[value.index(open[1], offsetBy: 1)..<close[1]])
        } else if !value.isEmpty {
            let valueFormatted = Int(value.dropFirst())?.formattedWithSeparator
            assetsLiabilities += "\(formQuestions[7][i] ?? "")  =  R\(valueFormatted ?? "")\n"
        }
        
        if i < 6 {
            totalAssets = totalAssets.advanced(by: Int(value.dropFirst()) ?? 0)
        } else {
            totalLiabilities = totalLiabilities.advanced(by: Int(value.dropFirst()) ?? 0)
        }
    }

    assetsLiabilities += "\nTotal Assets = R\(totalAssets.formattedWithSeparator)\nTotal Liabilities = R\(totalLiabilities.formattedWithSeparator)\n"

    // NOTIFICATION
    var notification: String = ""
    let clientName = "\(application.surname ?? "NIL"), \(application.firstNames ?? "NIL")"

    if application.notificationsCheck == "Yes" {
        notification = "\n\nThe client \(clientName) has accepted the notification.\n"
    } else {
        notification = "\n\nThe client \(clientName) has not accepted the notification.\n"
    }

    let emailBody = generalDetails + personalDetails + residencyContact + subsidyCredit + employment + incomeDeductions + expenses + assetsLiabilities + notification

    return emailBody
}


// MARK: - getAttachments
func getAttachments(application: Application, scanGroup: [String]) -> [String: Data] {
    var attachments: [String: Data] = [:]
    let loanID: String = application.loanID?.uuidString ?? ""
    
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        // Notification signature Image
        let notificationSignURL = documentsDirectory.appendingPathComponent("notification_signature_\(loanID)_image.png")
        
        if FileManager.default.fileExists(atPath: notificationSignURL.path) {
            do {
                let signatureData = try Data(contentsOf: notificationSignURL)
                attachments.updateValue(signatureData, forKey: "Client_Signature.png")
                print("print - Loaded signature")
            } catch {
                print("print - Error loading signature: \(error)")
            }
        }
        
        /*let signURL = documentsDirectory.appendingPathComponent("idx_consent_signature_\(loanID)_image.png")
        
        if FileManager.default.fileExists(atPath: signURL.path) {
            do {
                let signatureData = try Data(contentsOf: signURL)
                attachments.updateValue(signatureData, forKey: "idx_signature.png")
                print("print - Loaded signature")
            } catch {
                print("print - Error loading signature: \(error)")
            }
        }*/
        
        // Identity Scan(s)
        /*if scanGroup.contains("identity") { // Checking if client did scan a identity document
            let identityType: String = application.identityType ?? ""
            let identityURL = documentsDirectory.appendingPathComponent("identity_scan_\(loanID)_0.png")
            
            if FileManager.default.fileExists(atPath: identityURL.path) {
                do {
                    let identityData = try Data(contentsOf: identityURL)
                    attachments.updateValue(identityData, forKey: "Identity_Scan\(identityType != "Smart ID Card" ? "" : "_1").png")
                    print("print - Loaded identity image #1")
                } catch {
                    print("print - Error loading identity image #1: \(error)")
                }
            }
            
            if identityType == "Smart ID Card" {
                let identityURL = documentsDirectory.appendingPathComponent("identity_scan_\(loanID)_1.png")
                
                if FileManager.default.fileExists(atPath: identityURL.path) {
                    do {
                        let identityData = try Data(contentsOf: identityURL)
                        attachments.updateValue(identityData, forKey: "Identity_Scan_2.png")
                        print("print - Loaded identity image #2")
                    } catch {
                        print("print - Error loading identity image #2: \(error)")
                    }
                }
            }
        }
        
        // Salary / Pay Scan(s)
        if scanGroup.contains("salaryPay") {
            let url = "salary_pay_scan_\(loanID)_"
            var i: Int = 0
            while true {
                let newURL = url + "\(i).png"
                let fileURL = documentsDirectory.appendingPathComponent(newURL)
                
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    // File exists
                    do {
                        let imageData = try Data(contentsOf: fileURL)
                        print("print - Loaded image")
                        attachments.updateValue(imageData, forKey: "Salary_Pay_Scan_#\(i + 1).png")
                    } catch {
                        print("print - Error loading image: \(error)")
                    }
                    
                    i += 1
                } else {
                    // File doesn't exist
                    break
                }
            }
        }
        
        // Bank Statement Scan(s)
        if scanGroup.contains("bankStatements") {
            let url = "bank_statement_scan_\(loanID)_"
            var i: Int = 0
            while true {
                let newURL = url + "\(i).png"
                let fileURL = documentsDirectory.appendingPathComponent(newURL)
                
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    // File exists
                    do {
                        let imageData = try Data(contentsOf: fileURL)
                        print("print - Loaded image")
                        attachments.updateValue(imageData, forKey: "Bank_Statement_Scan_#\(i + 1).png")
                    } catch {
                        print("print - Error loading image: \(error)")
                    }
                    
                    i += 1
                } else {
                    // File doesn't exist
                    break
                }
            }
        }*/
        
        // IDX Consent
        let idxURL = documentsDirectory.appendingPathComponent("idx_consent_\(loanID).pdf")
        
        if FileManager.default.fileExists(atPath: idxURL.path) {
            do {
                let pdfData = try Data(contentsOf: idxURL)
                attachments.updateValue(pdfData, forKey: "IDX_Consent.pdf")
                print("print - Loaded IDX Consent pdf")
            } catch {
                print("print - Error loading IDX Consent pdf: \(error)")
            }
        }
    }
    
    return attachments
}


// MARK: - handleOtherRand
func handleOtherRand(value: String, open: [String.Index], close: [String.Index], j: Int, i: Int) -> String {
    var text: String = ""
    var randValue: String = ""
    
    if !open.isEmpty && !close.isEmpty {
        text = String(value[value.index(open[0], offsetBy: 1)..<close[0]])
        randValue = String(value[value.index(open[1], offsetBy: 1)..<close[1]])
    }
    
    return "\(formQuestions[j][i] ?? "")  =  R\(Int(randValue.dropFirst())?.formattedWithSeparator ?? "") for \(text)\n"
}


// MARK: - handleLenAtText
func handleLenAtText(years: String, months: String) -> String {
    var result: String = ""
    if !years.isEmpty && !months.isEmpty {
        result = "\(years) YEAR\((Int(years) ?? 0) > 1 ? "S" : ""), \(months) MONTH\((Int(months) ?? 0) > 1 ? "S" : "")"
    } else if !years.isEmpty {
        result = "\(years) YEAR\((Int(years) ?? 0) > 1 ? "S" : "")"
    } else if !months.isEmpty {
        result = "\(months) MONTH\((Int(months) ?? 0) > 1 ? "S" : "")"
    }
    
    return result
}

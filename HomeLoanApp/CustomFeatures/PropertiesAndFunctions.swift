//
//  Properties.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/15.
//

import Foundation

// Questions for the form listed by view
let formQuestions: [[Int: String]] = [
    // GENERAL
    [0: "Who is your Sales Consultant?", 1: "What is your application type?",
     2: "What is the applicant type?", 3: "What is the purpose of this loan?",
     4: "What is the property type?", 5: "How many applicants?"],
    // PERSONAL DETAILS
    [0: "What is your title?", 1: "What is your surname?", 2: "What is your first name?", 3: "What is your gender?",
     4: "What is your date of birth?", 5: "What is your identity type?",
     6: "What is your ID / Passport number?", 7: "What is your ID number?", 8: "What is your passport number?", 9: "What is your identity number?", 10: "What is your passport expiry date?", 11: "What is your South African income tax number?", 12: "Do you file any tax return outside of South Africa?",
     13: "What is your highest level of education?", 14: "What is your ethnic group?", 15: "Do you live in a single household?", 16: "What is your current residential status?", 17: "What is your marital status?", 18: "Country of marriage?", 19: "Including spouses income?", 20: "If ANC, register both names?", 21: "Number of dependents:", 22: "Will this property be your main residence?", 23: "Are you a first time home buyer?", 24: "Do you receive a social grant?", 25: "Are you a public official in a position of authority?", 26: "Are you related to or associated to a public official in a position of authority?"],
    // RESIDENCY & CONTACT
    [0: "Are you a South African Citizen?", 1: "What is your nationality?", 2: "Which country issued your passport?",
     3: "What is your country of birth?", 4: "What is your city of birth?", 5: "Are you a permanent South African resident?", 6: "What is your country of permanent residence?", 7: "What is your home language?", 8: "What is your preffered language of correspondence?", 9: "What is your cell number?", 10: "What is your email address?",
     11: "Country:", 12: "Line 1:", 13: "Line 2:", 14: "Suburb:", 15: "City/Town:", 16: "Province:", 17: "Street Code:", 18: "Length at current address:", 19: "Are your postal and residential addresses identical?"],
    // SUBSIDY & CREDIT HISTORY
    [0: "Have your every applied for a subsidy to buy a home?", 1: "Are you applying for a subsidy now?", 2: "Do you belong to a housing scheme?",
     3: "Are you currently under Administration?", 4: "Were you ever under Administration?", 5: "Have you ever had a judgement?",
     6: "Are you currently under Debt Review?", 7: "Are you currently under any debt re-arrangement?", 8: "Have you ever been declared insolvent?",
     9: "Are you currently in a Credit Bureau Dispute?", 10: "Are you aware if any adverse credit listings?", 11: "Are you bound by any surety agreements?"],
    // EMPLOYMENT
    [0: "Occupational Status:", 1: "How are you paid?", 2: "Source of income:", 3: "Nature of Occupation:", 4: "Occupational level:",
     5: "Employment sector:", 6: "Nature of business:", 7: "Employer / Business Name", 8: "Company registration number:", 9: "Employee number:",
     10: "Duration of employment:", 11: "Country:", 12: "Line 1:", 13: "Line 2:", 14: "Suburb:", 15: "City/Town:", 16: "Province:", 17: "Street Code:",
     18: "Work telephone number:", 19: "Does this purchase coincide with a job change?", 20: "Do you work in South Africa?",
     21: "Were you previously employed?", 22: "Previous employer:", 23: "Contact details:", 24: "Duration of employment:"],
    // INCOME & DEDUCTIONS
    [0: "Basic Salary:", 1: "Wages", 2: "Average Commissions", 3: "Investments", 4: "Rental Income", 5: "Future Rental Income", 6: "Housing Subsidy",
     7: "Average Overtime", 8: "Monthly Car Allowance", 9: "Interest Income", 10: "Travel Allowance", 11: "Entertainment", 12: "Income from Sureties",
     13: "Maintenance/Alimony", 14: "Other (specify)", 15: "Tax - PAYE/SITE", 16: "Pension", 17: "UIF", 18: "Medical Aid", 19: "Other (specify)"],
    // EXPENSES
    [0: "Rental", 1: "Investments", 2: "Rates & Taxes", 3: "Water & Lights", 4: "Home Maintenance / Garden Services", 5: "Petrol & Car Maintenance",
     6: "Insurance & Funeral Policies", 7: "Assurance", 8: "Timeshare", 9: "Groceries", 10: "Clothing", 11: "Levies",
     12: "Domestic Wages", 13: "Education", 14: "Entertainment", 15: "Security", 16: "Property Rental Expenses", 17: "Medical", 18: "Donations",
     19: "Cellphone", 20: "M-Net, DSTV & TV License", 21: "Telephone & ISP", 22: "Maintenance / Alimony", 23: "Installment Expenses",
     24: "Other (specify)"],
    // ASSETS & LIABILITIES
    [0: "Fixed Property", 1: "Vehicles", 2: "Furniture & fittings", 3: "Investments", 4: "Cash on Hand", 5: "Other Assets (specify)", 6: "Mortgage bonds",
     7: "Installment sales/lease agreements", 8: "Credit Cards", 9: "Current / Cheque Account", 10: "Personal Loans", 11: "Retail Accounts", 12: "Other Revolving debt", 13: "Other Accounts (specify)", 14: "Other Liabilities (specify)"]
]

let formIDs: [[Int: String]] = [
    // GENERAL
    [0: "salesConsultant", 1: "applicationType",
     2: "applicantType", 3: "loanPurpose",
     4: "propertyType", 5: "numberOfApplicants"],
    // PERSONAL DETAILS
    [0: "title", 1: "surname", 2: "firstNames", 3: "gender", 4: "dateOfBirth", 5: "identityType",
     6: "identityNumber", 7: "skip", 8: "skip", 9: "skip", 10: "passExpiryDate", 11: "taxNumber", 12: "taxReturn",
     13: "educationLevel", 14: "ethnicGroup", 15: "singleHouse", 16: "currentResStatus", 17: "maritalStatus", 18: "countryMarriage", 19: "spouseIncome", 20: "aNC", 21: "numDependents", 22: "mainResidence", 23: "firstTimeHomeBuyer", 24: "socialGrant", 25: "publicOfficial", 26: "relatedOfficial"],
    // RESIDENCY & CONTACT
    [0: "sACitizen", 1: "nationality", 2: "countryPassport",
     3: "countryBirth", 4: "cityOfBirth", 5: "permanentResident", 6: "countryOfPermanentResidence", 7: "homeLanguage", 8: "corresLanguage", 9: "cellNumber",
     10: "emailAddress", 11: "resCountry", 12: "resLine1", 13: "resLine2", 14: "resSuburb", 15: "resCity", 16: "resProvince", 17: "resStreetCode", 18: "lengthAtAddress", 19: "resIsPostal"],
    // SUBSIDY & CREDIT HISTORY
    [0: "subsidyForHome", 1: "applyingSubsidy", 2: "housingScheme", 3: "currentAdmin", 4: "previousAdmin", 5: "judgement", 6: "debtReview", 7: "debtReArrange", 8: "insolvent",
     9: "creditBureau", 10: "creditListings", 11: "suretyAgreements"],
    // EMPLOYMENT
    [0: "occupationalStatus", 1: "payingScheme", 2: "incomeSource", 3: "natureOfOccupation", 4: "occupationLevel",
     5: "employmentSector", 6: "natureOfBusiness", 7: "employer", 8: "companyRegNum", 9: "employeeNum",
     10: "employmentPeriod", 11: "employerCountry", 12: "employerLine1", 13: "employerLine2", 14: "employerSuburb", 15: "employerCity", 16: "employerProvince", 17: "employerStreetCode",
     18: "workPhoneNum", 19: "purchaseJobChange", 20: "workInZA",
     21: "previouslyEmployed", 22: "previousEmployer", 23: "pEContact", 24: "pEDuration"],
    // INCOME & DEDUCTIONS
    [0: "basicSalary", 1: "wages", 2: "averageComm", 3: "investments", 4: "rentIncome", 5: "futureRentIncome", 6: "housingSub",
     7: "averageOvertime", 8: "monthCarAllowance", 9: "interestIncome", 10: "travelAllowance", 11: "entertainment", 12: "incomeFromSureties",
     13: "maintenanceAlimony", 14: "otherIncome", 15: "tax", 16: "pension", 17: "uIF", 18: "medicalAid", 19: "otherDeductions"],
    // EXPENSES
    [0: "rental", 1: "expensesInvestments", 2: "ratesTaxes", 3: "waterLights", 4: "homeMain", 5: "petrolCar",
     6: "insurance", 7: "assurance", 8: "timeshare", 9: "groceries", 10: "clothing", 11: "levies",
     12: "domesticWages", 13: "education", 14: "expensesEntertainment", 15: "security", 16: "propertyRentExp", 17: "medical", 18: "donations",
     19: "cellphone", 20: "mNetDSTV", 21: "telephoneISP", 22: "expensesMaintenanceAlimony", 23: "installmentExp",
     24: "otherExpenses"],
    // ASSETS & LIABILITIES
    [0: "fixedProperty", 1: "vehicles", 2: "furnitureFittings", 3: "assetLiabilityInvestments", 4: "cashOnHand", 5: "otherAsset", 6: "mortgageBonds",
     7: "installmentSales", 8: "creditCards", 9: "currentAcc", 10: "personalLoans", 11: "retailAcc", 12: "otherDebt", 13: "otherAcc", 14: "otherLiabilities"]
]

let uppercasingIDs: [String] = ["salesConsultant", "applicationType", "applicantType", "loanPurpose", "propertyType", "title", "gender", "identityType", "taxReturn", "educationLevel", "ethnicGroup", "singleHouse", "currentResStatus", "maritalStatus", "countryMarriage", "spouseIncome", "aNC", "mainResidence", "firstTimeHomeBuyer", "socialGrant", "publicOfficial", "relatedOfficial", "sACitizen", "nationality", "countryPassport", "countryBirth", "permanentResident", "countryOfPermanentResidence", "homeLanguage", "corresLanguage", "resCountry", "resIsPostal", "postalCountry", "subsidyForHome", "applyingSubsidy", "housingScheme", "currentAdmin", "previousAdmin", "judgement", "debtReview", "debtReArrange", "insolvent", "creditBureau", "creditListings", "suretyAgreements", "occupationalStatus", "payingScheme", "incomeSource", "occupationLevel", "employmentSector", "employerCountry", "purchaseJobChange", "workInZA",
                                "previouslyEmployed"]

let formTextFieldPlaceholders: [[Int: String]] = [
    [5: "1"],
    [1: "Appleseed", 2: "Johnny", 6: "1234567891012", 7: "1234567891012", 8: "123456789", 9: "", 11: "1110502222", 21: "2"],
    [4: "Cape Town", 9: "021 481 7300", 10: "homeloans@ooba.co.za", 12: "33 Bree Street", 13: "8th Floor, ooba House", 14: "City Centre", 15: "Cape Town", 16: "Western Province", 17: "8000"],
    [:],
    [3: "Technician", 6: "Other Service Activities", 7: "Jobs", 8: "", 9: "", 12: "", 13: "", 14: "", 15: "", 16: "", 17: "", 18: "", 22: "", 23: ""]
]

let countries = ["--select--", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d\'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People\'s Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People\'s Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia",
                   "Zimbabwe"]

let salesConsultantEmails: [String: String] = ["Gavin Young": "davidsamuelyoung@protonmail.com"]//"gavinyoung@mweb.co.za"]

var reverseDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter
}

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    return formatter
}

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

func otherQuestionCheck(other: String, otherText: String) -> OtherQuestionCheck {
    var result: OtherQuestionCheck = .neither
    if !other.dropFirst().isEmpty && !otherText.isEmpty { // Both textfields have a input
        result = .both
    } else if other.dropFirst().isEmpty != otherText.isEmpty { // One textfield has a input
        result = .one
    }
    // If both textfields are empty the result is nil
    
    return result
}

// MARK: - makeEmailBody
func makeEmailBody(application: Application) -> String {
    // GENERAL
    var generalDetails = "General Details:\n\n"

    for i in 0..<6 {
        let formID: String = formIDs[0][i] ?? ""
        let value = application.value(forKey: formID) ?? ""
        generalDetails += "\(formQuestions[0][i] ?? "")  =  \(uppercasingIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
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
                    personalDetails += "\(formQuestions[1][j] ?? "")  =  \(uppercasingIDs.contains(jFormID) ? (value as! String).uppercased() : value)\n"
                    j += 1
                }
            }
            i += 5
        } else {
            let value = application.value(forKey: formID) ?? ""
            if formID == "dateOfBirth" {
                personalDetails += "\(formQuestions[1][i] ?? "")  =  \(dateFormatter.string(from: application.dateOfBirth ?? Date()))\n"
            } else {
                personalDetails += "\(formQuestions[1][i] ?? "")  =  \(uppercasingIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
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
                    let countryPermaRes = ((application.value(forKey: formIDs[2][6] ?? "") ?? "") as! String).uppercased()
                    residencyContact += "\(formQuestions[2][6] ?? "")  =  \(countryPermaRes)\n"
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
        } else {
            residencyContact += "\(formQuestions[2][i] ?? "")  =  \(uppercasingIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
            i += 1
        }
    }

    if application.resIsPostal == "No" {
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
            employment += "\(formQuestions[4][i] ?? "")  =  \(uppercasingIDs.contains(formID) ? (value as! String).uppercased() : value)\n"
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

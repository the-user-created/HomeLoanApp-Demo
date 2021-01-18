//
//  Properties.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/15.
//

import Foundation

// Questions for the form listed by view
let formQuestions: [[Double: String]] = [
    // GENERAL
    [0: "Who is your Sales Consultant?", 1: "What is your application type?",
     2: "Are you an individual or ...", 3: "What is the purpose of this loan?",
     4: "What is the property type?", 5: "How many applicants?"],
    // PERSONAL DETAILS
    [0: "What is your title?", 1: "What is your surname?", 2: "What is your first name?", 3: "What is your gender?",
     4: "What is your date of birth?", 5: "What is your identity type?",
     6: "What is your ID / Passport number?", 6.1: "What is your ID number?", 6.2: "What is your passport number?",
     7: "What is your ID / Passport expiry date?", 7.1: "What is your ID expiry date?", 7.2: "What is your passport expiry date?",
     8: "What is your South African income tax number?", 9: "Do you file any tax return outside of South Africa?",
     10: "What is your highest level of education?", 11: "What is your ethnic group?", 12: "Do you live in a single household?", 13: "What is your marital status?",
     13.1: "Country of marriage?", 13.2: "Including spouses income?", 13.3: "If ANC, register both names?", 13.4: "Number of dependents:",
     14: "Will this property be your main residence?", 15: "Are you a first time home buyer?", 16: "Do you receive a social grant?",
     17: "Are you a public official in a position of authority?", 18: "Are you related to or associated to a public official in a position of authority?"],
    // RESIDENCY & CONTACT
    [0: "Are you a South African Citizen?", 0.1: "What is your nationality?", 0.2: "Which country issued your passport?",
     1: "What is your country of birth?", 2: "What is your city of birth?",
     3: "Are you a permanent South African resident?", 3.1: "What is your country of permanent residence?", 4: "What is your permit type?",
     5: "Which country issued your permit?", 6: "What is the permit issue date?", 7: "What is the permit expiry date?",
     8: "What is your work contract issue date?", 9: "What is you work contract expiry date?", 10: "What is your work permit number?",
     11: "What is your home language?", 12: "What is your preffered language of correspondence?", 13: "What is your cell number?",
     14: "What is your email address?", 15: "Country:", 15.1: "Line 1:", 15.2: "Line 2:", 15.3: "Suburb:", 15.4: "City/Town:", 15.5: "Province:",
     15.6: "Street Code:", 15.7: "Length at current address:", 16: "Are your postal and residential addresses identical?"],
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
     21: "Were you previously employed?", 21.1: "Previous employer:", 21.2: "Contact details:", 21.3: "Duration of employment:"],
    // INCOME & DEDUCTIONS
    [0: "Basic Salary:", 1: "Wages", 2: "Average Commissions", 3: "Investments", 4: "Rental Income", 5: "Future Rental Income", 6: "Housing Subsidy",
     7: "Average Overtime", 8: "Monthly Car Allowance", 9: "Interest Income", 10: "Travel Allowance", 11: "Entertainment", 12: "Income from Sureties",
     13: "Maintenance/Alimony", 14: "Other (specify)", 15: "Tax - PAYE/SITE", 16: "Pension", 17: "UIF", 18: "Medical Aid", 19: "Other (specify)"],
    // EXPENSES
    [0: "Rental", 1: "Investments\n(Unit Trusts, Endowments)", 2: "Rates & Taxes", 3: "Water & Lights", 4: "Home Maintenance / Garden Services",
     5: "Insurance & Funeral Policies", 6: "Assurance\n(Life, Retirement Annuities)", 7: "Timeshare", 8: "Groceries", 9: "Clothing", 10: "Levies",
     11: "Domestic Wages", 12: "Education", 13: "Entertainment", 14: "Security", 15: "Property Rental Expenses", 16: "Medical", 17: "Donations",
     18: "Cellphone", 19: "M-Net, DSTV & TV License", 20: "Telephone & ISP", 21: "Maintenance / Alimony", 22: "Installment Expenses",
     23: "Other (specify)"],
    // ASSETS & LIABILITIES
    [0: "Fixed Property", 1: "Vehicles", 2: "Furniture & fittings", 3: "Investments", 4: "Cash on Hand", 5: "Other Assets (specify)", 6: "Mortgage bonds",
     7: "Installment sales/lease agreements", 8: "Credit Cards", 9: "Current / Cheque Account", 10: "Personal Loans", 11: "Retail Accounts", 12: "Other Revolving debt", 13: "Other Accounts (specify)", 14: "Other Liabilities (specify)"]
]

let formTextFieldPlaceholders = [
    [5: "1"],
    [1: "Appleseed", 2: "Johnny", 6: "1234567891011", 8: "1110502222", 13.4: "2"],
    [2: "Cape Town", 10: "VX7VVWI", 13: "021 481 7300", 14: "homeloans@ooba.co.za", 15.1: "33 Bree Street", 15.2: "8th Floor, ooba House", 15.3: "City Centre", 15.4: "Cape Town", 15.5: "Western Province", 15.6: "8000"],
    [:],
    [3: "Technician", 6: "Other Service Activities", 7: "Jobs", 8: "", 9: "", 12: "", 13: "", 14: "", 15: "", 16: "", 17: "", 18: "", 21.1: "", 21.2: ""]
]

let countries = ["--select--", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d\'Ivoire", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People\'s Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People\'s Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia, The Former Yugoslav Republic of", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia (Slovak Republic)", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbard and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia",
                   "Zimbabwe"]

var reverseDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter
}

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
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

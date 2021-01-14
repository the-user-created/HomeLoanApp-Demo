//
//  HomeLoanAppApp.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/22.
//

import Foundation
import Combine
import SwiftUI
import Vision
import VisionKit
import CoreData
import Firebase
import FirebaseAuth

// MARK: - Properties
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

// Stores each of the changed key-value pairs of the questions and answers in the form
var changedValues: Dictionary<String, Any> = [:]

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

// MARK: - enums
enum ChoosePageVer {
    case editor
    case creator
}

// MARK: - structs
struct HandleChangedValues {
    func updateKeyValue(_ key: String, value: Any) {
        changedValues.updateValue(value, forKey: key)
    }
    
    func cleanChangedValues() {
        changedValues.removeAll()
    }
}

struct FormDatePicker: View {
    var handleChangedValues = HandleChangedValues()
    
    var iD: String
    var pageNum: Int
    var textColor: Color = .primary
    var question: String
    var dateRangeOption: Int
    @Binding var dateSelection: Date
    
    var body: some View {
        // Using: negative infinity up to current date
        if dateRangeOption == 0 {
            DatePicker(selection: $dateSelection,
                       in: ...Date(),
                       displayedComponents: .date) {
                
                Text(question)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
            }
            .onChange(of: self.dateSelection, perform: { _ in
                handleChangedValues.updateKeyValue(iD, value: dateSelection)
            })
        } else if dateRangeOption == 1 { // Using: from current date to infinity
            DatePicker(selection: $dateSelection,
                       in: Date()...,
                       displayedComponents: .date) {
                
                Text(question)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
            }
            .onChange(of: self.dateSelection, perform: { _ in
                handleChangedValues.updateKeyValue(iD, value: dateSelection)
            })
        }
    }
}

struct FormPicker: View {
    var handleChangedValues = HandleChangedValues()
    
    var iD: String
    var pageNum: Int
    var textColor: Color = .primary
    var question: String
    var selectionOptions: Array<String>
    @Binding var selection: Int
    
    var body: some View {
        Picker(selection: $selection,
               label: Text(question)
                .foregroundColor(textColor)
                .multilineTextAlignment(.leading)) {
            ForEach(0 ..< selectionOptions.count) {
                Text(self.selectionOptions[$0])
                    .foregroundColor(self.selectionOptions[$0] == "--select--" ? .secondary: .blue)
            }
        }
        .onChange(of: selection, perform: { value in
            handleChangedValues.updateKeyValue(iD, value: selectionOptions[selection])
        })
    }
}

struct FormTextField: View {
    var handleChangedValues = HandleChangedValues()
    
    var iD: String
    var pageNum: Int
    var question: String
    var placeholder: String
    var textColor: Color = .primary
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        let binding = Binding<String>(get: {
            self.text
        }, set: {
            self.text = $0.uppercased()
        })
        
        HStack() {
            if question != "" {
                Text(question)
            }
            
            TextField("e.g. " + placeholder.uppercased(),
                      text: binding,
                      onEditingChanged: { _ in
                        handleChangedValues.updateKeyValue(iD, value: binding.wrappedValue)
                      },
                      onCommit: commit)
                .foregroundColor(.blue)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct FormRandTextField: View {
    var handleChangedValues = HandleChangedValues()
    
    var iD: String
    var pageNum: Int
    var question: String
    var textColor: Color = .primary
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        HStack() {
            Text(question)
            
            TextField("R",
                      text: $text,
                      onEditingChanged: { _ in
                        handleChangedValues.updateKeyValue(iD, value: text)
                      },
                      onCommit: commit)
                .foregroundColor(.primary)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .onChange(of: text, perform: { value in
                    if !text.contains("R") {
                        text = "R" + text
                    }
                })
        }
    }
}

struct FormOtherQuestion: View {
    var handleChangedValues = HandleChangedValues()
    
    var iD: String
    var pageNum: Int
    var question: String
    var textColor: Color = .primary
    @Binding var other: String
    @Binding var otherText: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        let binding = Binding<String>(get: {
            self.otherText
        }, set: {
            self.otherText = $0.uppercased()
        })
        
        VStack() {
            HStack() {
                Text(question)
                
                TextField("R",
                          text: $other, onEditingChanged: { _ in sendToDictionary()},
                          onCommit: commit)
                    .foregroundColor(.primary)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .onChange(of: other, perform: { value in
                        if !other.contains("R") {
                            other = "R" + other
                        }
                    })
                }
            
                TextField("specify...",
                          text: binding, onEditingChanged: { _ in sendToDictionary()},
                          onCommit: commit)
                    .foregroundColor(.primary)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.alphabet)
        }
    }
    
    private func sendToDictionary() {
        handleChangedValues.updateKeyValue(iD, value: "[\(self.otherText)][\(self.other)]")
    }
}

struct FormLenAt: View {
    var handleChangedValues = HandleChangedValues()
    
    var iD: String
    var pageNum: Int
    var question: String
    var textColor: Color = .primary
    @Binding var yearsText: String
    @Binding var monthsText: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        VStack() {
            Text(question)
            
            HStack() {
                TextField("",
                          text: $yearsText,
                          onEditingChanged: { _ in sendToDictionary()},
                          onCommit: commit)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Text("Years")
            }
            
            HStack() {
                TextField("",
                          text: $monthsText,
                          onEditingChanged: { _ in sendToDictionary()},
                          onCommit: commit)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Text("Months")
            }
        }
    }
    
    func sendToDictionary() {
        let thisString = "[\(self.yearsText)][\(self.monthsText)]"
        
        handleChangedValues.updateKeyValue(iD, value: thisString)
    }
}

struct FormYesNo: View {
    var handleChangedValues = HandleChangedValues()
    
    var iD: String
    var pageNum: Int
    var question: String
    let buttonOneText: String = "Yes"
    let buttonTwoText: String = "No"
    var buttonOneImage: String = "checkmark.circle"
    var buttonTwoImage: String = "checkmark.circle"
    @Binding var selected: String
    @State var buttonOneChecked: Bool = false
    @State var buttonTwoChecked: Bool = false
    var padding: CGFloat = 10
    
    init(iD: String, pageNum: Int, question: String, selected: Binding<String>) {
        self.iD = iD
        self.pageNum = pageNum
        self.question = question
        self._selected = selected
        if self.selected == "Yes" {
            self._buttonOneChecked = State(wrappedValue: true)
        } else if self.selected == "No" {
            self._buttonTwoChecked = State(wrappedValue: true)
        }
        
        if self.iD == "notificationsCheck" {
            self.padding = 4
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(question)
                .multilineTextAlignment(.center)
            
            HStack() {
                Spacer()
                
                Button(action: {
                    handleButtons(buttonOneText)
                }, label: {
                    if buttonOneChecked || selected == "Yes" {
                        Image(systemName: buttonOneImage + ".fill")
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: buttonOneImage)
                            .foregroundColor(.blue)
                    }
                    Text(buttonOneText)
                        .foregroundColor(.primary)
                })
                .padding([.top, .bottom], padding)
                .buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
                Button(action: {
                    handleButtons(buttonTwoText)
                }, label: {
                    if buttonTwoChecked || selected == "No" {
                        Image(systemName: buttonTwoImage + ".fill")
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: buttonTwoImage)
                            .foregroundColor(.blue)
                    }
                    Text(buttonTwoText)
                        .foregroundColor(.primary)
                })
                .padding([.top, .bottom], padding)
                .buttonStyle(BorderlessButtonStyle())
                
                Spacer()
            }
        }
    }
    
    func handleButtons(_ checkedButton: String) {
        if checkedButton == "Yes" {
            if !self.buttonOneChecked {
                self.buttonOneChecked.toggle()
                self.selected = buttonOneText
            } else {
                self.buttonOneChecked.toggle()
                self.selected = "TBA"
            }
            
            if self.buttonTwoChecked {
                self.buttonTwoChecked.toggle()
            }
        } else if checkedButton == "No" {
            if !self.buttonTwoChecked {
                self.buttonTwoChecked.toggle()
                self.selected = buttonTwoText
            } else {
                self.buttonTwoChecked.toggle()
                self.selected = "TBA"
            }
            
            if self.buttonOneChecked {
                self.buttonOneChecked.toggle()
            }
        }
        
        handleChangedValues.updateKeyValue(iD, value: selected)
        
    }
}

struct ScannerView: UIViewControllerRepresentable {
    private let completionHandler: ([String]?) -> Void
    private let scanName: String
        
    init(completion: @escaping ([String]?) -> Void, scanName: String) {
        self.completionHandler = completion
        self.scanName = scanName
    }
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
     
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {
        // nil
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler, scanName: self.scanName)
    }
     
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: ([String]?) -> Void
        private let scanName: String
                
        init(completion: @escaping ([String]?) -> Void, scanName: String) {
            self.completionHandler = completion
            self.scanName = scanName
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            print("Document camera view controller did finish with ", scan)
            for scanIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: scanIndex)
                if let cgImage = image.cgImage {
                    saveImage("\(self.scanName)_image_\(scanIndex).png", image: UIImage(cgImage: cgImage))
                }
            }
            
            controller.navigationController?.popViewController(animated: true)
            completionHandler(nil)
        }
         
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            // nil
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
        
        func saveImage(_ imageName: String, image: UIImage) {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

            let fileName = imageName
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            guard let data = image.pngData() else { return }

            //Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("Removed old image")
                } catch let removeError {
                    print("couldn't remove file at path", removeError)
                }

            }
            // Writes the image to the directory
            do {
                try data.write(to: fileURL)
            } catch let error {
                print("error saving file with error", error)
            }

        }
        
        func documentDirectoryPath() -> URL? {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return path.first
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    var textColor: Color = .black
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
            }
            
            TextField(placeholder,
                      text: $text,
                      onEditingChanged: editingChanged,
                      onCommit: commit)
                .foregroundColor(textColor)
        }
    }
}

struct PasswordTextField: View {
    // Always has the same text color unless set during struct call
    @Binding var showPassword: Bool
    @Binding var password : String
    var textColor: Color = .black
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        HStack() {
            Image(systemName: "lock")
                .foregroundColor(.gray)
                .padding(.leading, 3)
            
            ZStack(alignment: .leading) {
                if password.isEmpty {
                    Text("Password...")
                        .foregroundColor(.gray)
                }
                
                if showPassword {
                    TextField("Password...",
                              text: $password)
                        .foregroundColor(textColor)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                } else {
                    SecureField("Password...",
                                text: $password)
                        .foregroundColor(textColor)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
            }
            
            Button(action: {
                showPassword.toggle()
            }) {
                if showPassword {
                    Image(systemName: "eye.slash")
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "eye")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isShowing: Bool
    @Binding var text: String
    
    @State var isPasswordAlert: Bool = false
    @State private var showPassword: Bool = false
    
    let presenting: Presenting
    let title: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                VStack {
                    Text(self.title)
                        .font(.title2)
                    
                    Divider()
                    
                    if isPasswordAlert {
                        PasswordTextField(showPassword: $showPassword,
                                          password: $text,
                                          textColor: colorScheme == .dark ? .black : .white)
                            .padding()
                            .background(Capsule().fill(colorScheme == .dark ? Color.white : Color.black))
                    } else {
                        TextField("", text: $text)
                    }
                    
                    Divider()
                    
                    HStack() {
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            backgroundForButton(btnText: "OK", btnColor: .blue)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .padding()
                .background(colorScheme == .dark ? Color.black : Color.white)
                .opacity(self.isShowing ? 1 : 0)
                .frame(width: geometry.size.width*0.9)
                .foregroundColor(Color.primary)
                .cornerRadius(20)
            }
        }
    }

}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}

struct backgroundForButton: View {
    
    var btnText: String
    var fWidth: CGFloat = 140
    var fHeight: CGFloat = 50
    var btnColor: Color = .blue
    
    var body: some View {
        HStack {
            Text(btnText)
                .font(.headline)
                .foregroundColor(.white)
                //.padding()
                .frame(width: fWidth, height: fHeight)
                .background(btnColor)
                .clipped()
                .cornerRadius(5.0)
                .shadow(color: btnColor, radius: 5, x: 0, y: 5)
            
        }
    }
}

// Used to allow easy in-string formatting
struct RichText: View {

    struct Element: Identifiable {
        let id = UUID()
        let content: String
        let isBold: Bool

        init(content: String, isBold: Bool) {
            var content = content.trimmingCharacters(in: .whitespacesAndNewlines)

            if isBold {
                content = content.replacingOccurrences(of: "*", with: "")
            }

            self.content = content
            self.isBold = isBold
        }
    }

    let elements: [Element]

    init(_ content: String) {
        elements = content.parseRichTextElements()
    }

    var body: some View {
        var content = text(for: elements.first!)
        elements.dropFirst().forEach { (element) in
            content = content + self.text(for: element)
        }
        return content
    }

    private func text(for element: Element) -> Text {
        let postfix = shouldAddSpace(for: element) ? " " : ""
        if element.isBold {
            return Text(element.content + postfix)
                .fontWeight(.bold)
        } else {
            return Text(element.content + postfix)
        }
    }

    private func shouldAddSpace(for element: Element) -> Bool {
        return element.id != elements.last?.id
    }
}

struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 6
    var numOfShakes: CGFloat = 4
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX: travelDistance * sin(animatableData * .pi * numOfShakes), y: 0)
        )
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}

// MARK: - Extensions
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func textFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                        title: String,
                        isPasswordAlert: Bool) -> some View {
        TextFieldAlert(isShowing: isShowing,
                       text: text,
                       isPasswordAlert: isPasswordAlert,
                       presenting: self,
                       title: title)
    }
}

extension String {

    /// Parses the input text and returns a collection of rich text elements.
    /// Currently supports asterisks only. E.g. "Save *everything* that *inspires* your ideas".
    ///
    /// - Returns: A collection of rich text elements.
    func parseRichTextElements() -> [RichText.Element] {
        let regex = try! NSRegularExpression(pattern: "\\*{1}(.*?)\\*{1}")
        let range = NSRange(location: 0, length: count)

        /// Find all the ranges that match the regex *CONTENT*.
        let matches: [NSTextCheckingResult] = regex.matches(in: self, options: [], range: range)
        let matchingRanges = matches.compactMap { Range<Int>($0.range) }

        var elements: [RichText.Element] = []

        // Add the first range which might be the complete content if no match was found.
        // This is the range up until the lowerbound of the first match.
        let firstRange = 0..<(matchingRanges.count == 0 ? count : matchingRanges[0].lowerBound)

        self[firstRange].components(separatedBy: " ").forEach { (word) in
            guard !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            elements.append(RichText.Element(content: String(word), isBold: false))
        }

        // Create elements for the remaining words and ranges.
        for (index, matchingRange) in matchingRanges.enumerated() {
            let isLast = matchingRange == matchingRanges.last

            // Add an element for the matching range which should be bold.
            let matchContent = self[matchingRange]
            elements.append(RichText.Element(content: matchContent, isBold: true))

            // Add an element for the text in-between the current match and the next match.
            let endLocation = isLast ? count : matchingRanges[index + 1].lowerBound
            let range = matchingRange.upperBound..<endLocation
            self[range].components(separatedBy: " ").forEach { (word) in
                guard !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                elements.append(RichText.Element(content: String(word), isBold: false))
            }
        }

        return elements
    }

    /// - Returns: A string subscript based on the given range.
    subscript(range: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(self.startIndex, offsetBy: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension UIDevice {
    /// Code Provided by HAS and Harshil Patel at `https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model`
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            switch identifier {
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
                case "iPhone11,8":                              return "iPhone XR"
                case "iPhone12,1":                              return "iPhone 11"
                case "iPhone12,3":                              return "iPhone 11 Pro"
                case "iPhone12,5":                              return "iPhone 11 Pro Max"
                case "iPhone12,8":                              return "iPhone SE (2nd generation)"
                case "iPhone13,1":                              return "iPhone 12 mini"
                case "iPhone13,2":                              return "iPhone 12"
                case "iPhone13,3":                              return "iPhone 12 Pro"
                case "iPhone13,4":                              return "iPhone 12 Pro Max"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
            }
        }

        return mapToDevice(identifier: identifier)
    }()

}

// MARK: - Classes
class UserSettings: ObservableObject {
    @Published var loggedIn: Bool = UserDefaults.standard.bool(forKey: "loggedIn")
}

class UserOnboard: ObservableObject {
    // Include this only if a tutorial is used
    @Published var onboardComplete: Bool = true
}

class UserDetails: ObservableObject {
    var firstNames: String = ""
    var surname: String = ""
    var email: String = ""
}

class ApplicationDetails: ObservableObject {
    var appID: UUID = UUID()
}

class ApplicationCreation: ObservableObject {
    @Published var application: Application = Application()
    @Published var assetsLiabilitiesSaved: Bool = false
    @Published var residencyContactSaved: Bool = false
    @Published var personalDetailsSaved: Bool = false
    @Published var generalDetailsSaved: Bool = false
    @Published var subsidyCreditSaved: Bool = false
    @Published var notificationSaved: Bool = false
    @Published var employmentSaved: Bool = false
    @Published var expensesSaved: Bool = false
    @Published var incomeSaved: Bool = false
    
    func makeApplication() {
        self.application = Application(context: PersistenceController.shared.container.viewContext)
    }
    
    func removeApplicationFromMemory() {
        self.application = Application()
        self.generalDetailsSaved = false
        self.assetsLiabilitiesSaved = false
        self.residencyContactSaved = false
        self.personalDetailsSaved = false
        self.subsidyCreditSaved = false
        self.notificationSaved = false
        self.employmentSaved = false
        self.expensesSaved = false
        self.incomeSaved = false
    }
}

// MARK: - Main
@main
struct HomeLoanApp: App {
    let persistenceController = PersistenceController.shared
    var userDetails = UserDetails()
    var settings = UserSettings()
    var applicationCreation = ApplicationCreation()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Main(userDetails: userDetails)
                .environmentObject(settings)
                .environmentObject(applicationCreation)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  FormStructs.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/09.
//

import SwiftUI

// MARK: - AssetLiabilityInfo
struct AssetLiabilityInfo: View {
    var whichInfo: String
    @State var infoString: String = ""
    @State var infoShowing: Bool = false
    
    var body: some View {
        HStack {
            Text(whichInfo == "assets" ? "ASSETS" : "LIABILITIES")
            
            Button(action: {
                self.infoShowing = true
                infoString = whichInfo == "assets" ? "An asset is something which you own. Estimate its value." : "A liability is something which you owe. Estimate what you owe."
            }) {
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 16.0, height: 16.0)
        }
        .alert(isPresented: $infoShowing) {
            Alert(title: Text("Info"), message: Text(infoString), dismissButton: .default(Text("OK")))
        }
    }
}


// MARK: - FormLabel
struct FormLabel: View {
    var iD: String
    var question: String
    var textColor: Color = .primary
    var infoButton: Bool = false
    @State var infoShowing: Bool = false
    
    var body: some View {
        HStack {
            Text(question)
                .foregroundColor(textColor)
                .multilineTextAlignment(.leading)
            
            if infoButton {
                Button(action: {
                    self.infoShowing = true
                }) {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 22.0, height: 22.0)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .alert(isPresented: $infoShowing) {
            Alert(title: Text("Info"), message: Text(infos[iD] ?? "MISSING"), dismissButton: .default(Text("OK")))
        }
    }
}


// MARK: - FormDatePicker
struct FormDatePicker: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
    var textColor: Color = .primary
    var infoButton: Bool = false
    var question: String
    var dateRangeOption: Int
    @Binding var dateSelection: Date
    
    var body: some View {
        // Using: negative infinity up to current date
        if dateRangeOption == 0 {
            DatePicker(selection: $dateSelection,
                       in: ...Date(),
                       displayedComponents: .date) {
                
                FormLabel(iD: iD, question: question, infoButton: infoButton)
            }
            .onChange(of: dateSelection, perform: { _ in
                changedValues.updateKeyValue(iD, value: dateSelection)
            })
        } else if dateRangeOption == 1 { // Using: from current date to infinity
            DatePicker(selection: $dateSelection,
                       in: Date()...,
                       displayedComponents: .date) {
                
                FormLabel(iD: iD, question: question, infoButton: infoButton)
            }
            .onChange(of: dateSelection, perform: { _ in
                changedValues.updateKeyValue(iD, value: dateSelection)
            })
        }
    }
}


// MARK: - FormPicker
struct FormPicker: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
    var textColor: Color = .primary
    var infoButton: Bool = false
    var question: String
    var selectionOptions: Array<String>
    @Binding var selection: Int
    
    var body: some View {
        HStack {
            Picker(selection: $selection,
                   label: FormLabel(iD: iD, question: question, infoButton: infoButton)) {
                ForEach(0 ..< selectionOptions.count) {
                    Text($0 == 0 ? selectionOptions[$0] : selectionOptions[$0])
                        .foregroundColor(selectionOptions[$0] == "--select--" ? .secondary: .blue)
                }
            }
            .onChange(of: selection) { value in
                changedValues.updateKeyValue(iD, value: selectionOptions[value])
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}


// MARK: - FormVStackTextField
struct FormVStackTextField: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
    var infoButton: Bool = false
    var question: String
    var placeholder: String
    var textColor: Color = .primary
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var notIgnoredExampleIDs: [String] = ["emailAddress"]
    
    var body: some View {
        let binding = Binding<String>(get: {
            text
        }, set: {
            self.text = $0.uppercased()
        })
        
        VStack {
            if question != "" {
                FormLabel(iD: iD,
                          question: question,
                          infoButton: infoButton)
            }
            
            TextField(notIgnoredExampleIDs.contains(iD) ? "e.g. " + placeholder.uppercased() : placeholder,
                      text: binding,
                      onEditingChanged: { _ in
                        changedValues.updateKeyValue(iD, value: binding.wrappedValue)
                      },
                      onCommit: commit)
                .foregroundColor(.blue)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}


// MARK: - FormTextField
struct FormTextField: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
    var infoButton: Bool = false
    var question: String
    var placeholder: String
    var textColor: Color = .primary
    @Binding var text: String
    //var sender: Sender = .creator
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var ignoredExampleIDs: [String] = ["companyRegNum", "employeeNum", "employerLine1", "employerLine2", "employerSuburb", "employerCity", "employerProvince", "employerStreetCode", "workPhoneNum", "previousEmployer", "pEContact", "idxName", "idxIdentityNumber", "idxEntity", "accOneName", "accOneType", "accOneBranchName", "accOneBranchNum", "accOneNum", "accTwoName", "accTwoType", "accTwoBranchName", "accTwoBranchNum", "accTwoNum", "poAName", "poAIdentityNumber", "poAContact"]
    
    var body: some View {
        let binding = Binding<String>(get: {
            text
        }, set: {
            self.text = $0.uppercased()
        })
        
        HStack {
            if question != "" {
                FormLabel(iD: iD,
                          question: question,
                          infoButton: infoButton)
            }
            
            TextField(ignoredExampleIDs.contains(iD) ? "" : "e.g. " + placeholder.uppercased(),
                      text: binding,
                      onEditingChanged: { _ in
                        changedValues.updateKeyValue(iD, value: binding.wrappedValue)
                      },
                      onCommit: commit)
                .foregroundColor(.blue)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}


// MARK: - FormRandTextField
struct FormRandTextField: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
    var infoButton: Bool = false
    var question: String
    var textColor: Color = .primary
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        let binding = Binding<String>(get: {
            text
        }, set: {
            self.text = $0.contains("R") ? $0 : "R" + $0
            if text.contains(",") {
                self.text = text.replacingOccurrences(of: ",", with: "")
            }
        })
        
        HStack {
            FormLabel(iD: iD, question: question, infoButton: infoButton)
            
            TextField("R",
                      text: binding,
                      onEditingChanged: { _ in
                        changedValues.updateKeyValue(iD, value: text == "R" ? "" : text)
                      },
                      onCommit: commit)
                .foregroundColor(.primary)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
        }
    }
}


// MARK: - FormOtherRand
struct FormOtherRand: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
    var infoButton: Bool = false
    var question: String
    var textColor: Color = .primary
    @Binding var other: String
    @Binding var otherText: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        let binding = Binding<String>(get: {
            otherText
        }, set: {
            self.otherText = $0.uppercased()
        })
        
        let randBinding = Binding<String>(get: {
            other
        }, set: {
            self.other = $0.contains("R") ? $0 : "R" + $0
            if other.contains(",") {
                self.other = other.replacingOccurrences(of: ",", with: "")
            }
        })
        
        VStack {
            FormLabel(iD: iD, question: question, infoButton: infoButton)
            
            TextField("R",
                      text: randBinding, onEditingChanged: { _ in updateChangedValues() },
                      onCommit: commit)
                .foregroundColor(.primary)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
            
            TextField("specify...",
                      text: binding, onEditingChanged: { _ in updateChangedValues() },
                      onCommit: commit)
                .foregroundColor(.primary)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .keyboardType(.alphabet)
        }
    }
    
    private func updateChangedValues() {
        changedValues.updateKeyValue(iD, value: "[\(otherText)][\(other == "R" ? "" : other)]")
    }
}


// MARK: - FormLenAt
struct FormLenAt: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
    var infoButton: Bool = false
    var question: String
    var textColor: Color = .primary
    @Binding var yearsText: String
    @Binding var monthsText: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        VStack {
            FormLabel(iD: iD, question: question, infoButton: infoButton)
            
            HStack {
                TextField("",
                          text: $yearsText,
                          onEditingChanged: { _ in addToChangedValues()},
                          onCommit: commit)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Text("Years")
            }
            
            HStack {
                TextField("",
                          text: $monthsText,
                          onEditingChanged: { _ in addToChangedValues()},
                          onCommit: commit)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Text("Months")
            }
        }
    }
    
    func addToChangedValues() {
        if !yearsText.isEmpty || !monthsText.isEmpty { // Either (or both) of the TextFields have a input
            changedValues.updateKeyValue(iD, value: "[\(yearsText)][\(monthsText)]")
        } else { // Neither of the TextFields have a input
            changedValues.updateKeyValue(iD, value: "[][]")
        }
    }
}


// MARK: - FormYesNo
struct FormYesNo: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
    @State var infoButton: Bool = false
    var question: String
    var buttonOneImage: String = "checkmark.circle"
    var buttonTwoImage: String = "checkmark.circle"
    @State var buttonOneText: String
    @State var buttonTwoText: String
    @State var buttonOneChecked: Bool = false
    @State var buttonTwoChecked: Bool = false
    @State var alertShowing: Bool = false
    @Binding var selected: String
    var padding: CGFloat = 10
    
    init(iD: String, infoButton: Bool = false, question: String, selected: Binding<String>, buttonOneText: String = "Yes", buttonTwoText: String = "No") {
        self.iD = iD
        self._infoButton = State(wrappedValue: infoButton)
        self.question = question
        self._buttonOneText = State(wrappedValue: buttonOneText)
        self._buttonTwoText = State(wrappedValue: buttonTwoText)
        self._selected = selected
        if self.selected == self.buttonOneText {
            self._buttonOneChecked = State(wrappedValue: true)
        } else if self.selected == self.buttonTwoText {
            self._buttonTwoChecked = State(wrappedValue: true)
        }
        
        if self.iD == "notificationsCheck" {
            padding = 4
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(question)
                .multilineTextAlignment(.center)
            
            HStack {
                Spacer()
                
                Button(action: {
                    handleButtons(buttonOneText)
                }, label: {
                    if buttonOneChecked || selected == buttonOneText {
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
                
                Spacer()
                
                Button(action: {
                    handleButtons(buttonTwoText)
                }, label: {
                    if buttonTwoChecked || selected == buttonTwoText {
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
                
                Spacer()
            }
            
            if infoButton {
                Button(action: {
                    self.alertShowing = true
                }) {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 22.0, height: 22.0)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .onChange(of: selected == "") { _ in
            buttonOneChecked = false
            buttonTwoChecked = false
        }
        .alert(isPresented: $alertShowing) {
            Alert(title: Text("INFO"), message: Text("something"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func handleButtons(_ checkedButton: String) {
        if checkedButton == buttonOneText {//"Yes" {
            if !buttonOneChecked {
                buttonOneChecked.toggle()
                selected = buttonOneText
            } else {
                buttonOneChecked.toggle()
                selected = ""
            }
            
            if buttonTwoChecked {
                buttonTwoChecked.toggle()
            }
        } else if checkedButton == buttonTwoText {//"No" {
            if !buttonTwoChecked {
                buttonTwoChecked.toggle()
                selected = buttonTwoText
            } else {
                buttonTwoChecked.toggle()
                selected = ""
            }
            
            if buttonOneChecked {
                buttonOneChecked.toggle()
            }
        }
        
        changedValues.updateKeyValue(iD, value: selected)
    }
}

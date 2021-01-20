//
//  CustomStructs.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/01/15.
//

import Foundation
import Combine
import SwiftUI
import Vision
import VisionKit

// MARK: - FormDatePicker
struct FormDatePicker: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
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
                changedValues.updateKeyValue(iD, value: dateSelection)
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
    var question: String
    var selectionOptions: Array<String>
    var infoButton: Bool = false
    @Binding var selection: Int
    
    var body: some View {
        /*HStack() {
            if infoButton {
                Text(question)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)
            }*/
            
            Picker(selection: $selection,
                   label: Text(question)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)) {
                ForEach(0 ..< selectionOptions.count) {
                    Text(self.selectionOptions[$0])
                        .foregroundColor(self.selectionOptions[$0] == "--select--" ? .secondary: .blue)
                }
            }
            .onChange(of: selection) { value in
                changedValues.updateKeyValue(iD, value: selectionOptions[value])
                /*if selection != 0 {
                    changedValues.updateKeyValue(iD, value: selectionOptions[selection])
                } else {
                    changedValues.removeValue(forKey: iD)
                }*/
            }
            
            /*if infoButton {
                Button(action: {
                    
                }) {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 22.0, height: 22.0)
                }
            }
        }
        .buttonStyle(BorderlessButtonStyle())*/
    }
}


// MARK: - FormTextField
struct FormTextField: View {
    @EnvironmentObject var changedValues: ChangedValues
    
    var iD: String
    var question: String
    var placeholder: String
    var textColor: Color = .primary
    @Binding var text: String
    var sender: Sender = .creator
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
    var question: String
    var textColor: Color = .primary
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        let binding = Binding<String>(get: {
            self.text
        }, set: {
            self.text = $0.contains("R") ? $0 : "R" + $0
        })
        
        HStack() {
            Text(question)
            
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
        
        let randBinding = Binding<String>(get: {
            self.other
        }, set: {
            self.other = $0.contains("R") ? $0 : "R" + $0
        })
        
        VStack() {
            HStack() {
                Text(question)
                
                TextField("R",
                          text: randBinding, onEditingChanged: { _ in updateChangedValues() },
                          onCommit: commit)
                    .foregroundColor(.primary)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                }
            
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
                          onEditingChanged: { _ in addToChangedValues()},
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
    var question: String
    let buttonOneText: String = "Yes"
    let buttonTwoText: String = "No"
    var buttonOneImage: String = "checkmark.circle"
    var buttonTwoImage: String = "checkmark.circle"
    @Binding var selected: String
    @State var buttonOneChecked: Bool = false
    @State var buttonTwoChecked: Bool = false
    var padding: CGFloat = 10
    
    init(iD: String, question: String, selected: Binding<String>) {
        self.iD = iD
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
        .onChange(of: selected == "") { _ in
            buttonOneChecked = false
            buttonTwoChecked = false
        }
    }
    
    private func handleButtons(_ checkedButton: String) {
        if checkedButton == "Yes" {
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
        } else if checkedButton == "No" {
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


// MARK: - ScannerView
struct ScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    private let scanName: String
    private let applicationID: UUID
    private let completionHandler: ([String]?) -> Void
        
    init(scanName: String, applicationID: UUID, completion: @escaping ([String]?) -> Void) {
        self.scanName = scanName
        self.applicationID = applicationID
        self.completionHandler = completion
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
        return Coordinator(scanName: self.scanName, applicationID: self.applicationID, completion: completionHandler)
    }
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let scanName: String
        private let applicationID: UUID
        private let completionHandler: ([String]?) -> Void
                
        init(scanName: String, applicationID: UUID, completion: @escaping ([String]?) -> Void) {
            self.scanName = scanName
            self.applicationID = applicationID
            self.completionHandler = completion
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            print("print - Document camera view controller did finish with ", scan)
            for scanIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: scanIndex)
                if let cgImage = image.cgImage {
                    saveImage("\(self.scanName)_image_\(self.applicationID)_\(scanIndex).png", image: UIImage(cgImage: cgImage))
                }
            }
            
            controller.navigationController?.popViewController(animated: true)
            completionHandler(nil)
        }
         
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            // nil
            completionHandler(nil)
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("print - Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
        
        func saveImage(_ imageName: String, image: UIImage) {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

            let fileName = imageName
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            guard let data = image.pngData() else { return }
            
            // Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("print - Removed old image")
                } catch let removeError {
                    print("print - Couldn't remove file at path", removeError)
                }

            }
            
            // Writes the image to the directory
            do {
                try data.write(to: fileURL)
                print("print - Added image to directory: \(fileURL)")
            } catch let error {
                print("print - Error saving file with error", error)
            }

        }
    }
}


// MARK: - CustomTextField
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


// MARK: - PasswordTextField
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


// MARK: - TextFieldAlert
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
                            BackgroundForButton(btnText: "OK", btnColor: .blue)
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


// MARK: - ActivityIndicator
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


// MARK: - LoadingView
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


// MARK: - BackgroundForButton
struct BackgroundForButton: View {
    
    var btnText: String
    var fWidth: CGFloat = 140
    var fHeight: CGFloat = 50
    var btnColor: Color = .blue
    
    var body: some View {
        HStack {
            Text(btnText)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: fWidth, height: fHeight)
                .background(btnColor)
                .clipped()
                .cornerRadius(5.0)
                .shadow(color: btnColor, radius: 5, x: 0, y: 5)
            
        }
    }
}


// MARK: - RichText
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


// MARK: - ShakeEffect
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


// MARK: - GeometryGetter
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
